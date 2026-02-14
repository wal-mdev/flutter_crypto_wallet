import 'dart:async';

import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/repository/favorites_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class FavoritesProvider {
  final FavoritesRepository _repository;

  FavoritesProvider({required FavoritesRepository repository})
    : _repository = repository {
    loadCommand = Command0(_loadFavorites);
    toggleCommand = Command1(_toggleFavorite);

    loadCommand.execute();
  }

  late final Command0<List<Coin>, Failure> loadCommand;
  late final Command1<void, Failure, Coin> toggleCommand;

  final _favoritesStreamController = StreamController<List<Coin>>.broadcast();
  Stream<List<Coin>> get favoritesStream => _favoritesStreamController.stream;

  List<Coin> _favorites = [];
  List<Coin> get favorites => _favorites;

  bool isFavorite(Coin coin) {
    return _favorites.any((f) => f.id == coin.id);
  }

  Future<Result<List<Coin>, Failure>> _loadFavorites() async {
    final result = await _repository.getAll();

    if (result is Success<List<Coin>, Failure>) {
      _favorites = result.value;
      _favoritesStreamController.add(_favorites);
    }

    return result;
  }

  Future<Result<void, Failure>> _toggleFavorite(Coin coin) async {
    final exists = isFavorite(coin);
    final Result<void, Failure> result;

    if (exists) {
      result = await _repository.remove(coin);
    } else {
      result = await _repository.add(coin);
    }

    if (result is Success<void, Failure>) {
      await loadCommand.execute();
    }

    return result;
  }

  void dispose() {
    _favoritesStreamController.close();
  }
}
