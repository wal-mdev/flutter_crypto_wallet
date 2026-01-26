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
    final viewModel = context.read<DetailsViewModel>();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () => viewModel.openLink(context, url),
      ),
    );
  }
}
