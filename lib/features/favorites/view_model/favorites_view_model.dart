import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesProvider _favoritesProvider;
  StreamSubscription? _favoritesSubscription;

  FavoritesViewModel({required FavoritesProvider favoritesProvider})
    : _favoritesProvider = favoritesProvider {
    _favoritesSubscription = _favoritesProvider.favoritesStream.listen((_) {
      notifyListeners();
    });
  }

  FavoritesProvider get favoritesProvider => _favoritesProvider;

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  void toggleFavorite(BuildContext context, Coin coin) {
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
