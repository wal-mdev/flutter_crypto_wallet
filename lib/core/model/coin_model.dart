class CoinModel {
  final String name;
  final String symbol;
  final double price;
  final double variation;
  final double volume;

  const CoinModel({
    required this.name,
    required this.symbol,
    required this.price,
    required this.variation,
    required this.volume,
  });
}
