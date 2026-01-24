sealed class Result<TSuccess, TError> {
  const Result();

  TSuccess? getOrNull() {
    if (this is Success<TSuccess, TError>) {
      return (this as Success<TSuccess, TError>).value;
    }
    return null;
  }

  TError? getFailureOrNull() {
    if (this is Error<TSuccess, TError>) {
      return (this as Error<TSuccess, TError>).failure;
    }
    return null;
  }

  T fold<T>(T Function(TSuccess) onSuccess, T Function(TError) onError) {
    if (this is Success<TSuccess, TError>) {
      return onSuccess((this as Success<TSuccess, TError>).value);
    }
    return onError((this as Error<TSuccess, TError>).failure);
  }

  bool get isSuccess => this is Success<TSuccess, TError>;
  bool get isError => this is Error<TSuccess, TError>;
}

class Success<TSuccess, TError> extends Result<TSuccess, TError> {
  Success(this.value);

  final TSuccess value;
}

class Error<TSuccess, TError> extends Result<TSuccess, TError> {
  Error(this.failure);

  final TError failure;
}
