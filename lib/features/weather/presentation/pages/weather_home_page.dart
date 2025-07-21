import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/service_locator.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../templates/weather_home_template.dart';
import '../widgets/location_permission_bottom_sheet.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  static const double _defaultLatitude = 24.774265; // Riyadh SA
  static const double _defaultLongitude = 46.738586;
  
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLocationDenied = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndLoad();
  }
  
  Future<void> _checkLocationPermissionAndLoad() async {
    final locationService = sl<LocationService>();
    final hasPermission = await locationService.isLocationPermissionGranted();
    
    if (hasPermission) {
      await _getCurrentLocationAndLoad();
    } else {
      final shouldShowRequest = await locationService.shouldShowPermissionRequest();
      if (shouldShowRequest) {
        _showLocationPermissionBottomSheet();
      } else {
        // Permission permanently denied or not available, show location denied state
        setState(() {
          _isLocationDenied = true;
        });
      }
    }
  }
  
  Future<void> _showLocationPermissionBottomSheet() async {
    final result = await LocationPermissionBottomSheet.show(context);
    
    if (result == true) {
      final locationService = sl<LocationService>();
      final permissionResult = await locationService.requestLocationPermission();
      
      permissionResult.fold(
        (failure) => _loadWeather(), // Use default location on failure
        (granted) {
          if (granted) {
            setState(() {
              _isLocationDenied = false;
            });
            _getCurrentLocationAndLoad();
          } else {
            setState(() {
              _isLocationDenied = true;
            });
          }
        },
      );
    } else {
      setState(() {
        _isLocationDenied = true;
      });
    }
  }
  
  Future<void> _getCurrentLocationAndLoad() async {
    final locationService = sl<LocationService>();
    final result = await locationService.getCurrentLocation();
    
    result.fold(
      (failure) {
        _loadWeather(); // Use default location on failure
      },
      (position) {
        setState(() {
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
        });
        _loadWeather();
      },
    );
  }

  void _loadWeather() {
    context.read<WeatherBloc>().add(
          GetCurrentWeatherEvent(
            latitude: _currentLatitude ?? _defaultLatitude,
            longitude: _currentLongitude ?? _defaultLongitude,
          ),
        );
  }

  void _refreshWeather() {
    context.read<WeatherBloc>().add(
          RefreshWeatherEvent(
            latitude: _currentLatitude ?? _defaultLatitude,
            longitude: _currentLongitude ?? _defaultLongitude,
          ),
        );
  }

  Future<void> _requestLocationAccess() async {
    await _checkLocationPermissionAndLoad();
  }

  void _continueWithDefault() {
    setState(() {
      _isLocationDenied = false;
    });
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    // Show location denied state if location is denied
    if (_isLocationDenied) {
      return WeatherHomeTemplate(
        state: WeatherScreenState.locationDenied,
        onRequestLocation: _requestLocationAccess,
        onRetry: _continueWithDefault,
      );
    }

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const WeatherHomeTemplate(
            state: WeatherScreenState.loading,
          );
        } else if (state is WeatherLoaded) {
          return WeatherHomeTemplate(
            state: WeatherScreenState.loaded,
            weather: state.weather,
            onRefresh: _refreshWeather,
            onRetry: _loadWeather,
          );
        } else if (state is WeatherError) {
          return WeatherHomeTemplate(
            state: WeatherScreenState.error,
            errorMessage: state.message,
            onRetry: _loadWeather,
          );
        } else {
          // Initial state
          return const WeatherHomeTemplate(
            state: WeatherScreenState.loading,
          );
        }
      },
    );
  }
}