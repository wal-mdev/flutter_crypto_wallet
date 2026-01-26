import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_crypto_wallet/core/config/app_config.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/model/chart_data_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

class CoinGeckoRepository {
  static final CoinGeckoRepository _instance = CoinGeckoRepository._internal();
  factory CoinGeckoRepository() => _instance;
  CoinGeckoRepository._internal();

  AppConfig get _config => AppConfig();

  // In-memory cache to avoid repeated requests and speed up search
  List<CoinMarketModel>? _cachedCoins;

  Future<Result<List<CoinMarketModel>, Exception>> getTopCoins({
    int page = 1,
    int perPage = 10,
    bool forceRefresh = false,
  }) async {
    try {
      final url =
          '${_config.baseUrl}/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=true&price_change_percentage=24h,7d,14d,30d';

      final response = await http.get(Uri.parse(url), headers: _config.headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final coins = data
            .map((json) => CoinMarketModel.fromJson(json))
            .toList();

        // Populate cache on initial load
        if (page == 1) {
          _cachedCoins = coins;
        }

        return Success(coins);
      } else if (response.statusCode == 429) {
        return Error(Exception('Rate limit exceeded. Please try again later.'));
      } else {
        return Error(
          Exception(
            'API Error (${response.statusCode}): ${response.reasonPhrase}',
          ),
        );
      }
    } catch (e) {
      return Error(Exception('Connection failed: $e'));
    }
  }

  Future<Result<List<CoinMarketModel>, Exception>> searchCoins(
    String query,
  ) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return Success([]);

    try {
      // 1. Priority: Try filtering in local cache (Top 150 already loaded)
      if (_cachedCoins != null) {
        final localFiltered = _cachedCoins!.where((coin) {
          return coin.name.toLowerCase().contains(normalizedQuery) ||
              coin.symbol.toLowerCase().contains(normalizedQuery);
        }).toList();

        if (localFiltered.isNotEmpty) {
          return Success(localFiltered);
        }
      }

      // 2. If not found in Top 150, fallback to Global API Search
      final searchUrl = '${_config.baseUrl}/search?query=$normalizedQuery';
      final searchResponse = await http.get(
        Uri.parse(searchUrl),
        headers: _config.headers,
      );

      if (searchResponse.statusCode == 200) {
        final data = json.decode(searchResponse.body);
        final List<dynamic> coinsData = data['coins'] ?? [];
        if (coinsData.isEmpty) return Success([]);

        // Take top 10 IDs to avoid overloading the markets request
        final ids = coinsData.take(10).map((c) => c['id']).join(',');

        // 3. Fetch market data for found IDs
        final marketsUrl =
            '${_config.baseUrl}/coins/markets?vs_currency=usd&ids=$ids&sparkline=true';
        final marketsResponse = await http.get(
          Uri.parse(marketsUrl),
          headers: _config.headers,
        );

        if (marketsResponse.statusCode == 200) {
          final List<dynamic> marketsData = json.decode(marketsResponse.body);
          return Success(
            marketsData.map((j) => CoinMarketModel.fromJson(j)).toList(),
          );
        }
      }
      return Error(Exception('Global search failed'));
    } catch (e) {
      return Error(Exception('Error searching coins: $e'));
    }
  }

  Future<Result<CoinDetailModel, Exception>> getCoinDetails(String id) async {
    try {
      final url =
          '${_config.baseUrl}/coins/$id?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false';

      final response = await http.get(Uri.parse(url), headers: _config.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Success(CoinDetailModel.fromJson(data));
      } else {
        return Error(
          Exception('Error fetching details (${response.statusCode})'),
        );
      }
    } catch (e) {
      return Error(Exception('Failed to load details: $e'));
    }
  }

  Future<Result<List<List<double>>, Exception>> getCoinChartData(
    String id,
    String days,
  ) async {
    try {
      final url =
          '${_config.baseUrl}/coins/$id/market_chart?vs_currency=usd&days=$days';
      final response = await http.get(Uri.parse(url), headers: _config.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chartData = ChartDataModel.fromJson(data);
        return Success(chartData.prices);
      } else {
        return Error(
          Exception('Error fetching chart data (${response.statusCode})'),
        );
      }
    } catch (e) {
      return Error(Exception('Failed to load chart: $e'));
    }
  }
}
