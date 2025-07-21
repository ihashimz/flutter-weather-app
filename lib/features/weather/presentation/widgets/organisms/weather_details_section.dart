import 'package:flutter/material.dart';
import '../../../domain/entities/weather.dart';
import '../molecules/weather_metrics_grid.dart';
import '../molecules/sun_times_card.dart';

class WeatherDetailsSection extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsSection({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Weather Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        const SizedBox(height: 16),
        WeatherMetricsGrid(
          humidity: weather.humidity,
          windSpeed: weather.windSpeed,
          windGust: weather.windGust,
          pressure: weather.pressure,
          visibility: weather.visibility,
          cloudCoverage: weather.cloudCoverage,
          tempMin: weather.tempMin,
          tempMax: weather.tempMax,
        ),
        const SizedBox(height: 20),
        SunTimesCard(
          sunrise: weather.sunrise,
          sunset: weather.sunset,
        ),
      ],
    );
  }
}