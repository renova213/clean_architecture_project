part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia? trivia;

  const Loaded({this.trivia});
}

class Error extends NumberTriviaState {
  final String errorMessage;

  const Error({required this.errorMessage});
}
