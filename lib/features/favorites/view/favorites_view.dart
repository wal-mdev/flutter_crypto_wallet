import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/widgets/coin_list_widget.dart';
import 'package:flutter_crypto_wallet/core/widgets/command_builder_widget.dart';
import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/features/favorites/view_model/favorites_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        title: const Text('Meus Favoritos'),
      ),
      body: CommandBuilderWidget<List<CoinMarketModel>, Exception>(
        command: viewModel.favoritesProvider.loadCommand,
        emptyBuilder: (_) =>
            const Center(child: Text('Você ainda não tem moedas favoritas')),
        successBuilder: (context, coins) {
          return CoinListWidget(
            coins: coins,
            isFavorite: (_) => true,
            onFavoriteTap: (coin) => viewModel.toggleFavorite(context, coin),
            onTap: (coin) => context.push(Routes.details, extra: coin),
          );
        },
        errorBuilder: (context, error) =>
            Center(child: Text('Erro ao carregar favoritos: $error')),
      ),
    );
  }
}
