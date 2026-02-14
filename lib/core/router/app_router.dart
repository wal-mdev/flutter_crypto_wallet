import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_list.dart';
import 'package:flutter_crypto_wallet/features/details/view/details_view.dart';
import 'package:flutter_crypto_wallet/features/favorites/view/favorites_view.dart';
import 'package:flutter_crypto_wallet/features/home/view/home_view.dart';
import 'package:flutter_crypto_wallet/core/di/injection.dart';
import 'package:flutter_crypto_wallet/features/home/view_model/home_view_model.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_crypto_wallet/features/favorites/view_model/favorites_view_model.dart';
import 'package:flutter_crypto_wallet/features/splash/view/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(
          path: Routes.splash,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SplashView()),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ShellRouter(
              routes: ShellRouterList.routerList,
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.home,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: ChangeNotifierProvider(
                        create: (_) => getIt<HomeViewModel>(),
                        child: const HomeView(),
                      ),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.favorites,
                  builder: (context, state) {
                    return ChangeNotifierProvider(
                      create: (_) => getIt<FavoritesViewModel>(),
                      child: const FavoritesView(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: Routes.details,
          builder: (context, state) {
            final coin = state.extra as Coin;
            return ChangeNotifierProvider(
              create: (_) => getIt<DetailsViewModel>(param1: coin),
              child: DetailsView(coin: coin),
            );
          },
        ),
      ],
    );
  }
}
