import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/di/injection.dart';
import 'package:flutter_crypto_wallet/core/router/app_router.dart';

void main() {
  initInjection();
  runApp(const CryptoWalletApp());
}

final router = AppRouter.create();

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
