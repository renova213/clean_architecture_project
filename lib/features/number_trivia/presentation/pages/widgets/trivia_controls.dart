import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _inputFieldNumber(),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: _searchNumberButton(),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: _randomNumberButton(),
            )
          ],
        )
      ],
    );
  }

  ElevatedButton _searchNumberButton() {
    return ElevatedButton(
      onPressed: () {
        addConcreteNumber(context);
      },
      child: const Text("Search"),
    );
  }

  ElevatedButton _randomNumberButton() {
    return ElevatedButton(
      onPressed: () {
        addRandomNumber(context);
      },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey)),
      child: const Text("Get Random Trivia"),
    );
  }

  TextField _inputFieldNumber() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (value) => setState(
        () {
          inputString = value;
        },
      ),
    );
  }

  void addConcreteNumber(context) {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(numberString: inputString),
    );
  }

  void addRandomNumber(context) {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandomNumber(),
    );
  }
}
