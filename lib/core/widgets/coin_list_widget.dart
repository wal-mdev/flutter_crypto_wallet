import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_market_model.dart';
import 'package:flutter_crypto_wallet/core/widgets/coin_list_item_widget.dart';

class CoinListWidget extends StatelessWidget {
  const CoinListWidget({
    required this.coins,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    super.key,
  });

  final List<CoinMarketModel> coins;
  final bool Function(CoinMarketModel) isFavorite;
  final void Function(CoinMarketModel) onFavoriteTap;
  final void Function(CoinMarketModel) onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: coins.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final coin = coins[index];
        return CoinListItemWidget(
          coin: coin,
          isFavorite: isFavorite(coin),
          onFavoriteTap: () => onFavoriteTap(coin),
          onTap: () => onTap(coin),
        );
      },
    );
  }
}
