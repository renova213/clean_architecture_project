import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import 'widgets/trivia_controls.dart';
import 'widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Number Trivia"),
        ),
        body: SingleChildScrollView(
          child: _body(),
        ),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Empty) {
                return const MessageDisplay(
                  message: "Start Searching!",
                );
              } else if (state is Error) {
                return MessageDisplay(
                  message: state.errorMessage!,
                );
              } else if (state is Loading) {
                return const LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(numberTrivia: state.trivia!);
              } else {
                return const LoadingWidget();
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const TriviaControls(),
        ],
      ),
    );
  }
}
