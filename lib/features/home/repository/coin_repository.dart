import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

abstract interface class CoinRepository {
  Future<Result<List<CoinModel>, Exception>> searchCoins(String query);
}
