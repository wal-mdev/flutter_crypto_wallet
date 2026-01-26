import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/features/favorites/view_model/favorites_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';

class MockCommand1<T, E, P> extends Mock implements Command1<T, E, P> {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockFavoritesProvider mockFavoritesProvider;
  late FavoritesViewModel viewModel;
  final mockCoin = createMockCoin(id: 'bitcoin', name: 'Bitcoin');

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockFavoritesProvider = MockFavoritesProvider();

    when(() => mockFavoritesProvider.addListener(any())).thenReturn(null);
    when(() => mockFavoritesProvider.removeListener(any())).thenReturn(null);
    when(() => mockFavoritesProvider.isFavorite(any())).thenReturn(false);

    viewModel = FavoritesViewModel(favoritesProvider: mockFavoritesProvider);
  });

  group('FavoritesViewModel Tests', () {
    test('initialization adds listener to provider', () {
      verify(() => mockFavoritesProvider.addListener(any())).called(1);
    });

    test('dispose removes listener from provider', () {
      viewModel.dispose();
      verify(() => mockFavoritesProvider.removeListener(any())).called(1);
    });

    test('toggleFavorite delegates to toggleCommand when not favorite', () {
      final mockCommand = MockCommand1<void, Exception, CoinMarketModel>();

      when(() => mockFavoritesProvider.toggleCommand).thenReturn(mockCommand);

      when(
        () => mockCommand.execute(any()),
      ).thenAnswer((_) async => Success(null));
      when(() => mockFavoritesProvider.isFavorite(mockCoin)).thenReturn(false);

      viewModel.toggleFavorite(MockBuildContext(), mockCoin);

      verify(() => mockCommand.execute(mockCoin)).called(1);
    });

    test('favoritesProvider getter returns the correct instance', () {
      expect(viewModel.favoritesProvider, mockFavoritesProvider);
    });
  });
}
