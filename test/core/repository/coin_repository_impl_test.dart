import 'package:flutter_crypto_wallet/core/repository/coin_repository_impl.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../mocks.dart';

void main() {
  late CoinRepositoryImpl repository;
  late MockCoinRemoteDataSource mockRemote;
  late MockCoinLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockCoinRemoteDataSource();
    mockLocal = MockCoinLocalDataSource();
    repository = CoinRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('CoinRepositoryImpl Tests', () {
    test(
      'getTopCoins fetches from remote and saves to local on page 1 (no cache)',
      () async {
        final coinModels = [createMockCoinModel(id: 'bitcoin')];
        final coinEntities = coinModels.map((e) => e.toEntity()).toList();

        when(() => mockLocal.getTopCoins()).thenReturn(null);
        when(
          () => mockRemote.getTopCoins(page: 1, perPage: any(named: 'perPage')),
        ).thenAnswer((_) async => coinModels);
        when(() => mockLocal.saveTopCoins(any())).thenReturn(null);

        final result = await repository.getTopCoins(page: 1);

        expect(result.isSuccess, true);
        expect((result as Success).value, equals(coinEntities));
        verify(
          () => mockRemote.getTopCoins(page: 1, perPage: any(named: 'perPage')),
        ).called(1);
        verify(() => mockLocal.saveTopCoins(coinModels)).called(1);
      },
    );

    test(
      'getTopCoins returns ServerFailure on remote error (no cache)',
      () async {
        when(() => mockLocal.getTopCoins()).thenReturn(null);
        when(
          () => mockRemote.getTopCoins(page: 1, perPage: any(named: 'perPage')),
        ).thenThrow(const ServerFailure(statusCode: 500));

        final result = await repository.getTopCoins(page: 1);

        expect(result.isError, true);
        expect((result as Error).failure, isA<ServerFailure>());
      },
    );

    test(
      'getTopCoins returns cache immediately and syncs on page 1 (with cache)',
      () async {
        final cachedCoinModels = [createMockCoinModel(id: 'bitcoin')];
        final cachedCoinEntities = cachedCoinModels
            .map((e) => e.toEntity())
            .toList();
        final freshCoinModels = [
          createMockCoinModel(id: 'bitcoin', currentPrice: 60000),
        ];

        when(() => mockLocal.getTopCoins()).thenReturn(cachedCoinModels);
        when(
          () => mockRemote.getTopCoins(page: 1, perPage: any(named: 'perPage')),
        ).thenAnswer((_) async => freshCoinModels);
        when(() => mockLocal.saveTopCoins(any())).thenReturn(null);

        final result = await repository.getTopCoins(page: 1);

        expect(result.isSuccess, true);
        expect((result as Success).value, equals(cachedCoinEntities));

        // Wait for background sync
        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          () => mockRemote.getTopCoins(page: 1, perPage: any(named: 'perPage')),
        ).called(1);
        verify(() => mockLocal.saveTopCoins(freshCoinModels)).called(1);
      },
    );

    test('searchCoins tries local first then remote', () async {
      final coinModels = [createMockCoinModel(id: 'bitcoin')];
      final coinEntities = coinModels.map((e) => e.toEntity()).toList();

      // Case 1: Found in local
      when(() => mockLocal.getTopCoins()).thenReturn(coinModels);

      var result = await repository.searchCoins('bit');

      expect(result.isSuccess, true);
      expect((result as Success).value, equals(coinEntities));
      verify(() => mockLocal.getTopCoins()).called(1);
      verifyNever(() => mockRemote.searchCoins(any()));

      // Case 2: Not found in local, calls remote
      when(() => mockLocal.getTopCoins()).thenReturn([]);
      when(
        () => mockRemote.searchCoins(any()),
      ).thenAnswer((_) async => coinModels);

      result = await repository.searchCoins('eth');

      expect(result.isSuccess, true);
      verify(() => mockRemote.searchCoins('eth')).called(1);
    });
  });
}
