import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'coin.dart';

extension CoinPresentation on Coin {
  bool get isPositive => (priceChangePercentage24h ?? 0) >= 0;

  // Note: This might shadow Coin.priceFormatted if it exists.
  String get priceFormatted {
    final format = currentPrice < 1 ? "#,##0.0000" : "#,##0.00";
    return '\$${NumberFormat(format).format(currentPrice)}';
  }

  String get variationFormatted {
    return '${isPositive ? '+' : ''}${priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%';
  }

  Color get variationColor => isPositive ? Colors.green : Colors.redAccent;

  IconData get trendIcon =>
      isPositive ? Icons.trending_up : Icons.trending_down;

  List<FlSpot> get sparklineSpots => sparkline
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value))
      .toList();

  String get marketCapFormatted => '\$${_formatLargeNumber(marketCap)}';

  String get fdvFormatted => fullyDilutedValuation != null
      ? '\$${_formatLargeNumber(fullyDilutedValuation!)}'
      : 'N/A';

  String _formatLargeNumber(double number) {
    if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(2)}T';
    }
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    }
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    }
    return NumberFormat("#,##0").format(number);
  }
}
