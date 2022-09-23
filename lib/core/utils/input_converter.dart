import 'package:clean_architecture_project/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return const Left(InvalidInputFailure(message: 'Input not an integer'));
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required super.message});
}
