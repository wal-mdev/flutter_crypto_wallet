import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/data_source/local/coin_local_data_source.dart';
import 'package:flutter_crypto_wallet/core/data_source/remote/coin_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';

import 'package:flutter_crypto_wallet/core/domain/repository/coin_repository.dart';

class MockCoinRepository extends Mock implements CoinRepository {}

class MockFavoritesProvider extends Mock implements FavoritesProvider {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockCoinRemoteDataSource extends Mock implements CoinRemoteDataSource {}

class MockCoinLocalDataSource extends Mock implements CoinLocalDataSource {}

class FakeCoin extends Fake implements Coin {}

class FakeCoinMarketModel extends Fake implements CoinMarketModel {}

void registerTestFallbacks() {
  registerFallbackValue(FakeCoin());
  registerFallbackValue(FakeCoinMarketModel());
}

CoinMarketModel createMockCoinModel({
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
    priceChangePercentage7d: priceChange * 2,
    priceChangePercentage14d: priceChange * 3,
    priceChangePercentage30d: priceChange * 4,
    sparkline: [1.0, 2.0, 3.0],
  );
}

Coin createMockCoin({
  String id = 'bitcoin',
  String symbol = 'BTC',
  String name = 'Bitcoin',
  double currentPrice = 50000.0,
  double priceChange = 2.5,
}) {
  return createMockCoinModel(
    id: id,
    symbol: symbol,
    name: name,
    currentPrice: currentPrice,
    priceChange: priceChange,
  ).toEntity();
}
