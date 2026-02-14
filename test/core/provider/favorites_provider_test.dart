import 'package:flutter_crypto_wallet/core/provider/favorites_provider.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../mocks.dart';

void main() {
  late MockFavoritesRepository mockRepository;
  late FavoritesProvider provider;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    when(
      () => mockRepository.getAll(),
    ).thenAnswer((_) async => Success<List<Coin>, Failure>([]));
    provider = FavoritesProvider(repository: mockRepository);
  });

  group('FavoritesProvider Tests', () {
    test('isFavorite returns true when coin is in list', () async {
      final coin = createMockCoin(id: 'bitcoin');

      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success([coin]));
      await provider.loadCommand.execute();

      expect(provider.isFavorite(coin), true);
    });

    test('isFavorite returns false when coin is not in list', () {
      final coin = createMockCoin(id: 'ethereum');
      expect(provider.isFavorite(coin), false);
    });

    test('toggleFavorite calls add when coin is not favorite', () async {
      final coin = createMockCoin(id: 'bitcoin');

      when(
        () => mockRepository.add(coin),
      ).thenAnswer((_) async => Success<void, Failure>(null));
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success<List<Coin>, Failure>([coin]));

      await provider.toggleCommand.execute(coin);

      verify(() => mockRepository.add(coin)).called(1);
    });

    test('toggleFavorite calls remove when coin is already favorite', () async {
      final coin = createMockCoin(id: 'bitcoin');

      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success([coin]));
      await provider.loadCommand.execute();

      when(
        () => mockRepository.remove(coin),
      ).thenAnswer((_) async => Success<void, Failure>(null));
      when(
        () => mockRepository.getAll(),
      ).thenAnswer((_) async => Success<List<Coin>, Failure>([]));

      await provider.toggleCommand.execute(coin);

      verify(() => mockRepository.remove(coin)).called(1);
    });
  });
}
