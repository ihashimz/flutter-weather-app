import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import 'location_service.dart';
import '../../features/weather/data/datasources/weather_remote_data_source.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/get_current_weather.dart';
import '../../features/weather/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Weather Feature - Data Sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
        () => WeatherRemoteDataSourceImpl(dioClient: sl()),
  );

  // Weather Feature - Repository
  sl.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Weather Feature - Use Cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));

  // Weather Feature - BLoC
  sl.registerFactory(() => WeatherBloc(getCurrentWeather: sl()));
}