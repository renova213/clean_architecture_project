import 'package:bloc/bloc.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(const Loaded()) {
    on<NumberTriviaEvent>((event, emit) {});
  }
}
