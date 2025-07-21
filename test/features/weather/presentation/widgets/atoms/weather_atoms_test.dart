import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weather_app/features/weather/presentation/widgets/atoms/temperature_text.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/atoms/weather_icon.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/atoms/weather_metric_item.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('TemperatureText', () {
    testWidgets('should convert Kelvin to Celsius correctly', (WidgetTester tester) async {
      // Test core business logic: temperature conversion
      await tester.pumpWidget(createWidgetUnderTest(
        const TemperatureText(temperature: 298.15, fontSize: 48),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.text.toPlainText(), contains('25°'));
    });

    testWidgets('should round temperature to nearest integer', (WidgetTester tester) async {
      // Test rounding logic: 298.85K = 25.7°C -> rounds to 26°C
      await tester.pumpWidget(createWidgetUnderTest(
        const TemperatureText(temperature: 298.85, fontSize: 48),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.text.toPlainText(), contains('26'));
    });
  });

  group('WeatherIcon', () {
    testWidgets('should map weather codes to correct icons', (WidgetTester tester) async {
      // Test icon mapping business logic
      await tester.pumpWidget(createWidgetUnderTest(
        const WeatherIcon(iconCode: '01d', size: 64),
      ));
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);

      await tester.pumpWidget(createWidgetUnderTest(
        const WeatherIcon(iconCode: '10d', size: 64),
      ));
      expect(find.byIcon(Icons.beach_access), findsOneWidget);
    });
  });

  group('WeatherMetricItem', () {
    testWidgets('should display all metric components', (WidgetTester tester) async {
      // Test component displays all required data
      await tester.pumpWidget(createWidgetUnderTest(
        const WeatherMetricItem(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '65%',
        ),
      ));

      expect(find.byIcon(Icons.water_drop), findsOneWidget);
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });
  });
}