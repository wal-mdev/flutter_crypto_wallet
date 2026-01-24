import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/core/result.dart';

abstract class Command<TSuccess, TError> extends ChangeNotifier {
  Command();

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  bool _running = false;
  bool get running => _running;
  int _executionCount = 0;

  Result<TSuccess, TError>? _result;
  bool get error => _result is Error;
  bool get completed => _result is Success;
  Result<TSuccess, TError>? get result => _result;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> _execute(
    Future<Result<TSuccess, TError>> Function() action,
  ) async {
    if (_running) return;

    _executionCount++;
    final currentExecution = _executionCount;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      final res = await action();
      if (currentExecution != _executionCount) return;
      _result = res;
    } finally {
      if (currentExecution == _executionCount) {
        _running = false;
        notifyListeners();
      }
    }
  }
}

class Command0<TSuccess, TError> extends Command<TSuccess, TError> {
  Command0(this._action);
  final Future<Result<TSuccess, TError>> Function() _action;
  Future<void> execute() async => _execute(_action);
}

class Command1<TSuccess, TError, TParam1> extends Command<TSuccess, TError> {
  Command1(this._action);
  final Future<Result<TSuccess, TError>> Function(TParam1) _action;
  Future<void> execute(TParam1 p1) async => _execute(() => _action(p1));
}
