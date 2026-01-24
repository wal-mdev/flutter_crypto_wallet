import 'package:flutter_crypto_wallet/core/model/coin_model.dart';

abstract interface class FavoritesRepository {
  Future<List<CoinModel>> getFavorites();
  Future<void> addFavorite(CoinModel coin);
  Future<void> removeFavorite(CoinModel coin);
}
