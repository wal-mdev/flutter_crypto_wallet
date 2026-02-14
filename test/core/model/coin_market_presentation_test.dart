import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mocks.dart';

void main() {
  group('CoinMarketPresentation Tests', () {
    test('priceFormatted formats correctly for low value coins', () {
      final coin = createMockCoin(currentPrice: 0.0001234);
      expect(coin.priceFormatted, '\$0.0001');
    });

    test('priceFormatted formats correctly for high value coins', () {
      final coin = createMockCoin(currentPrice: 50250.75);
      expect(coin.priceFormatted, '\$50,250.75');
    });

    test('variationFormatted shows plus sign for positive variation', () {
      final coin = createMockCoin(priceChange: 2.55);
      expect(coin.variationFormatted, '+2.55%');
    });

    test('variationFormatted shows minus sign for negative variation', () {
      final coin = createMockCoin(priceChange: -1.4);
      expect(coin.variationFormatted, '-1.40%');
    });

    test('isPositive returns correct boolean', () {
      final posCoin = createMockCoin(priceChange: 0.1);
      final negCoin = createMockCoin(priceChange: -0.1);

      expect(posCoin.isPositive, true);
      expect(negCoin.isPositive, false);
    });

    test('variationColor returns green for positive and red for negative', () {
      final posCoin = createMockCoin(priceChange: 1.0);
      final negCoin = createMockCoin(priceChange: -1.0);

      expect(posCoin.variationColor, Colors.green);
      expect(negCoin.variationColor, Colors.redAccent);
    });
  });
}
