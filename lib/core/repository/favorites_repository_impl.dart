import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final StorageService _storage;
  static const _boxName = 'favorites';

  FavoritesRepositoryImpl({required StorageService storage})
    : _storage = storage;

  @override
  Future<Result<List<CoinMarketModel>, Exception>> getAll() async {
    try {
      final maps = await _storage.getAll<Map<dynamic, dynamic>>(_boxName);
      final list = maps
          .map((m) => CoinMarketModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      return Success(list);
    } catch (e) {
      return Error(Exception('Erro ao buscar favoritos: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> add(CoinMarketModel coin) async {
    try {
      await _storage.save(_boxName, coin.id, coin.toJson());
      return Success(null);
    } catch (e) {
      return Error(Exception('Erro ao adicionar favorito: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> remove(CoinMarketModel coin) async {
    try {
      await _storage.delete(_boxName, coin.id);
      return Success(null);
    } catch (e) {
      return Error(Exception('Erro ao remover favorito: $e'));
    }
  }
}
