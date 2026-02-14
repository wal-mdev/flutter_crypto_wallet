import 'package:flutter_crypto_wallet/core/data_source/local/coin_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_crypto_wallet/core/di/network_module.dart';
import 'package:flutter_crypto_wallet/core/data_source/remote/coin_remote_data_source.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/domain/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/coin_repository_impl.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository_impl.dart';
import 'package:flutter_crypto_wallet/core/service/hive_storage_service_impl.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_crypto_wallet/features/favorites/view_model/favorites_view_model.dart';
import 'package:flutter_crypto_wallet/features/home/view_model/home_view_model.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // Services
  final storageService = HiveStorageServiceImpl();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  // Data Sources
  final coinLocalDataSource = CoinLocalDataSourceImpl(
    storage: getIt<StorageService>(),
  );
  await coinLocalDataSource.init();
  getIt.registerLazySingleton<CoinLocalDataSource>(() => coinLocalDataSource);

  getIt.registerLazySingleton<Dio>(() => NetworkModule.provideDio());

  getIt.registerLazySingleton<CoinRemoteDataSource>(
    () => CoinRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(
      remoteDataSource: getIt<CoinRemoteDataSource>(),
      localDataSource: getIt<CoinLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(storage: getIt<StorageService>()),
  );

  // Providers/ViewModels
  getIt.registerSingleton<FavoritesProvider>(
    FavoritesProvider(repository: getIt<FavoritesRepository>()),
  );

  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      repository: getIt<CoinRepository>(),
      favoritesProvider: getIt<FavoritesProvider>(),
    ),
  );

  getIt.registerFactory<FavoritesViewModel>(
    () => FavoritesViewModel(favoritesProvider: getIt<FavoritesProvider>()),
  );

  getIt.registerFactoryParam<DetailsViewModel, Coin, void>(
    (coin, _) => DetailsViewModel(
      repository: getIt<CoinRepository>(),
      favoritesProvider: getIt<FavoritesProvider>(),
      coinId: coin.id,
      coinModel: coin,
    ),
  );
}
