import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/result.dart';

abstract interface class CoinService {
  Future<Result<List<CoinModel>, Exception>> searchCoins(String query);
}
