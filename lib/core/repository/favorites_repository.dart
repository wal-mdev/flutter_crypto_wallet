import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

abstract interface class FavoritesRepository {
  Future<Result<List<CoinMarketModel>, Exception>> getAll();
  Future<Result<void, Exception>> add(CoinMarketModel coin);
  Future<Result<void, Exception>> remove(CoinMarketModel coin);
}
