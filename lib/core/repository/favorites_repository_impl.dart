import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final StorageService _storage;
  static const _boxName = 'favorites';

  FavoritesRepositoryImpl({required StorageService storage})
    : _storage = storage;

  @override
  Future<Result<List<CoinModel>, Exception>> getAll() async {
    try {
      final maps = await _storage.getAll<Map<dynamic, dynamic>>(_boxName);
      final list = maps.map((m) => CoinModel.fromJson(m)).toList();
      return Success(list);
    } catch (e) {
      return Error(Exception('Erro ao buscar favoritos: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> add(CoinModel coin) async {
    try {
      await _storage.save(_boxName, coin.symbol, coin.toJson());
      return Success(null);
    } catch (e) {
      return Error(Exception('Erro ao adicionar favorito: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> remove(CoinModel coin) async {
    try {
      await _storage.delete(_boxName, coin.symbol);
      return Success(null);
    } catch (e) {
      return Error(Exception('Erro ao remover favorito: $e'));
    }
  }
}
