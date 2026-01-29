import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';

abstract class CoinCacheService {
  Future<void> init();
  List<CoinMarketModel>? getTopCoins();
  void saveTopCoins(List<CoinMarketModel> coins);
  void clear();
}
