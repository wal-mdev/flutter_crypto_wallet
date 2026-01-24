import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service.dart';

class CoinServiceImpl implements CoinService {
  final List<CoinModel> _mockCoins = [
    const CoinModel(
      name: 'Bitcoin',
      symbol: 'BTC',
      price: 65000.0,
      variation: 2.5,
      volume: 35000000000.0,
    ),
    const CoinModel(
      name: 'Ethereum',
      symbol: 'ETH',
      price: 3500.0,
      variation: -1.2,
      volume: 15000000000.0,
    ),
    const CoinModel(
      name: 'Solana',
      symbol: 'SOL',
      price: 145.0,
      variation: 5.8,
      volume: 4000000000.0,
    ),
    const CoinModel(
      name: 'Cardano',
      symbol: 'ADA',
      price: 0.45,
      variation: 0.5,
      volume: 500000000.0,
    ),
  ];

  @override
  Future<Result<List<CoinModel>, Exception>> searchCoins(String query) async {
    if (query.isEmpty) return Success([]);

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final results = _mockCoins.where((coin) {
        final nameMatches = coin.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final symbolMatches = coin.symbol.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatches || symbolMatches;
      }).toList();

      return Success(results);
    } catch (e) {
      return Error(Exception('Erro ao buscar moedas: $e'));
    }
  }
}
