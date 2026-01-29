import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double? priceChangePercentage24h;
  final double? priceChangePercentage7d;
  final double? priceChangePercentage14d;
  final double? priceChangePercentage30d;
  final double? fullyDilutedValuation;
  final List<double> sparkline;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    this.priceChangePercentage24h,
    this.priceChangePercentage7d,
    this.priceChangePercentage14d,
    this.priceChangePercentage30d,
    this.fullyDilutedValuation,
    required this.sparkline,
  });

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    image,
    currentPrice,
    marketCap,
    marketCapRank,
    priceChangePercentage24h,
    priceChangePercentage7d,
    priceChangePercentage14d,
    priceChangePercentage30d,
    fullyDilutedValuation,
    sparkline,
  ];
}
