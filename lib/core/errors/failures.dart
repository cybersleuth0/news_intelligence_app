abstract class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'No Internet Connection']);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server Error occurred']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache Error occurred']);
}
