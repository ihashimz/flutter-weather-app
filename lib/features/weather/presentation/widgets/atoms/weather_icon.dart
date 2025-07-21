import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconCode,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _getGradientForIcon(iconCode),
        boxShadow: [
          BoxShadow(
            color: _getGradientForIcon(iconCode).colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        _getIconForCode(iconCode),
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }

  IconData _getIconForCode(String code) {
    switch (code.substring(0, 2)) {
      case '01': // clear sky
        return Icons.wb_sunny;
      case '02': // few clouds
        return Icons.wb_cloudy;
      case '03': // scattered clouds
      case '04': // broken clouds
        return Icons.cloud;
      case '09': // shower rain
        return Icons.grain;
      case '10': // rain
        return Icons.beach_access;
      case '11': // thunderstorm
        return Icons.flash_on;
      case '13': // snow
        return Icons.ac_unit;
      case '50': // mist
        return Icons.blur_on;
      default:
        return Icons.wb_sunny;
    }
  }

  LinearGradient _getGradientForIcon(String code) {
    switch (code.substring(0, 2)) {
      case '01': // clear sky
        return const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '02': // few clouds
      case '03': // scattered clouds
      case '04': // broken clouds
        return const LinearGradient(
          colors: [Color(0xFF78909C), Color(0xFF546E7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '09': // shower rain
      case '10': // rain
        return const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '11': // thunderstorm
        return const LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '13': // snow
        return const LinearGradient(
          colors: [Color(0xFF90A4AE), Color(0xFF607D8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '50': // mist
        return const LinearGradient(
          colors: [Color(0xFFBDBDBD), Color(0xFF9E9E9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}