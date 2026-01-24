import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_model.dart';

abstract final class ShellRouterList {
  static const routerList = [
    ShellRouterModel(
      routerTitle: 'Início',
      routerIcon: Icons.home,
      routerPath: Routes.home,
    ),
    ShellRouterModel(
      routerTitle: 'Favoritos',
      routerIcon: Icons.favorite,
      routerPath: Routes.favorites,
    ),
    ShellRouterModel(
      routerTitle: 'Detalhes',
      routerIcon: Icons.menu,
      routerPath: Routes.details,
    ),
  ];
}
