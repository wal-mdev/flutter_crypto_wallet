import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/di/injection.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initInjection();

  final router = AppRouter.create();

  runApp(
    ChangeNotifierProvider.value(
      value: getIt<FavoritesProvider>(),
      child: CryptoWalletApp(routerConfig: router),
    ),
  );
}

class CryptoWalletApp extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const CryptoWalletApp({required this.routerConfig, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: routerConfig);
  }
}
