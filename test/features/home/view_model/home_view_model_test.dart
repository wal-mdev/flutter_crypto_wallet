import 'package:flutter_crypto_wallet/core/utils/result.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';
import 'package:flutter_crypto_wallet/core/domain/entity/coin.dart';
import 'package:flutter_crypto_wallet/features/home/view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';

void main() {
  late MockCoinRepository mockRepository;
  late MockFavoritesProvider mockFavoritesProvider;
  late HomeViewModel viewModel;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockRepository = MockCoinRepository();
    mockFavoritesProvider = MockFavoritesProvider();

    when(
      () => mockRepository.getTopCoins(
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer((_) async => Success<List<Coin>, Failure>([]));

    when(
      () => mockRepository.watchTopCoins(),
    ).thenAnswer((_) => const Stream.empty());

    when(
      () => mockFavoritesProvider.favoritesStream,
    ).thenAnswer((_) => const Stream.empty());

    viewModel = HomeViewModel(
      repository: mockRepository,
      favoritesProvider: mockFavoritesProvider,
    );
  });

  group('HomeViewModel Tests', () {
    test('initial state is correct', () {
      expect(viewModel.coins, isEmpty);
      expect(viewModel.isSearching, false);
      expect(viewModel.searchQuery, '');
    });

    test('onSearchChanged updates query and sets isSearching', () {
      viewModel.onSearchChanged('btc');
      expect(viewModel.searchQuery, 'btc');
      expect(viewModel.isSearching, true);

      viewModel.onSearchChanged('bt');
      expect(viewModel.searchQuery, 'bt');
      expect(viewModel.isSearching, false);
    });

    test(
      'loadCoinsCommand calls repository and updates coins list on success',
      () async {
        final mockCoins = [
          createMockCoin(id: 'bitcoin'),
          createMockCoin(id: 'ethereum'),
        ];

        when(
          () => mockRepository.getTopCoins(page: 1, perPage: 150),
        ).thenAnswer((_) async => Success<List<Coin>, Failure>(mockCoins));

        await viewModel.loadCoinsCommand.execute(true);

        expect(viewModel.coins.length, 2);
        expect(viewModel.coins[0].id, 'bitcoin');
        expect(viewModel.coins[1].id, 'ethereum');
      },
    );

    test('formattedCountdown returns correct MM:SS format', () {
      expect(viewModel.formattedCountdown, '03:00');
    });
  });
}
