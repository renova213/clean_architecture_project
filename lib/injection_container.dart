import 'package:clean_architecture_project/core/network/network_info.dart';
import 'package:clean_architecture_project/core/utils/input_converter.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_project/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_project/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_project/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_project/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_project/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_project/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features = Number Trivia
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      sl(),
      sl(),
      sl(),
    ),
  );

  //Usecases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(
      repository: sl(),
    ),
  );

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data Source
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => InputConverter(),
  );

  //! external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(
    () => Dio(),
  );
  sl.registerLazySingleton(() => DataConnectionChecker());
}

void initFeature() {}
