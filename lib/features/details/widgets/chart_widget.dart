import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/widgets/command_builder_widget.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({required this.viewModel, super.key});

  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: CommandBuilderWidget<List<List<double>>, Exception>(
        command: viewModel.loadChartCommand,
        initialBuilder: (_) => const Center(child: CircularProgressIndicator()),
        successBuilder: (context, prices) {
          final spots = viewModel.getChartSpots(prices);
          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: viewModel.variationColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        viewModel.variationColor.withValues(alpha: 0.3),
                        viewModel.variationColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        errorBuilder: (context, error) => Center(
          child: Text(
            'Erro ao carregar dados do gráfico',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}
