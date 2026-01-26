import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/features/details/view_model/details_view_model.dart';

class PeriodSelectorWidget extends StatelessWidget {
  const PeriodSelectorWidget({required this.viewModel, super.key});

  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
