import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/domain/repository/coin_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class HomeViewModel extends ChangeNotifier {
  final CoinRepository _repository;
  final FavoritesProvider _favoritesProvider;
  Timer? _debounce;
  Timer? _autoRefreshTimer;
  StreamSubscription? _favoritesSubscription;
  StreamSubscription? _coinsSubscription;

  static const _cooldownDuration = Duration(minutes: 3);
  DateTime? _lastRefreshTime;

  late int _countdown = _cooldownDuration.inSeconds;
  int get countdown => _countdown;

  bool isFavorite(Coin coin) => _favoritesProvider.isFavorite(coin);

  String get formattedCountdown {
    final minutes = _countdown ~/ 60;
    final seconds = _countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  HomeViewModel({
    required CoinRepository repository,
    required FavoritesProvider favoritesProvider,
  }) : _repository = repository,
       _favoritesProvider = favoritesProvider {
    loadCoinsCommand = Command1(_loadInitialCoins);
    searchCommand = Command1(_repository.searchCoins);

    // 1. Listen to Local Coins Stream (Offline-First)
    _coinsSubscription = _repository.watchTopCoins().listen((cachedCoins) {
      if (cachedCoins != null) {
        _coins.clear();
        _coins.addAll(cachedCoins);
        notifyListeners();
      }
    });

    // 2. Listen to favorite changes using Streams
    _favoritesSubscription = _favoritesProvider.favoritesStream.listen((_) {
      notifyListeners();
    });

    _startCountdownTimer();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool get isSearching => _searchQuery.length >= 3;

  Command<List<Coin>, Failure> get activeCommand =>
      isSearching ? searchCommand : loadCoinsCommand;

  late final Command1<List<Coin>, Failure, bool> loadCoinsCommand;
  late final Command1<List<Coin>, Failure, String> searchCommand;

  bool _lastTriggerWasManual = false;
  bool get lastTriggerWasManual => _lastTriggerWasManual;

  final List<Coin> _coins = [];
  List<Coin> get coins => List.unmodifiable(_coins);

  int _currentPage = 1;
  static const int _pageSize = 150;

  Future<Result<List<Coin>, Failure>> _loadInitialCoins(bool isManual) async {
    final now = DateTime.now();
    _lastTriggerWasManual = isManual;

    // If within cooldown period, return success with current list.
    // 1-second margin to avoid periodic Timer race conditions.
    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!) < _cooldownDuration) {
      return Success(_coins);
    }

    _currentPage = 1;
    final result = await _repository.getTopCoins(
      page: _currentPage,
      perPage: _pageSize,
    );

    if (result is Success<List<Coin>, Failure>) {
      _coins.clear();
      _coins.addAll(result.value);
      _lastRefreshTime = now;
      _countdown = _cooldownDuration.inSeconds;
      notifyListeners();
    }
    return result;
  }

  void _startCountdownTimer() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        loadCoinsCommand.execute(false);
      }
    });
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();

    if (query.length < 3) {
      searchCommand.clearResult();
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchCommand.execute(query);
    });
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _debounce?.cancel();
    searchCommand.clearResult();
    loadCoinsCommand.execute(false);
    notifyListeners();
  }

  void toggleFavorite(BuildContext context, Coin coin) {
    if (isFavorite(coin)) {
      RemoveFavoriteBottomSheetWidget.show(
        context: context,
        coinName: coin.name,
        onConfirm: () => _favoritesProvider.toggleCommand.execute(coin),
      );
    } else {
      _favoritesProvider.toggleCommand.execute(coin);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _autoRefreshTimer?.cancel();
    _favoritesSubscription?.cancel();
    _coinsSubscription?.cancel();
    super.dispose();
  }
}
