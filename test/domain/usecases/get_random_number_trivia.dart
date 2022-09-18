import 'package:clean_architecture_project/core/usecases/usecase.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_project/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetRandomNumberTrivia usecase =
      GetRandomNumberTrivia(repository: mockNumberTriviaRepository);

  const testNumberTrivia = NumberTrivia(text: 'text', number: 1);

  test(
    'should get trivia from the repository',
    () async {
      when(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      ).thenAnswer(
        (_) async => const Right(testNumberTrivia),
      );

      final result = await usecase(
        NoParams(),
      );

      expect(
        result,
        const Right(testNumberTrivia),
      );
      verify(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      );
    },
  );
}
