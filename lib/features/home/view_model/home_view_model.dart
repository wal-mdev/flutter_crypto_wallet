import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/repository/coin_gecko_repository.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/widgets/remove_favorite_bottom_sheet_widget.dart';

class HomeViewModel extends ChangeNotifier {
  final CoinGeckoRepository _repository;
  final FavoritesProvider _favoritesProvider;
  Timer? _debounce;
  Timer? _autoRefreshTimer;

  static const _cooldownDuration = Duration(minutes: 3);
  DateTime? _lastRefreshTime;

  late int _countdown = _cooldownDuration.inSeconds;
  int get countdown => _countdown;

  bool isFavorite(CoinMarketModel coin) => _favoritesProvider.isFavorite(coin);

  String get formattedCountdown {
    final minutes = _countdown ~/ 60;
    final seconds = _countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  HomeViewModel({
    required CoinGeckoRepository repository,
    required FavoritesProvider favoritesProvider,
  }) : _repository = repository,
       _favoritesProvider = favoritesProvider {
    loadCoinsCommand = Command1(_loadInitialCoins);
    searchCommand = Command1(_repository.searchCoins);

    // Listen to favorite changes to update the list instantly
    _favoritesProvider.addListener(notifyListeners);

    _startCountdownTimer();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool get isSearching => _searchQuery.length >= 3;

  Command<List<CoinMarketModel>, Exception> get activeCommand =>
      isSearching ? searchCommand : loadCoinsCommand;

  late final Command1<List<CoinMarketModel>, Exception, bool> loadCoinsCommand;
  late final Command1<List<CoinMarketModel>, Exception, String> searchCommand;

  bool _lastTriggerWasManual = false;
  bool get lastTriggerWasManual => _lastTriggerWasManual;

  final List<CoinMarketModel> _coins = [];
  List<CoinMarketModel> get coins => List.unmodifiable(_coins);

  int _currentPage = 1;
  static const int _pageSize = 150;

  Future<Result<List<CoinMarketModel>, Exception>> _loadInitialCoins(
    bool isManual,
  ) async {
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

    if (result is Success<List<CoinMarketModel>, Exception>) {
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

  void toggleFavorite(BuildContext context, CoinMarketModel coin) {
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
    _favoritesProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
