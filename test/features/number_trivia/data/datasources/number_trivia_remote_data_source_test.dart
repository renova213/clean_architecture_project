import 'dart:convert';

import 'package:clean_architecture_project/core/error/exception.dart';
import 'package:clean_architecture_project/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_project/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  MockHttpClient mockHttp = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl dataSource =
      NumberTriviaRemoteDataSourceImpl(client: mockHttp);

  const testNumber = 1;
  NumberTriviaModel testNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  void setUpMockDioStatusCode200() {
    when(
      mockHttp.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockDioStatusCode404() {
    when(mockHttp.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('concrete number trivia', () {
    test('should return numberTrivia when the responseCode is 200', () async {
      setUpMockDioStatusCode200();

      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      verify(mockHttp.get(Uri.parse('http://numbersapi.com/$testNumber'),
          headers: {'Content-Type': 'application/json'}));

      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw serverException when the response 404 or other than 200',
        () async {
      setUpMockDioStatusCode404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(testNumber),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get random number trivia', () {
    test('should return numberTrivia when the responseCode is 200', () async {
      setUpMockDioStatusCode200();

      final result = await dataSource.getRandomNumberTrivia();

      verify(mockHttp.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));

      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw serverException when the response 404 or other than 200',
        () async {
      setUpMockDioStatusCode404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
