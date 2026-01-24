import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  @override
  Future<List<CoinModel>> getFavorites() {
    throw UnimplementedError();
  }

  @override
  Future<void> addFavorite(CoinModel coin) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(CoinModel coin) {
    throw UnimplementedError();
  }
}
