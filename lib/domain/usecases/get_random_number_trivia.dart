import 'package:clean_architecture_project/core/usecases/usecase.dart';
import 'package:clean_architecture_project/core/error/failure.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams param) async {
    return await repository.getRandomNumberTrivia();
  }
}
