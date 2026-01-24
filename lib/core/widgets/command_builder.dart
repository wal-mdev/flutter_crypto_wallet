import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/command.dart';
import 'package:flutter_crypto_wallet/core/result.dart';

typedef CommandSuccessBuilder<TSuccess> =
    Widget Function(BuildContext context, TSuccess data);

typedef CommandErrorBuilder<TError> =
    Widget Function(BuildContext context, TError failure);

typedef CommandEmptyBuilder = Widget Function(BuildContext context);
typedef CommandEmptyPredicate<TSuccess> = bool Function(TSuccess value);

class AppCommandBuilder<TSuccess, TError> extends StatelessWidget {
  const AppCommandBuilder({
    required this.command,
    required this.successBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.initialBuilder,
    super.key,
  });

  final Command<TSuccess, TError> command;
  final CommandSuccessBuilder<TSuccess> successBuilder;
  final CommandErrorBuilder<TError>? errorBuilder;
  final CommandEmptyBuilder? emptyBuilder;
  final WidgetBuilder? initialBuilder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: command,
      builder: (context, _) {
        if (command.running) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = command.result;
        if (result == null) {
          return initialBuilder?.call(context) ?? const SizedBox.shrink();
        }

        if (result is Success<TSuccess, TError>) {
          final value = result.value;
          if (_isValueEmpty(value)) {
            if (emptyBuilder != null) {
              return emptyBuilder!(context);
            }
            return const SizedBox.shrink();
          }
          return successBuilder(context, value);
        }

        if (result is Error<TSuccess, TError>) {
          if (errorBuilder != null) {
            return errorBuilder!(context, result.failure);
          }
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  bool _isValueEmpty(TSuccess value) {
    if (value is Iterable) {
      return value.isEmpty;
    }

    if (value is Map) {
      return value.isEmpty;
    }

    if (value is String) {
      return value.isEmpty;
    }

    return false;
  }
}
