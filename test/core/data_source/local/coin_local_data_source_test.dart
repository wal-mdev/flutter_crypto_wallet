import 'dart:convert';
import 'package:flutter_crypto_wallet/core/data_source/local/coin_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';
import 'package:flutter_crypto_wallet/core/service/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late CoinLocalDataSourceImpl localDataSource;
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    localDataSource = CoinLocalDataSourceImpl(storage: mockStorage);
  });

  group('CoinLocalDataSourceImpl Tests', () {
    test('init loads data from storage', () async {
      final coins = [createMockCoinModel(id: 'bitcoin')];
      final jsonStr = json.encode(coins.map((c) => c.toJson()).toList());

      when(
        () => mockStorage.get<String>(any(), any()),
      ).thenAnswer((_) async => jsonStr);

      await localDataSource.init();

      expect(localDataSource.getTopCoins(), isNotNull);
      expect(localDataSource.getTopCoins()!.first.id, 'bitcoin');
    });

    test('saveTopCoins updates memory, storage and emits to stream', () async {
      final coins = [createMockCoinModel(id: 'bitcoin')];

      when(
        () => mockStorage.save(any(), any(), any()),
      ).thenAnswer((_) async {});

      expectLater(localDataSource.watchTopCoins(), emits(coins));

      localDataSource.saveTopCoins(coins);

      expect(localDataSource.getTopCoins(), isNotNull);
      expect(localDataSource.getTopCoins()!.first.id, 'bitcoin');
      verify(() => mockStorage.save(any(), any(), any())).called(1);
    });

    test('clear resets memory and deletes from storage', () async {
      when(
        () => mockStorage.delete(any(), any()),
      ).thenAnswer((_) async {});

      await localDataSource.clear();

      expect(localDataSource.getTopCoins(), isNull);
      verify(() => mockStorage.delete(any(), any())).called(1);
    });
  });
}
