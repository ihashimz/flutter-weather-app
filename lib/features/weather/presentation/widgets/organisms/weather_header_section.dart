import 'package:flutter/material.dart';
import '../../../domain/entities/weather.dart';
import '../molecules/weather_summary_card.dart';

class WeatherHeaderSection extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onRefresh;

  const WeatherHeaderSection({
    super.key,
    required this.weather,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context),
        WeatherSummaryCard(
          cityName: weather.cityName,
          country: weather.country,
          condition: weather.mainCondition,
          description: weather.description,
          iconCode: weather.iconCode,
          temperature: weather.temperature,
          feelsLike: weather.feelsLike,
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 50,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getCurrentGreeting(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                'Weather Today',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: onRefresh,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}