import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_presentation.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/coin_gecko_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsViewModel extends ChangeNotifier {
  final CoinGeckoRepository _repository;
  final FavoritesProvider _favoritesProvider;
  final String coinId;
  final CoinMarketModel coinModel;

  DetailsViewModel({
    required CoinGeckoRepository repository,
    required FavoritesProvider favoritesProvider,
    required this.coinId,
    required this.coinModel,
  }) : _repository = repository,
       _favoritesProvider = favoritesProvider {
    loadDetailsCommand = Command0(() => _repository.getCoinDetails(coinId));
    loadChartCommand = Command1(
      (String days) => _repository.getCoinChartData(coinId, days),
    );

    // Listen to favorite changes to update the UI instantly
    _favoritesProvider.addListener(notifyListeners);

    // Initial fetch for 7 days chart (default)
    loadChartCommand.execute('7');
    loadDetailsCommand.execute();
  }

  late final Command0<CoinDetailModel, Exception> loadDetailsCommand;

  late final Command1<List<List<double>>, Exception, String> loadChartCommand;

  static const periods = {'1': '24h', '7': '7d', '14': '14d', '30': '30d'};

  String _selectedPeriod = '7';

  String get selectedPeriod => _selectedPeriod;

  bool get isFavorite => _favoritesProvider.isFavorite(coinModel);

  bool get isPositive => coinModel.isPositive;

  String get titleFormatted => '${coinModel.name} (${coinModel.symbol})';

  String get priceFormatted => coinModel.priceFormatted;

  String get variationFormatted => coinModel.variationFormatted;

  Color get variationColor => coinModel.variationColor;

  IconData get trendIcon => coinModel.trendIcon;

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
      return 'Nenhuma descrição disponível para esta criptomoeda.';
    }

    // Improved regex to remove HTML tags and entities more thoroughly
    final cleaned = description
        .replaceAll(
          RegExp(r'<[^>]*>|&[^;]+;'),
          ' ',
        ) // Replace tags/entities with space
        .replaceAll(RegExp(r'\s+'), ' ') // Collapse multiple spaces/newlines
        .trim();

    if (cleaned.isEmpty) {
      return 'Nenhuma descrição disponível para esta criptomoeda.';
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

  @override
  void dispose() {
    _favoritesProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
