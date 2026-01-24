import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_list.dart';
import 'package:flutter_crypto_wallet/features/details/view/details_view.dart';
import 'package:flutter_crypto_wallet/features/favorites/view/favorites_view.dart';
import 'package:flutter_crypto_wallet/features/home/view/home_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return ShellRouter(
              routes: ShellRouterList.routerList,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeView(),
            ),
            GoRoute(
              path: Routes.favorites,
              builder: (context, state) => const FavoritesView(),
            ),
            GoRoute(
              path: Routes.details,
              builder: (context, state) => const DetailsView(),
            ),
          ],
        ),
      ],
    );
  }
}
