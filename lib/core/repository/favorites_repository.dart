import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

abstract interface class FavoritesRepository {
  Future<Result<List<Coin>, Failure>> getAll();
  Future<Result<void, Failure>> add(Coin coin);
  Future<Result<void, Failure>> remove(Coin coin);
}
