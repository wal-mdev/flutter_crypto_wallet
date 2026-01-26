import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/coin_gecko_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository_impl.dart';
import 'package:flutter_crypto_wallet/core/service/hive_storage_service_impl.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // Services
  final storageService = HiveStorageServiceImpl();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  // Repositories
  getIt.registerLazySingleton<CoinGeckoRepository>(() => CoinGeckoRepository());
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(storage: getIt<StorageService>()),
  );

  // Providers/ViewModels
  getIt.registerSingleton<FavoritesProvider>(
    FavoritesProvider(repository: getIt<FavoritesRepository>()),
  );
}
