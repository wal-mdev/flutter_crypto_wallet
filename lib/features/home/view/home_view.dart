import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/router/routes.dart';
import 'package:flutter_crypto_wallet/core/widgets/coin_list_widget.dart';
import 'package:flutter_crypto_wallet/core/widgets/command_builder_widget.dart';
import 'package:flutter_crypto_wallet/features/home/view_model/home_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    _searchController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadCoinsCommand.execute(false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        title: const Text('BrasilCard Cripto'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Próxima atualização em ${viewModel.formattedCountdown}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Pesquisar pelo nome ou símbolo...',
              onChanged: viewModel.onSearchChanged,
              leading: const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Icon(Icons.search),
              ),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.clearSearch();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: CommandBuilderWidget<List<Coin>, Failure>(
              command: viewModel.activeCommand,
              initialBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              emptyBuilder: (context) =>
                  const Center(child: Text('Nenhuma criptomoeda encontrada')),
              successBuilder: (context, coins) {
                final displayCoins = viewModel.isSearching
                    ? coins
                    : viewModel.coins;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!viewModel.isSearching)
                      const Padding(
                        padding: EdgeInsets.only(top: 32, left: 16, bottom: 16),
                        child: Text(
                          'Top 150 Market Cap',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Expanded(
                      child: CoinListWidget(
                        coins: displayCoins,
                        isFavorite: viewModel.isFavorite,
                        onFavoriteTap: (coin) =>
                            viewModel.toggleFavorite(context, coin),
                        onTap: (coin) =>
                            context.push(Routes.details, extra: coin),
                      ),
                    ),
                  ],
                );
              },
              onRetry: () => viewModel.loadCoinsCommand.execute(true),
            ),
          ),
        ],
      ),
    );
  }
}
