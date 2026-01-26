import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';
import 'package:provider/provider.dart';

class LinkChipWidget extends StatelessWidget {
  const LinkChipWidget({
    required this.label,
    required this.icon,
    required this.url,
    super.key,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () async {
          final viewModel = context.read<DetailsViewModel>();
          final success = await viewModel.openExternalLink(url);
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Não foi possível abrir o link')),
            );
          }
        },
      ),
    );
  }
}
