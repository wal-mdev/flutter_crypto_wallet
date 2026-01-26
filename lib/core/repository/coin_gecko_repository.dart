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

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    // Ensure the base URL is parsed correctly (removing trailing slash if present)
    final base = _config.baseUrl.endsWith('/')
        ? _config.baseUrl.substring(0, _config.baseUrl.length - 1)
        : _config.baseUrl;

    // Construct the final path
    final cleanPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$base$cleanPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<Result<List<CoinMarketModel>, Exception>> getTopCoins({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final uri = _buildUri('coins/markets', {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': perPage,
        'page': page,
        'sparkline': true,
        'price_change_percentage': '24h,7d,14d,30d',
      });

      final response = await http.get(uri, headers: _config.headers);

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
        return Error(
          Exception(
            'Limite de requisições excedido. Tente novamente em breve.',
          ),
        );
      } else {
        return Error(
          Exception(
            'Erro na API (${response.statusCode}): ${response.reasonPhrase}',
          ),
        );
      }
    } catch (e) {
      return Error(Exception('Falha na conexão: $e'));
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
      final searchUri = _buildUri('search', {'query': normalizedQuery});
      final searchResponse = await http.get(
        searchUri,
        headers: _config.headers,
      );

      if (searchResponse.statusCode == 200) {
        final data = json.decode(searchResponse.body);
        final List<dynamic> coinsData = data['coins'] ?? [];
        if (coinsData.isEmpty) return Success([]);

        // Take top 10 IDs to avoid overloading the markets request
        final ids = coinsData.take(10).map((c) => c['id']).join(',');

        // 3. Fetch market data for found IDs
        final marketsUri = _buildUri('coins/markets', {
          'vs_currency': 'usd',
          'ids': ids,
          'sparkline': true,
        });

        final marketsResponse = await http.get(
          marketsUri,
          headers: _config.headers,
        );

        if (marketsResponse.statusCode == 200) {
          final List<dynamic> marketsData = json.decode(marketsResponse.body);
          return Success(
            marketsData.map((j) => CoinMarketModel.fromJson(j)).toList(),
          );
        }
      }
      return Error(Exception('Falha na busca remota'));
    } catch (e) {
      return Error(Exception('Erro ao buscar moedas: $e'));
    }
  }

  Future<Result<CoinDetailModel, Exception>> getCoinDetails(String id) async {
    try {
      final uri = _buildUri('coins/$id', {
        'localization': false,
        'tickers': false,
        'market_data': false,
        'community_data': false,
        'developer_data': false,
        'sparkline': false,
      });

      final response = await http.get(uri, headers: _config.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Success(CoinDetailModel.fromJson(data));
      } else {
        return Error(
          Exception('Erro ao buscar detalhes (${response.statusCode})'),
        );
      }
    } catch (e) {
      return Error(Exception('Falha ao carregar detalhes: $e'));
    }
  }

  Future<Result<List<List<double>>, Exception>> getCoinChartData(
    String id,
    String days,
  ) async {
    try {
      final uri = _buildUri('coins/$id/market_chart', {
        'vs_currency': 'usd',
        'days': days,
      });

      final response = await http.get(uri, headers: _config.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chartData = ChartDataModel.fromJson(data);
        return Success(chartData.prices);
      } else {
        return Error(
          Exception('Erro ao buscar dados do gráfico (${response.statusCode})'),
        );
      }
    } catch (e) {
      return Error(Exception('Falha ao carregar gráfico: $e'));
    }
  }
}
