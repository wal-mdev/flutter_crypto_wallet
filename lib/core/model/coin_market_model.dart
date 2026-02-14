import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';

class CoinMarketModel {
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

  CoinMarketModel({
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

  factory CoinMarketModel.fromJson(Map<String, dynamic> json) {
    final sparklineData =
        (json['sparkline_in_7d']?['price'] as List?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [];

    return CoinMarketModel(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)
          ?.toDouble(),
      priceChangePercentage7d:
          (json['price_change_percentage_7d_in_currency'] as num?)?.toDouble(),
      priceChangePercentage14d:
          (json['price_change_percentage_14d_in_currency'] as num?)?.toDouble(),
      priceChangePercentage30d:
          (json['price_change_percentage_30d_in_currency'] as num?)?.toDouble(),
      fullyDilutedValuation: (json['fully_diluted_valuation'] as num?)
          ?.toDouble(),
      sparkline: sparklineData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_percentage_24h': priceChangePercentage24h,
      'price_change_percentage_7d_in_currency': priceChangePercentage7d,
      'price_change_percentage_14d_in_currency': priceChangePercentage14d,
      'price_change_percentage_30d_in_currency': priceChangePercentage30d,
      'fully_diluted_valuation': fullyDilutedValuation,
      'sparkline_in_7d': {'price': sparkline},
    };
  }

  Coin toEntity() {
    return Coin(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: marketCapRank,
      priceChangePercentage24h: priceChangePercentage24h,
      priceChangePercentage7d: priceChangePercentage7d,
      priceChangePercentage14d: priceChangePercentage14d,
      priceChangePercentage30d: priceChangePercentage30d,
      fullyDilutedValuation: fullyDilutedValuation,
      sparkline: sparkline,
    );
  }
}
