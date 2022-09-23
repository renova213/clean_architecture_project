import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

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

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(event, emit) async {
    final inputError =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputError.fold(
      (failure) => emit(const Error(errorMessage: invalidInputFailureMessage)),
      (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      },
    );
  }

  void _onGetTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());

    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherLoadedOrErrorState(emit, failureOrTrivia);
  }
}

void _eitherLoadedOrErrorState(emit, failureOrTrivia) async {
  await failureOrTrivia.fold(
    (failure) => emit(Error(errorMessage: _mapFailureToMessage(failure))),
    (trivia) => emit(
      Loaded(trivia: trivia),
    ),
  );
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
