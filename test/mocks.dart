import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/coin_gecko_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockCoinGeckoRepository extends Mock implements CoinGeckoRepository {}

class MockFavoritesProvider extends Mock implements FavoritesProvider {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class FakeCoinMarketModel extends Fake implements CoinMarketModel {}

void registerTestFallbacks() {
  registerFallbackValue(FakeCoinMarketModel());
}

CoinMarketModel createMockCoin({
  String id = 'bitcoin',
  String symbol = 'BTC',
  String name = 'Bitcoin',
  double currentPrice = 50000.0,
  double priceChange = 2.5,
}) {
  return CoinMarketModel(
    id: id,
    symbol: symbol,
    name: name,
    image: 'https://example.com/image.png',
    currentPrice: currentPrice,
    marketCap: 1000000000000.0,
    marketCapRank: 1,
    priceChangePercentage24h: priceChange,
    sparkline: [1.0, 2.0, 3.0],
  );
}
