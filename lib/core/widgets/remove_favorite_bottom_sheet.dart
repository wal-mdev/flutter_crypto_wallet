import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/widgets/app_bottom_sheet.dart';

class RemoveFavoriteBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String coinName,
    required VoidCallback onConfirm,
  }) {
    return AppBottomSheet.show(
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
      secondaryButton: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
    );
  }
}
