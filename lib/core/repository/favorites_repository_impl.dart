import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final StorageService _storage;
  static const _boxName = 'favorites';

  FavoritesRepositoryImpl({required StorageService storage})
    : _storage = storage;

  @override
  Future<Result<List<Coin>, Failure>> getAll() async {
    try {
      final maps = await _storage.getAll<Map<dynamic, dynamic>>(_boxName);
      final list = maps
          .map((m) => CoinMarketModel.fromJson(Map<String, dynamic>.from(m)))
          .map((m) => m.toEntity())
          .toList();
      return Success(list);
    } catch (e) {
      return Error(CacheFailure('Erro ao buscar favoritos: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> add(Coin coin) async {
    try {
      // Map entity back to model for storage (using a helper or recreating model)
      // Since we don't have fromEntity in Model yet, we can create a simple map
      // But ideally we should have a mapper. For now, we will assume we only store essential fields
      // Or safer: We need CoinModel.fromEntity. OR we just manually create the map here.
      // Better approach: Usage CoinMarketModel.fromEntity(coin) if it existed.
      // Let's create a temporary CoinMarketModel from Coin to usage toJson
      final model = CoinMarketModel(
        id: coin.id,
        symbol: coin.symbol,
        name: coin.name,
        image: coin.image,
        currentPrice: coin.currentPrice,
        marketCap: coin.marketCap,
        marketCapRank: coin.marketCapRank,
        priceChangePercentage24h: coin.priceChangePercentage24h,
        priceChangePercentage7d: coin.priceChangePercentage7d,
        priceChangePercentage14d: coin.priceChangePercentage14d,
        priceChangePercentage30d: coin.priceChangePercentage30d,
        fullyDilutedValuation: coin.fullyDilutedValuation,
        sparkline: coin.sparkline,
      );

      await _storage.save(_boxName, coin.id, model.toJson());
      return Success(null);
    } catch (e) {
      return Error(CacheFailure('Erro ao adicionar favorito: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> remove(Coin coin) async {
    try {
      await _storage.delete(_boxName, coin.id);
      return Success(null);
    } catch (e) {
      return Error(CacheFailure('Erro ao remover favorito: $e'));
    }
  }
}
