import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/model/chart_data_model.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinMarketModel>> getTopCoins({int page = 1, int perPage = 10});
  Future<List<CoinMarketModel>> searchCoins(String query);
  Future<CoinDetailModel> getCoinDetails(String id);
  Future<List<List<double>>> getCoinChartData(String id, String days);
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final Dio _dio;

  CoinRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  Future<T> _performRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) mapper,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return mapper(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('Falha na conexão. Verifique sua internet.');
      } else if (e.response != null) {
        // Log technical details
        debugPrint(
          'Server Error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );

        if (e.response?.statusCode == 429) {
          throw ServerFailure(
            statusCode: 429,
            message: 'Muitas requisições. Tente novamente em instantes.',
          );
        }

        throw ServerFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'Erro no servidor. Tente novamente mais tarde.',
        );
      } else {
        // Log technical details
        debugPrint('Dio Error: ${e.message}');
        throw const UnknownFailure(
          'Ocorreu um erro inesperado. Tente novamente.',
        );
      }
    } catch (e, stackTrace) {
      // Log technical details
      debugPrint('Unknown Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      throw const UnknownFailure(
        'Ocorreu um erro inesperado. Tente novamente.',
      );
    }
  }

  @override
  Future<List<CoinMarketModel>> getTopCoins({
    int page = 1,
    int perPage = 10,
  }) async {
    return _performRequest(
      '/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': perPage,
        'page': page,
        'sparkline': true,
        'price_change_percentage': '24h,7d,14d,30d',
      },
      mapper: (data) {
        final List<dynamic> list = data;
        return list.map((json) => CoinMarketModel.fromJson(json)).toList();
      },
    );
  }

  @override
  Future<List<CoinMarketModel>> searchCoins(String query) async {
    // 1. Search for IDs
    final searchResult = await _performRequest(
      '/search',
      queryParameters: {'query': query},
      mapper: (data) => data,
    );

    final List<dynamic> coinsData = searchResult['coins'] ?? [];
    if (coinsData.isEmpty) return [];

    final ids = coinsData.take(10).map((c) => c['id']).join(',');

    // 2. Fetch full market data for IDs
    return _performRequest(
      '/coins/markets',
      queryParameters: {'vs_currency': 'usd', 'ids': ids, 'sparkline': true},
      mapper: (data) {
        final List<dynamic> marketsList = data;
        return marketsList.map((j) => CoinMarketModel.fromJson(j)).toList();
      },
    );
  }

  @override
  Future<CoinDetailModel> getCoinDetails(String id) async {
    return _performRequest(
      '/coins/$id',
      queryParameters: {
        'localization': false,
        'tickers': false,
        'market_data': false,
        'community_data': false,
        'developer_data': false,
        'sparkline': false,
      },
      mapper: (data) => CoinDetailModel.fromJson(data),
    );
  }

  @override
  Future<List<List<double>>> getCoinChartData(String id, String days) async {
    return _performRequest(
      '/coins/$id/market_chart',
      queryParameters: {'vs_currency': 'usd', 'days': days},
      mapper: (data) {
        final chartData = ChartDataModel.fromJson(data);
        return chartData.prices;
      },
    );
  }
}
