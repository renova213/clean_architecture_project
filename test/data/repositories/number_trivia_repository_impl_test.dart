import 'package:clean_architecture_project/core/error/exception.dart';
import 'package:clean_architecture_project/core/error/failure.dart';
import 'package:clean_architecture_project/core/platform/network_info.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_project/data/models/number_trivia_model.dart';
import 'package:clean_architecture_project/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_project/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  MockNumberTriviaRemoteDataSource remoteDataSource =
      MockNumberTriviaRemoteDataSource();
  MockNumberTriviaLocalDataSource localDataSource =
      MockNumberTriviaLocalDataSource();
  MockNetworkInfo networkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl repository = NumberTriviaRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  group('get concrete number trivia', () {
    const testNumber = 1;
    const testTriviaModel =
        NumberTriviaModel(text: 'test text', number: testNumber);
    const NumberTrivia testNumberTrivia = testTriviaModel;

    void runTestOnline(Function body) {
      group('device is online', () {
        setUp(
          () => when(networkInfo.isconnected).thenAnswer((_) async => true),
        );
        body();
      });
    }

    void runTestOffline(Function body) {
      group('device is offline', () {
        setUp(
          () => when(networkInfo.isconnected).thenAnswer((_) async => false),
        );
        body();
      });
    }

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(
          result,
          equals(const Right(testNumberTrivia)),
        );
      });

      test(
          'should cache data locally when the call to remote data source is successfull',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testTriviaModel);

        await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(localDataSource.cacheNumberTrivia(testTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any)).thenThrow(
          ServerException(),
        );

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));

        expect(
          result,
          equals(
            const Left(
              ServerFailure(message: "can't connect to server"),
            ),
          ),
        );
      });
    });

    runTestOffline(() {
      test("should return last locally cached data when the data is present",
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(localDataSource.getLastNumberTrivia());

        expect(
          result,
          equals(
            const Right(testNumberTrivia),
          ),
        );
      });
      test('should return cached failure when there is no cache data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(
          CacheException(),
        );

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(localDataSource.getLastNumberTrivia());
        expect(
          result,
          equals(
            const Left(
              CacheFailure(message: 'failed to cache'),
            ),
          ),
        );
      });
    });
  });

  group('get random number trivia', () {
    const testTriviaModel = NumberTriviaModel(text: 'test text', number: 1);
    const NumberTrivia testNumberTrivia = testTriviaModel;

    void runTestOnline(Function body) {
      group('device is online', () {
        setUp(
          () => when(networkInfo.isconnected).thenAnswer((_) async => true),
        );
        body();
      });
    }

    void runTestOffline(Function body) {
      group('device is offline', () {
        setUp(
          () => when(networkInfo.isconnected).thenAnswer((_) async => false),
        );
        body();
      });
    }

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        expect(
          result,
          equals(const Right(testNumberTrivia)),
        );
      });

      test(
          'should cache data locally when the call to remote data source is successfull',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(testTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
        when(remoteDataSource.getRandomNumberTrivia()).thenThrow(
          ServerException(),
        );

        final result = await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());

        expect(
          result,
          equals(
            const Left(
              ServerFailure(message: "can't connect to server"),
            ),
          ),
        );
      });
    });

    runTestOffline(() {
      test("should return last locally cached data when the data is present",
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(localDataSource.getLastNumberTrivia());

        expect(
          result,
          equals(
            const Right(testNumberTrivia),
          ),
        );
      });
      test('should return cached failure when there is no cache data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(
          CacheException(),
        );

        final result = await repository.getRandomNumberTrivia();

        verify(localDataSource.getLastNumberTrivia());
        expect(
          result,
          equals(
            const Left(
              CacheFailure(message: 'failed to cache'),
            ),
          ),
        );
      });
    });
  });
}
