import 'package:clean_architecture_project/common/failure.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
