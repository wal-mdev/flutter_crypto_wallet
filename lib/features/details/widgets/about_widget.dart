import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/model/coin_detail_model.dart';
import 'package:flutter_crypto_wallet/core/widgets/command_builder_widget.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:flutter_crypto_wallet/features/details/widgets/link_chip_widget.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({required this.viewModel, super.key});

  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CommandBuilderWidget<CoinDetailModel, Exception>(
      command: viewModel.loadDetailsCommand,
      initialBuilder: (_) => const SizedBox.shrink(),
      successBuilder: (context, details) {
        final description = viewModel.cleanDescription(details.description);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the Project',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (details.homepage.isNotEmpty)
                  LinkChipWidget(
                    label: 'Website',
                    icon: Icons.language,
                    url: details.homepage,
                  ),
                if (details.whitepaper != null &&
                    details.whitepaper!.isNotEmpty)
                  LinkChipWidget(
                    label: 'Whitepaper',
                    icon: Icons.description,
                    url: details.whitepaper!,
                  ),
                if (details.github != null && details.github!.isNotEmpty)
                  LinkChipWidget(
                    label: 'GitHub',
                    icon: Icons.code,
                    url: details.github!,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
