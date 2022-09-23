import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_project/core/error/failure.dart';
import 'package:clean_architecture_project/core/usecases/usecase.dart';
import 'package:clean_architecture_project/core/utils/input_converter.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia =
      MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia =
      MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();
  NumberTriviaBloc bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter);

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const testNumberString = '1';
    const testNumberParsed = 1;
    const testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(testNumberParsed));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      build: () {
        setUpMockInputConverterSuccess();
        return bloc;
      },
      act: (bloc) async {
        bloc.add(
            const GetTriviaForConcreteNumber(numberString: testNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      },
      verify: (_) =>
          mockInputConverter.stringToUnsignedInteger(testNumberString),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
            const Left(
                InvalidInputFailure(message: invalidInputFailureMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: testNumberString)),
      expect: () => [const Error(errorMessage: invalidInputFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(testNumberTrivia));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(
            const GetTriviaForConcreteNumber(numberString: testNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      },
      verify: (_) =>
          mockGetConcreteNumberTrivia(const Params(number: testNumberParsed)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(testNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: testNumberString)),
      expect: () => [Loading(), const Loaded(trivia: testNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async =>
            const Left(ServerFailure(message: serverFailureMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: testNumberString)),
      expect: () =>
          [Loading(), const Error(errorMessage: serverFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async =>
            const Left(CacheFailure(message: cacheFailureMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(
          const GetTriviaForConcreteNumber(numberString: testNumberString)),
      expect: () => [Loading(), const Error(errorMessage: cacheFailureMessage)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    const testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the random use case',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(testNumberTrivia));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
      },
      verify: (_) => mockGetRandomNumberTrivia(NoParams()),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(testNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Loaded(trivia: testNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async =>
            const Left(ServerFailure(message: serverFailureMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          [Loading(), const Error(errorMessage: serverFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async =>
            const Left(CacheFailure(message: cacheFailureMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Error(errorMessage: cacheFailureMessage)],
    );
  });
}
