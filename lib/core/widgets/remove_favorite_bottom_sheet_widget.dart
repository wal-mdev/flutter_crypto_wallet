import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/widgets/bottom_sheet_widget.dart';

class RemoveFavoriteBottomSheetWidget {
  static Future<void> show({
    required BuildContext context,
    required String coinName,
    required VoidCallback onConfirm,
  }) {
    return BottomSheetWidget.show(
      context: context,
      title: const Text('Remove from Favorites?'),
      description: Text(
        'Are you sure you want to remove $coinName from your favorites list?',
      ),
      primaryButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        child: const Text('Remove'),
      ),
      secondaryButton: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
