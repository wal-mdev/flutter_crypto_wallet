import 'package:flutter_crypto_wallet/core/model/coin.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  @override
  Future<List<Coin>> getFavorites() {
    throw UnimplementedError();
  }

  @override
  Future<void> addFavorite(Coin coin) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(Coin coin) {
    throw UnimplementedError();
  }
}
