import 'dart:convert';

import 'package:clean_architecture_project/core/error/exception.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_project/data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  MockDio mockDio = MockDio();
  NumberTriviaRemoteDataSourceImpl dataSource =
      NumberTriviaRemoteDataSourceImpl(client: mockDio);

  const testNumber = 1;
  NumberTriviaModel testNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  void setUpMockDioStatusCode200() {
    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
          requestOptions:
              RequestOptions(path: 'http://numbersapi.com/$testNumber'),
          data: fixture('trivia.json'),
          statusCode: 200),
    );
  }

  void setUpMockDioStatusCode404() {
    when(mockDio.get(any)).thenAnswer((_) async => Response(
        requestOptions:
            RequestOptions(path: 'http://numbersapi.com/$testNumber'),
        data: {'message': 'something wrong'},
        statusCode: 404));
  }

  group('concrete number trivia', () {
    test('should return numberTrivia when the responseCode is 200', () async {
      setUpMockDioStatusCode200();

      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      verify(mockDio.get(
        'http://numbersapi.com/$testNumber',
      ));

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

      verify(mockDio.get(
        'http://numbersapi.com/$testNumber',
      ));

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
