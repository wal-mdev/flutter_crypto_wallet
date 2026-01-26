import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/statistic_card_widget.dart';

class MarketStatisticsWidget extends StatelessWidget {
  const MarketStatisticsWidget({required this.viewModel, super.key});

  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas de Mercado',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatisticCardWidget(
                label: 'Market Cap',
                value: viewModel.marketCapFormatted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticCardWidget(
                label: 'Valuation (FDV)',
                value: viewModel.fdvFormatted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
