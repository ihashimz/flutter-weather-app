import 'package:flutter/material.dart';
import '../atoms/weather_icon.dart';
import '../atoms/temperature_text.dart';

class WeatherSummaryCard extends StatelessWidget {
  final String cityName;
  final String country;
  final String condition;
  final String description;
  final String iconCode;
  final double temperature;
  final double feelsLike;

  const WeatherSummaryCard({
    super.key,
    required this.cityName,
    required this.country,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.feelsLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    country,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              WeatherIcon(
                iconCode: iconCode,
                size: 80,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TemperatureText(
                    temperature: temperature,
                    fontSize: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feels like ${(feelsLike - 273.15).round()}°',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    condition,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}