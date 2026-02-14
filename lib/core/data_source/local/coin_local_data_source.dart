import 'dart:async';
import 'dart:convert';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';

abstract class CoinLocalDataSource {
  Future<void> init();
  List<CoinMarketModel>? getTopCoins();
  Stream<List<CoinMarketModel>?> watchTopCoins();
  void saveTopCoins(List<CoinMarketModel> coins);
  Future<void> clear();
}

class CoinLocalDataSourceImpl implements CoinLocalDataSource {
  final StorageService _storage;
  static const String _boxName = 'coin_cache';
  static const String _key = 'top_coins';

  List<CoinMarketModel>? _cachedCoins;

  final _topCoinsController =
      StreamController<List<CoinMarketModel>?>.broadcast();

  CoinLocalDataSourceImpl({required StorageService storage})
    : _storage = storage;

  @override
  Stream<List<CoinMarketModel>?> watchTopCoins() => _topCoinsController.stream;

  @override
  Future<void> init() async {
    final rawJson = await _storage.get<String>(_boxName, _key);
    if (rawJson != null) {
      try {
        final List<dynamic> list = json.decode(rawJson);
        _cachedCoins = list.map((j) => CoinMarketModel.fromJson(j)).toList();
      } catch (e) {
        _cachedCoins = null;
        await clear();
      }
    }
  }

  @override
  List<CoinMarketModel>? getTopCoins() => _cachedCoins;

  @override
  void saveTopCoins(List<CoinMarketModel> coins) {
    _cachedCoins = List.from(coins);
    _topCoinsController.add(_cachedCoins);
    final jsonList = coins.map((c) => c.toJson()).toList();
    _storage.save(_boxName, _key, json.encode(jsonList));
  }

  @override
  Future<void> clear() async {
    _cachedCoins = null;
    await _storage.delete(_boxName, _key);
  }
}
