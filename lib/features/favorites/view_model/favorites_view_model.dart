import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesProvider _favoritesProvider;

  FavoritesViewModel({required FavoritesProvider favoritesProvider})
    : _favoritesProvider = favoritesProvider {
    _favoritesProvider.addListener(notifyListeners);
  }

  FavoritesProvider get favoritesProvider => _favoritesProvider;

  @override
  void dispose() {
    _favoritesProvider.removeListener(notifyListeners);
    super.dispose();
  }

  void toggleFavorite(BuildContext context, CoinMarketModel coin) {
    if (_favoritesProvider.isFavorite(coin)) {
      RemoveFavoriteBottomSheetWidget.show(
        context: context,
        coinName: coin.name,
        onConfirm: () => _favoritesProvider.toggleCommand.execute(coin),
      );
    } else {
      _favoritesProvider.toggleCommand.execute(coin);
    }
  }
}
