import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;

  WeatherBloc({required this.getCurrentWeather}) : super(const WeatherInitial()) {
    on<GetCurrentWeatherEvent>(_onGetCurrentWeather);
    on<RefreshWeatherEvent>(_onRefreshWeather);
  }

  Future<void> _onGetCurrentWeather(
    GetCurrentWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    final params = GetCurrentWeatherParams(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    final result = await getCurrentWeather(params);

    result.fold(
      (failure) => emit(WeatherError(message: failure.message)),
      (weather) => emit(WeatherLoaded(weather: weather)),
    );
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final params = GetCurrentWeatherParams(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    final result = await getCurrentWeather(params);

    result.fold(
      (failure) => emit(WeatherError(message: failure.message)),
      (weather) => emit(WeatherLoaded(weather: weather)),
    );
  }
}