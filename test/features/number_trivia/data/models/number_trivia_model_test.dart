import 'dart:convert';

import 'package:clean_architecture_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test('should be a subclass of NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test('should return valid model when the JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('trivia.json'),
      );

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testNumberTriviaModel);
    });
    test('should return valid model when the JSON number is an double',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('trivia_double.json'),
      );

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testNumberTriviaModel);
    });
  });

  group('to json', () {
    test('should return json map containing the proper data', () async {
      final result = testNumberTriviaModel.toJson();

      final expectedMap = {"text": "test text", "number": 1};

      expect(result, expectedMap);
    });
  });
}
