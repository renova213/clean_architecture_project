import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

typedef _ConcreteOrRandomChooser = Future Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(
      () => remoteDataSource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isconnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();

        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return const Left(
          ServerFailure(message: "can't connect to server"),
        );
      }
    } else {
      try {
        final localTriviaNumber = await localDataSource.getLastNumberTrivia();
        return Right(localTriviaNumber);
      } on CacheException {
        return const Left(
          CacheFailure(message: 'failed to cache'),
        );
      }
    }
  }
}
