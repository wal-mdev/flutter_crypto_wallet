import 'package:flutter_crypto_wallet/core/service/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageServiceImpl implements StorageService {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> save(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  @override
  Future<T?> get<T>(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    return box.get(key) as T?;
  }

  @override
  Future<List<T>> getAll<T>(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box.values.cast<T>().toList();
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }
}
