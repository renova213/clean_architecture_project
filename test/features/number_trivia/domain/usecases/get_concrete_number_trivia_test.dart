import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetConcreteNumberTrivia usecase =
      GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);

  const testNumber = 1;
  const testNumberTrivia = NumberTrivia(text: 'text', number: 1);

  test('should get trivia for the number from the repository', () async {
    when(
      mockNumberTriviaRepository.getConcreteNumberTrivia(1),
    ).thenAnswer(
      (_) async => const Right(testNumberTrivia),
    );

    final result = await usecase(
      const Params(number: testNumber),
    );

    expect(
      result,
      const Right(testNumberTrivia),
    );
    verify(
      mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber),
    );
  });
}
