import 'package:flutter_crypto_wallet/features/home/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository_impl.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initInjection() {
  // Services
  getIt.registerLazySingleton<CoinService>(() => CoinServiceImpl());

  // Repositories
  getIt.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(coinService: getIt<CoinService>()),
  );
}
