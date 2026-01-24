import 'package:flutter_crypto_wallet/core/model/coin.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinService _coinService;

  CoinRepositoryImpl({required CoinService coinService})
    : _coinService = coinService;

  @override
  Future<List<Coin>> searchCoins(String query) {
    return _coinService.searchCoins(query);
  }
}
