import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';

class PeriodSelectorWidget extends StatelessWidget {
  const PeriodSelectorWidget({required this.viewModel, super.key});

  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: DetailsViewModel.periods.entries.map((entry) {
        final isSelected = viewModel.selectedPeriod == entry.key;
        return GestureDetector(
          onTap: () => viewModel.setPeriod(entry.key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
