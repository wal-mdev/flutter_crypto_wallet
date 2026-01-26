import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/utils/command.dart';
import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';

class MockCommand1<T, E, P> extends Mock implements Command1<T, E, P> {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockCoinGeckoRepository mockRepository;
  late MockFavoritesProvider mockFavoritesProvider;
  late DetailsViewModel viewModel;
  final mockCoin = createMockCoin(id: 'bitcoin', name: 'Bitcoin');

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockRepository = MockCoinGeckoRepository();
    mockFavoritesProvider = MockFavoritesProvider();

    when(() => mockRepository.getCoinDetails(any())).thenAnswer(
      (_) async => Success(
        CoinDetailModel(
          id: 'bitcoin',
          symbol: 'BTC',
          name: 'Bitcoin',
          description: 'Bitcoin is a decentralized digital currency.',
          homepage: 'https://bitcoin.org',
        ),
      ),
    );
    when(() => mockRepository.getCoinChartData(any(), any())).thenAnswer(
      (_) async => Success(<List<double>>[
        <double>[1625097600000.0, 35000.0],
      ]),
    );

    when(() => mockFavoritesProvider.addListener(any())).thenReturn(null);
    when(() => mockFavoritesProvider.removeListener(any())).thenReturn(null);
    when(() => mockFavoritesProvider.isFavorite(any())).thenReturn(false);

    viewModel = DetailsViewModel(
      repository: mockRepository,
      favoritesProvider: mockFavoritesProvider,
      coinId: 'bitcoin',
      coinModel: mockCoin,
    );
  });

  group('DetailsViewModel Tests', () {
    test('initial execution loads details and chart', () {
      verify(() => mockRepository.getCoinDetails('bitcoin')).called(1);
      verify(() => mockRepository.getCoinChartData('bitcoin', '7')).called(1);
    });

    test('cleanDescription removes HTML tags and collapses whitespace', () {
      const htmlText = "  <p>Hello</p>   <br/> <b>World!</b>  &nbsp;  ";
      final result = viewModel.cleanDescription(htmlText);
      expect(result, "Hello World!");
    });

    test('cleanDescription returns fallback for empty or tag-only strings', () {
      const emptyText = "   <p></p>   ";
      final result = viewModel.cleanDescription(emptyText);
      expect(result, 'Nenhuma descrição disponível para esta criptomoeda.');
    });

    test('setPeriod updates selectedPeriod and triggers chart reload', () {
      viewModel.setPeriod('30');
      expect(viewModel.selectedPeriod, '30');
      verify(() => mockRepository.getCoinChartData('bitcoin', '30')).called(1);
    });

    test('toggleFavorite delegates to FavoritesProvider', () async {
      final mockCommand = MockCommand1<void, Exception, CoinMarketModel>();
      when(() => mockFavoritesProvider.toggleCommand).thenReturn(mockCommand);
      when(
        () => mockCommand.execute(any()),
      ).thenAnswer((_) async => Success(null));

      viewModel.toggleFavorite(MockBuildContext());

      verify(() => mockCommand.execute(mockCoin)).called(1);
    });

    test('getChartSpots maps correctly', () {
      final prices = <List<double>>[
        <double>[1625000000000.0, 30000.0],
        <double>[1625100000000.0, 31000.0],
      ];
      final spots = viewModel.getChartSpots(prices);
      expect(spots.length, 2);
      expect(spots[0].x, 0.0);
      expect(spots[0].y, 30000.0);
    });
  });
}
