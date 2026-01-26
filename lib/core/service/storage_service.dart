abstract interface class StorageService {
  Future<void> init();
  Future<void> save(String boxName, String key, dynamic value);
  Future<List<T>> getAll<T>(String boxName);
  Future<void> delete(String boxName, String key);
}
