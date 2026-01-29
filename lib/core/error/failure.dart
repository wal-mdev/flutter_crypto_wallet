sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sem conexão com a internet']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({this.statusCode, String message = 'Erro no servidor'})
    : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro de armazenamento local']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Ocorreu um erro inesperado']);
}
