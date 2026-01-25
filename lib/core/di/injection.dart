import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository_impl.dart';
import 'package:flutter_crypto_wallet/core/service/hive_storage_service.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository_impl.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service.dart';
import 'package:flutter_crypto_wallet/features/home/service/coin_service_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // Services
  final storageService = HiveStorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  getIt.registerLazySingleton<CoinService>(() => CoinServiceImpl());

  // Repositories
  getIt.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(coinService: getIt<CoinService>()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(storage: getIt<StorageService>()),
  );
}
