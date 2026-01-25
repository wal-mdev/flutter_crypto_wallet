import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_model.dart';
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

  late final Command0<List<CoinModel>, Exception> loadCommand;
  late final Command1<void, Exception, CoinModel> toggleCommand;

  List<CoinModel> _favorites = [];
  List<CoinModel> get favorites => _favorites;

  bool isFavorite(CoinModel coin) {
    return _favorites.any((f) => f.symbol == coin.symbol);
  }

  Future<Result<List<CoinModel>, Exception>> _loadFavorites() async {
    final result = await _repository.getAll();

    if (result is Success<List<CoinModel>, Exception>) {
      _favorites = result.value;
      notifyListeners();
    }

    return result;
  }

  Future<Result<void, Exception>> _toggleFavorite(CoinModel coin) async {
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
