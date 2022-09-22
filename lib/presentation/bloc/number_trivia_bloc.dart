import 'package:bloc/bloc.dart';
import 'package:clean_architecture_project/core/usecases/usecase.dart';
import 'package:clean_architecture_project/core/utils/input_converter.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_project/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';

import '../../core/error/failure.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(this.getConcreteNumberTrivia, this.getRandomNumberTrivia,
      this.inputConverter)
      : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) {
    final inputError =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputError.fold(
        (failure) =>
            emit(const Error(errorMessage: invalidInputFailureMessage)),
        (integer) async {
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      _eitherLoadedOrErrorState(emit, failureOrTrivia);
    });
  }

  void _onGetTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());

    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherLoadedOrErrorState(emit, failureOrTrivia);
  }
}

void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
    Either<Failure, NumberTrivia> failureOrTrivia) {
  failureOrTrivia.fold(
      (failure) => emit(Error(errorMessage: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)));
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected Error';
  }
}
