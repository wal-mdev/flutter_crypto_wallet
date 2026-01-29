import 'package:flutter_crypto_wallet/core/data_source/local/coin_local_data_source.dart';
import 'package:flutter_crypto_wallet/core/data_source/remote/coin_remote_data_source.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin_detail.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_crypto_wallet/core/domain/repository/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource _remoteDataSource;
  final CoinLocalDataSource _localDataSource;

  CoinRepositoryImpl({
    required CoinRemoteDataSource remoteDataSource,
    required CoinLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Stream<List<Coin>?> watchTopCoins() => _localDataSource.watchTopCoins().map(
    (list) => list?.map((m) => m.toEntity()).toList(),
  );

  @override
  Future<Result<List<Coin>, Failure>> getTopCoins({
    int page = 1,
    int perPage = 10,
  }) async {
    // 1. If page 1, check cache
    if (page == 1) {
      final cachedCoins = _localDataSource.getTopCoins();

      if (cachedCoins != null) {
        // Return cache AND start background synchronization
        _syncTopCoins(page: page, perPage: perPage);
        return Success(cachedCoins.map((m) => m.toEntity()).toList());
      }
    }

    // 2. If it's not page 1 or there is no cache, we perform a standard fetch
    try {
      final coins = await _remoteDataSource.getTopCoins(
        page: page,
        perPage: perPage,
      );

      if (page == 1) {
        _localDataSource.saveTopCoins(coins);
      }

      return Success(coins.map((m) => m.toEntity()).toList());
    } on Failure catch (e) {
      return Error(e);
    } catch (e, stackTrace) {
      debugPrint('Erro não tratado em getTopCoins: $e\n$stackTrace');
      return Error(
        UnknownFailure(
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        ),
      );
    }
  }

  /// Hidden background synchronization logic
  Future<void> _syncTopCoins({required int page, required int perPage}) async {
    try {
      final coins = await _remoteDataSource.getTopCoins(
        page: page,
        perPage: perPage,
      );
      if (page == 1) {
        _localDataSource.saveTopCoins(coins);
      }
    } catch (_) {
      // Background sync errors are ignored to avoid disrupting the UI
    }
  }

  @override
  Future<Result<List<Coin>, Failure>> searchCoins(String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return Success([]);

    try {
      // 1. Priority: Try filtering in local cache (Top 150 already loaded)
      final cachedCoins = _localDataSource.getTopCoins();
      if (cachedCoins != null) {
        final localFiltered = cachedCoins.where((coin) {
          return coin.name.toLowerCase().contains(normalizedQuery) ||
              coin.symbol.toLowerCase().contains(normalizedQuery);
        }).toList();

        if (localFiltered.isNotEmpty) {
          return Success(localFiltered.map((m) => m.toEntity()).toList());
        }
      }

      // 2. If not found in local, fallback to Remote Search
      final remoteCoins = await _remoteDataSource.searchCoins(normalizedQuery);
      return Success(remoteCoins.map((m) => m.toEntity()).toList());
    } on Failure catch (e) {
      return Error(e);
    } catch (e, stackTrace) {
      debugPrint('Erro não tratado em searchCoins: $e\n$stackTrace');
      return Error(
        UnknownFailure(
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        ),
      );
    }
  }

  @override
  Future<Result<CoinDetail, Failure>> getCoinDetails(String id) async {
    try {
      final details = await _remoteDataSource.getCoinDetails(id);
      return Success(details.toEntity());
    } on Failure catch (e) {
      return Error(e);
    } catch (e, stackTrace) {
      debugPrint('Erro não tratado em getCoinDetails: $e\n$stackTrace');
      return Error(
        UnknownFailure(
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        ),
      );
    }
  }

  @override
  Future<Result<List<List<double>>, Failure>> getCoinChartData(
    String id,
    String days,
  ) async {
    try {
      final prices = await _remoteDataSource.getCoinChartData(id, days);
      return Success(prices);
    } on Failure catch (e) {
      return Error(e);
    } catch (e, stackTrace) {
      debugPrint('Erro não tratado em getCoinChartData: $e\n$stackTrace');
      return Error(
        UnknownFailure(
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        ),
      );
    }
  }
}
