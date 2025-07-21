import 'package:flutter/material.dart';

class WeatherErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const WeatherErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.cloud_off,
                size: 50,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}