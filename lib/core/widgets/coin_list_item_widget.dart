import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_presentation.dart';
import 'package:flutter_crypto_wallet/core/widgets/favorite_button_widget.dart';

class CoinListItemWidget extends StatelessWidget {
  final CoinMarketModel coin;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const CoinListItemWidget({
    required this.coin,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Coin Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  coin.image,
                  width: 40,
                  height: 40,
                  cacheWidth: 100,
                  cacheHeight: 100,
                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[800],
                    child: Text(coin.symbol[0]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name & Symbol
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      coin.symbol,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Sparkline (Mini Chart)
              if (coin.sparkline.isNotEmpty)
                SizedBox(
                  width: 60,
                  height: 30,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: coin.sparkline.length.toDouble() - 1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: coin.sparklineSpots,
                          isCurved: true,
                          color: coin.variationColor,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: coin.variationColor.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Price & Variation
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      coin.priceFormatted,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          coin.isPositive
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 14,
                          color: coin.variationColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          coin.variationFormatted,
                          style: TextStyle(
                            color: coin.variationColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Favorite Icon
              FavoriteButtonWidget(
                isFavorite: isFavorite,
                onTap: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
