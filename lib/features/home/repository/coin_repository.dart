import 'package:flutter_crypto_wallet/core/model/coin.dart';

abstract interface class CoinRepository {
  Future<List<Coin>> searchCoins(String query);
}

