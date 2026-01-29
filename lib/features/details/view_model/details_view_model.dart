import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin_detail.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin_presentation.dart';
import 'package:flutter_crypto_wallet/core/domain/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class DetailsViewModel extends ChangeNotifier {
  final CoinRepository _repository;
  final FavoritesProvider _favoritesProvider;
  final String coinId;
  final Coin coinModel;
  StreamSubscription? _favoritesSubscription;

  DetailsViewModel({
    required CoinRepository repository,
    required FavoritesProvider favoritesProvider,
    required this.coinId,
    required this.coinModel,
  }) : _repository = repository,
       _favoritesProvider = favoritesProvider {
    loadDetailsCommand = Command0(() => _repository.getCoinDetails(coinId));
    loadChartCommand = Command1(
      (String days) => _repository.getCoinChartData(coinId, days),
    );

    // Listen to favorite changes using Streams
    _favoritesSubscription = _favoritesProvider.favoritesStream.listen((_) {
      notifyListeners();
    });

    // Initial fetch for 24h chart (default)
    loadChartCommand.execute('1');
    loadDetailsCommand.execute();
  }

  late final Command0<CoinDetail, Failure> loadDetailsCommand;

  late final Command1<List<List<double>>, Failure, String> loadChartCommand;

  static const periods = {'1': '24h', '7': '7d', '14': '14d', '30': '30d'};

  static const descriptionEmpty =
      'Nenhuma descrição disponível para esta criptomoeda.';

  static const errorOpenLink = 'Não foi possível abrir o link';

  String _selectedPeriod = '1';

  String get selectedPeriod => _selectedPeriod;

  bool get isFavorite => _favoritesProvider.isFavorite(coinModel);

  bool get isPositive => (variationPercentage ?? 0) >= 0;

  String get titleFormatted => '${coinModel.name} (${coinModel.symbol})';

  String get priceFormatted => coinModel.priceFormatted;

  double? get variationPercentage {
    return switch (selectedPeriod) {
      '1' => coinModel.priceChangePercentage24h,
      '7' => coinModel.priceChangePercentage7d,
      '14' => coinModel.priceChangePercentage14d,
      '30' => coinModel.priceChangePercentage30d,
      _ => coinModel.priceChangePercentage24h,
    };
  }

  String get variationFormatted {
    final variation = variationPercentage;
    if (variation != null) {
      return '${variation >= 0 ? '+' : ''}${variation.toStringAsFixed(2)}%';
    }
    return '0.00%';
  }

  Color get variationColor => isPositive ? Colors.green : Colors.redAccent;

  IconData get trendIcon =>
      isPositive ? Icons.trending_up : Icons.trending_down;

  String get marketCapFormatted => coinModel.marketCapFormatted;

  String get fdvFormatted => coinModel.fdvFormatted;

  void setPeriod(String days) {
    if (_selectedPeriod == days) return;
    _selectedPeriod = days;
    loadChartCommand.execute(days);
    notifyListeners();
  }

  void toggleFavorite(BuildContext context) {
    if (isFavorite) {
      RemoveFavoriteBottomSheetWidget.show(
        context: context,
        coinName: coinModel.name,
        onConfirm: () => _favoritesProvider.toggleCommand.execute(coinModel),
      );
    } else {
      _favoritesProvider.toggleCommand.execute(coinModel);
    }
  }

  String cleanDescription(String description) {
    if (description.isEmpty) {
      return descriptionEmpty;
    }

    final document = parse(description);
    final String cleaned =
        document.body?.text.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';

    if (cleaned.isEmpty) {
      return descriptionEmpty;
    }

    return cleaned;
  }

  List<FlSpot> getChartSpots(List<List<double>> prices) {
    return prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value[1]);
    }).toList();
  }

  Future<bool> openExternalLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  void openLink(BuildContext context, String url) async {
    final success = await openExternalLink(url);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(errorOpenLink)));
    }
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
