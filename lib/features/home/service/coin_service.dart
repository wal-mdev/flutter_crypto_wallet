import 'package:flutter_crypto_wallet/core/model/coin_model.dart';

abstract interface class CoinService {
  Future<List<CoinModel>> searchCoins(String query);
}
