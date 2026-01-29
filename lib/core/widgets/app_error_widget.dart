import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/error/failure.dart';

class AppErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const AppErrorWidget({required this.failure, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIconForFailure(failure), size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            failure.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() => Icons.wifi_off,
      ServerFailure() => Icons.dns,
      CacheFailure() => Icons.storage,
      _ => Icons.error_outline,
    };
  }
}
