import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget title;
  final Widget description;
  final Widget primaryButton;
  final Widget? secondaryButton;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.primaryButton,
    this.secondaryButton,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget title,
    required Widget description,
    required Widget primaryButton,
    Widget? secondaryButton,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AppBottomSheet(
        title: title,
        description: description,
        primaryButton: primaryButton,
        secondaryButton: secondaryButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          DefaultTextStyle(
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            child: title,
          ),
          const SizedBox(height: 12),

          // Description
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            child: description,
          ),
          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              if (secondaryButton != null) ...[
                Expanded(child: secondaryButton!),
                const SizedBox(width: 16),
              ],
              Expanded(child: primaryButton),
            ],
          ),
        ],
      ),
    );
  }
}
