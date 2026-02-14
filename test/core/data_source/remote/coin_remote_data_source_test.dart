import 'package:dio/dio.dart';
import 'package:flutter_crypto_wallet/core/data_source/remote/coin_remote_data_source.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CoinRemoteDataSourceImpl remoteDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    remoteDataSource = CoinRemoteDataSourceImpl(dio: mockDio);
  });

  group('CoinRemoteDataSourceImpl Tests', () {
    test('getTopCoins returns list of coins on success', () async {
      final coins = [createMockCoinModel(id: 'bitcoin')];
      // Dio returns auto-decoded JSON (List<dynamic>)
      final jsonResponse = coins.map((c) => c.toJson()).toList();

      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await remoteDataSource.getTopCoins();

      expect(result.length, 1);
      expect(result.first.id, 'bitcoin');
    });

    test('getTopCoins throws ServerFailure on API error', () async {
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            data: 'Not Found',
            statusCode: 404,
            statusMessage: 'Not Found',
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => remoteDataSource.getTopCoins(),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 404),
        ),
      );
    });

    test(
      'getTopCoins throws ServerFailure with friendly message on 429 error',
      () async {
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              data: 'Too Many Requests',
              statusCode: 429,
              statusMessage: 'Too Many Requests',
              requestOptions: RequestOptions(path: ''),
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        expect(
          () => remoteDataSource.getTopCoins(),
          throwsA(
            isA<ServerFailure>()
                .having((f) => f.statusCode, 'statusCode', 429)
                .having(
                  (f) => f.message,
                  'message',
                  'Muitas requisições. Tente novamente em instantes.',
                ),
          ),
        );
      },
    );

    test('getTopCoins throws NetworkFailure on connection error', () async {
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => remoteDataSource.getTopCoins(),
        throwsA(
          isA<NetworkFailure>().having(
            (f) => f.message,
            'message',
            contains('Falha na conexão'),
          ),
        ),
      );
    });

    test('getCoinDetails returns details on success', () async {
      final jsonResponse = {
        'id': 'bitcoin',
        'name': 'Bitcoin',
        'symbol': 'btc',
        'description': {'en': 'desc'},
      };

      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await remoteDataSource.getCoinDetails('bitcoin');

      expect(result.id, 'bitcoin');
      expect(result.description, 'desc');
    });
  });
}
