import 'package:flutter_crypto_wallet/core/model/coin.dart';

abstract interface class FavoritesRepository {
  Future<List<Coin>> getFavorites();
  Future<void> addFavorite(Coin coin);
  Future<void> removeFavorite(Coin coin);
}
