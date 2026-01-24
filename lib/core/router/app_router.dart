import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router.dart';
import 'package:flutter_crypto_wallet/core/router/shell_router/shell_router_list.dart';
import 'package:flutter_crypto_wallet/features/details/view/details_view.dart';
import 'package:flutter_crypto_wallet/features/favorites/view/favorites_view.dart';
import 'package:flutter_crypto_wallet/features/home/view/home_view.dart';
import 'package:flutter_crypto_wallet/core/di/injection.dart';
import 'package:flutter_crypto_wallet/features/home/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/features/home/view_model/home_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
              builder: (context, state) {
                return ChangeNotifierProvider(
                  create: (_) =>
                      HomeViewModel(coinRepository: getIt<CoinRepository>()),
                  child: const HomeView(),
                );
              },
            ),
            GoRoute(
              path: Routes.favorites,
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
        GoRoute(
          path: Routes.details,
          builder: (context, state) {
            final coinModel = state.extra as CoinModel;
            return DetailsView(coinModel: coinModel);
          },
        ),
      ],
    );
  }
}
