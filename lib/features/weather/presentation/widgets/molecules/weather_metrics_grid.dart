import 'package:flutter/material.dart';
import '../atoms/weather_metric_item.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final int humidity;
  final double windSpeed;
  final double? windGust;
  final int pressure;
  final int visibility;
  final int cloudCoverage;
  final double tempMin;
  final double tempMax;

  const WeatherMetricsGrid({
    super.key,
    required this.humidity,
    required this.windSpeed,
    this.windGust,
    required this.pressure,
    required this.visibility,
    required this.cloudCoverage,
    required this.tempMin,
    required this.tempMax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: WeatherMetricItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '$humidity%',
                  iconColor: Colors.blue.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WeatherMetricItem(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${windSpeed.toStringAsFixed(1)} m/s',
                  iconColor: Colors.green.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WeatherMetricItem(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '$pressure hPa',
                  iconColor: Colors.orange.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: WeatherMetricItem(
                  icon: Icons.visibility,
                  label: 'Visibility',
                  value: '${(visibility / 1000).toStringAsFixed(1)} km',
                  iconColor: Colors.purple.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WeatherMetricItem(
                  icon: Icons.cloud,
                  label: 'Clouds',
                  value: '$cloudCoverage%',
                  iconColor: Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 12),
              if (windGust != null)
                Expanded(
                  child: WeatherMetricItem(
                    icon: Icons.wind_power,
                    label: 'Gust',
                    value: '${windGust!.toStringAsFixed(1)} m/s',
                    iconColor: Colors.teal.shade300,
                  ),
                )
              else
                Expanded(
                  child: WeatherMetricItem(
                    icon: Icons.thermostat,
                    label: 'Range',
                    value: '${(tempMin - 273.15).round()}°/${(tempMax - 273.15).round()}°',
                    iconColor: Colors.red.shade300,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}