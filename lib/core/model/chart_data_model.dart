class ChartDataModel {
  final List<List<double>> prices;

  ChartDataModel({required this.prices});

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    final pricesRaw = json['prices'] as List? ?? [];
    final prices = pricesRaw.map((e) {
      final pair = e as List;
      return [
        (pair[0] as num).toDouble(), // timestamp
        (pair[1] as num).toDouble(), // price
      ];
    }).toList();

    return ChartDataModel(prices: prices);
  }
}
