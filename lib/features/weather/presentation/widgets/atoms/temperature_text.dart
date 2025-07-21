import 'package:flutter/material.dart';

class TemperatureText extends StatelessWidget {
  final double temperature;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final bool showUnit;

  const TemperatureText({
    super.key,
    required this.temperature,
    this.fontSize = 48,
    this.fontWeight = FontWeight.w300,
    this.color,
    this.showUnit = true,
  });

  @override
  Widget build(BuildContext context) {
    final tempInCelsius = temperature - 273.15;
    
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: tempInCelsius.round().toString(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color ?? Theme.of(context).textTheme.displayLarge?.color,
              height: 1.0,
            ),
          ),
          if (showUnit)
            TextSpan(
              text: '°',
              style: TextStyle(
                fontSize: fontSize * 0.6,
                fontWeight: fontWeight,
                color: color ?? Theme.of(context).textTheme.displayLarge?.color,
                height: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}