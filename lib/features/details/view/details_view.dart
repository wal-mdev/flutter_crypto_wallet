import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/widgets/favorite_button_widget.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/about_widget.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/chart_widget.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/market_statistics_widget.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/period_selector_widget.dart';
import 'package:provider/provider.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({required this.coinModel, super.key});

  final CoinMarketModel coinModel;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailsViewModel>();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          viewModel.titleFormatted,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          FavoriteButtonWidget(
            isFavorite: viewModel.isFavorite,
            onTap: () => viewModel.toggleFavorite(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              viewModel.priceFormatted,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  viewModel.trendIcon,
                  size: 16,
                  color: viewModel.variationColor,
                ),
                const SizedBox(width: 8),
                Text(
                  viewModel.variationFormatted,
                  style: TextStyle(
                    color: viewModel.variationColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ChartWidget(viewModel: viewModel),
            const SizedBox(height: 16),
            PeriodSelectorWidget(viewModel: viewModel),
            const SizedBox(height: 32),
            MarketStatisticsWidget(viewModel: viewModel),
            const SizedBox(height: 32),
            AboutWidget(viewModel: viewModel),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
