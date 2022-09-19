import 'dart:convert';

import 'package:clean_architecture_project/core/error/exception.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_project/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSourceImpl dataSource =
      NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);

  group('get last number trivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test(
        'should return NumberTrivia from sharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw cache exception when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cachedNumberTrivia', () {
    const testNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test text');
    test('should call SharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      dataSource.cacheNumberTrivia(testNumberTriviaModel);

      final expectedJsonString = json.encode(testNumberTriviaModel.toJson());

      verify(mockSharedPreferences.setString(
          cachedNumberTrivia, expectedJsonString));
    });
  });
}
