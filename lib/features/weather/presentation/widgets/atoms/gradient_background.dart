import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final String weatherCondition;

  const GradientBackground({
    super.key,
    required this.child,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getGradientForWeather(weatherCondition),
      ),
      child: child,
    );
  }

  LinearGradient _getGradientForWeather(String condition) {
    final conditionLower = condition.toLowerCase();
    
    if (conditionLower.contains('clear')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4FC3F7),
          Color(0xFF29B6F6),
          Color(0xFF03A9F4),
        ],
      );
    } else if (conditionLower.contains('cloud')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF78909C),
          Color(0xFF546E7A),
          Color(0xFF37474F),
        ],
      );
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF42A5F5),
          Color(0xFF1E88E5),
          Color(0xFF1565C0),
        ],
      );
    } else if (conditionLower.contains('thunder')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF5C6BC0),
          Color(0xFF3F51B5),
          Color(0xFF283593),
        ],
      );
    } else if (conditionLower.contains('snow')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF90A4AE),
          Color(0xFF607D8B),
          Color(0xFF455A64),
        ],
      );
    } else if (conditionLower.contains('mist') || conditionLower.contains('fog')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFBDBDBD),
          Color(0xFF9E9E9E),
          Color(0xFF757575),
        ],
      );
    } else {
      // Default gradient for unknown conditions
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4FC3F7),
          Color(0xFF29B6F6),
          Color(0xFF03A9F4),
        ],
      );
    }
  }
}