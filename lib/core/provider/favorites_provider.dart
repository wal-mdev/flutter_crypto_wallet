import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;

  FavoritesProvider({required FavoritesRepository repository})
    : _repository = repository {
    loadCommand = Command0(_loadFavorites);
    toggleCommand = Command1(_toggleFavorite);

    loadCommand.execute();
  }

  late final Command0<List<CoinMarketModel>, Exception> loadCommand;
  late final Command1<void, Exception, CoinMarketModel> toggleCommand;

  List<CoinMarketModel> _favorites = [];
  List<CoinMarketModel> get favorites => _favorites;

  bool isFavorite(CoinMarketModel coin) {
    return _favorites.any((f) => f.id == coin.id);
  }

  Future<Result<List<CoinMarketModel>, Exception>> _loadFavorites() async {
    final result = await _repository.getAll();

    if (result is Success<List<CoinMarketModel>, Exception>) {
      _favorites = result.value;
      notifyListeners();
    }

    return result;
  }

  Future<Result<void, Exception>> _toggleFavorite(CoinMarketModel coin) async {
    final exists = isFavorite(coin);
    final Result<void, Exception> result;

    if (exists) {
      result = await _repository.remove(coin);
    } else {
      result = await _repository.add(coin);
    }

    if (result is Success<void, Exception>) {
      await loadCommand.execute();
    }

    return result;
  }
}
