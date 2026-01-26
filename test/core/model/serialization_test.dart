import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Json Serialization Tests', () {
    test('CoinMarketModel fromJson/toJson roundtrip', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'image': 'url',
        'current_price': 50000.0,
        'market_cap': 1000000.0,
        'market_cap_rank': 1,
        'price_change_percentage_24h': 2.5,
        'sparkline_in_7d': {
          'price': [1.0, 2.0],
        },
      };

      final model = CoinMarketModel.fromJson(json);
      expect(model.id, 'bitcoin');
      expect(model.symbol, 'BTC');

      final resultJson = model.toJson();
      expect(resultJson['id'], 'bitcoin');
      expect(resultJson['current_price'], 50000.0);
      expect(resultJson['sparkline_in_7d']['price'], [1.0, 2.0]);
    });

    test('CoinDetailModel fromJson extracts complex links', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'description': {'en': 'The first crypto'},
        'links': {
          'homepage': ['https://bitcoin.org'],
          'whitepaper': 'https://bitcoin.org/whitepaper.pdf',
          'repos_url': {
            'github': ['https://github.com/bitcoin/bitcoin'],
          },
        },
      };

      final model = CoinDetailModel.fromJson(json);
      expect(model.description, 'The first crypto');
      expect(model.homepage, 'https://bitcoin.org');
      expect(model.github, 'https://github.com/bitcoin/bitcoin');
      expect(model.whitepaper, 'https://bitcoin.org/whitepaper.pdf');
    });
  });
}
