import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

abstract interface class FavoritesRepository {
  Future<Result<List<CoinModel>, Exception>> getAll();
  Future<Result<void, Exception>> add(CoinModel coin);
  Future<Result<void, Exception>> remove(CoinModel coin);
}
