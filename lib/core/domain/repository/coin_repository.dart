import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin_detail.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

abstract class CoinRepository {
  Stream<List<Coin>?> watchTopCoins();

  Future<Result<List<Coin>, Failure>> getTopCoins({
    int page = 1,
    int perPage = 10,
  });

  Future<Result<List<Coin>, Failure>> searchCoins(String query);

  Future<Result<CoinDetail, Failure>> getCoinDetails(String id);

  Future<Result<List<List<double>>, Failure>> getCoinChartData(
    String id,
    String days,
  );
}
