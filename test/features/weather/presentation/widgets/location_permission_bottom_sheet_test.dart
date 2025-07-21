import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weather_app/features/weather/presentation/widgets/location_permission_bottom_sheet.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => LocationPermissionBottomSheet.show(context),
            child: const Text('Show Bottom Sheet'),
          ),
        ),
      ),
    );
  }

  group('LocationPermissionBottomSheet', () {
    testWidgets('should display location permission UI elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle(); // Wait for bottom sheet animation

      // Assert
      expect(find.text('Enable Location Access'), findsOneWidget);
      expect(find.text('📍'), findsOneWidget);
      expect(find.text('We need access to your location to provide you with accurate weather information for your current area. 🌤️'), findsOneWidget);
      expect(find.text('Not Now'), findsOneWidget);
      expect(find.text('Allow Location'), findsOneWidget);
    });

    testWidgets('should return true when Allow Location is tapped', (WidgetTester tester) async {
      // Arrange
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await LocationPermissionBottomSheet.show(context);
                },
                child: const Text('Show Bottom Sheet'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Allow Location'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, isTrue);
    });

    testWidgets('should return false when Not Now is tapped', (WidgetTester tester) async {
      // Arrange
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await LocationPermissionBottomSheet.show(context);
                },
                child: const Text('Show Bottom Sheet'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Not Now'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, isFalse);
    });

    testWidgets('should return null when dismissed by tapping outside', (WidgetTester tester) async {
      // Arrange
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await LocationPermissionBottomSheet.show(context);
                },
                child: const Text('Show Bottom Sheet'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();
      
      // Tap outside to dismiss
      await tester.tapAt(const Offset(200, 100)); // Tap above the bottom sheet
      await tester.pumpAndSettle();

      // Assert
      expect(result, isNull);
    });

    testWidgets('should have correct styling for buttons', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Assert - Check button styles
      final allowButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Allow Location'),
      );
      final notNowButton = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Not Now'),
      );

      expect(allowButton.style?.backgroundColor?.resolve({}), equals(const Color(0xFF546E7A)));
      expect(notNowButton.style?.side?.resolve({}), isNotNull);
    });

    testWidgets('should display circular location icon', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Assert
      final iconContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(Container),
          matching: find.byWidgetPredicate(
            (widget) => widget is Container && 
                       widget.decoration is BoxDecoration &&
                       (widget.decoration as BoxDecoration).shape == BoxShape.circle,
          ),
        ).first,
      );

      final decoration = iconContainer.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
      expect(decoration.color, equals(Colors.blue[50]));
    });

    testWidgets('should have proper padding and spacing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Assert - Check if SizedBox widgets are present for spacing
      expect(find.byWidgetPredicate((widget) => 
        widget is SizedBox && widget.height == 32), findsAtLeastNWidgets(1));
      expect(find.byWidgetPredicate((widget) => 
        widget is SizedBox && widget.height == 24), findsAtLeastNWidgets(1));
      expect(find.byWidgetPredicate((widget) => 
        widget is SizedBox && widget.height == 16), findsAtLeastNWidgets(2));
    });
  });
}