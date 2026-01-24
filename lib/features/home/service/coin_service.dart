import 'package:flutter_crypto_wallet/core/model/coin.dart';

abstract interface class CoinService {
  Future<List<Coin>> searchCoins(String query);
}
