import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinService _coinService;

  CoinRepositoryImpl({required CoinService coinService})
    : _coinService = coinService;

  @override
  Future<Result<List<CoinModel>, Exception>> searchCoins(String query) {
    return _coinService.searchCoins(query);
  }
}
