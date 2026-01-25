import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/di/injection.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/router/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          FavoritesProvider(repository: getIt<FavoritesRepository>()),
      child: const CryptoWalletApp(),
    ),
  );
}

final router = AppRouter.create();

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
