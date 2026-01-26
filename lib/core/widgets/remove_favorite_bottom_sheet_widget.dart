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
      title: const Text('Remover dos Favoritos?'),
      description: Text(
        'Tem certeza que deseja remover $coinName da sua lista de favoritos?',
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
        child: const Text('Remover'),
      ),
      secondaryButton: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
    );
  }
}
