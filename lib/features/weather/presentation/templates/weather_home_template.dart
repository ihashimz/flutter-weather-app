import 'package:flutter/material.dart';
import '../widgets/atoms/gradient_background.dart';
import '../widgets/organisms/weather_header_section.dart';
import '../widgets/organisms/weather_details_section.dart';
import '../widgets/organisms/weather_loading_state.dart';
import '../widgets/organisms/weather_error_state.dart';
import '../../domain/entities/weather.dart';

enum WeatherScreenState { loading, loaded, error, locationDenied }

class WeatherHomeTemplate extends StatelessWidget {
  final WeatherScreenState state;
  final Weather? weather;
  final String? errorMessage;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final VoidCallback? onRequestLocation;

  const WeatherHomeTemplate({
    super.key,
    required this.state,
    this.weather,
    this.errorMessage,
    this.onRefresh,
    this.onRetry,
    this.onRequestLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        weatherCondition: weather?.mainCondition ?? 'Clear',
        child: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case WeatherScreenState.loading:
        return const WeatherLoadingState();
      
      case WeatherScreenState.error:
        return WeatherErrorState(
          message: errorMessage ?? 'Failed to load weather data',
          onRetry: onRetry,
        );
      
      case WeatherScreenState.locationDenied:
        return _buildLocationDeniedState();
      
      case WeatherScreenState.loaded:
        if (weather == null) {
          return WeatherErrorState(
            message: 'No weather data available',
            onRetry: onRetry,
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            onRefresh?.call();
          },
          backgroundColor: Colors.white.withOpacity(0.9),
          color: Colors.blue.shade600,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                WeatherHeaderSection(
                  weather: weather!,
                  onRefresh: onRefresh,
                ),
                const SizedBox(height: 20),
                WeatherDetailsSection(
                  weather: weather!,
                ),
                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildLocationDeniedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '📍',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Location Access Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We need access to your location to provide accurate weather information for your area. Using default location for now.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRequestLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Request Location Access',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Continue with default location',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Divider(
            color: Colors.white.withOpacity(0.2),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                'Last updated: ${_formatLastUpdated()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}