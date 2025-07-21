import 'package:flutter/material.dart';

class WeatherLoadingState extends StatefulWidget {
  const WeatherLoadingState({super.key});

  @override
  State<WeatherLoadingState> createState() => _WeatherLoadingStateState();
}

class _WeatherLoadingStateState extends State<WeatherLoadingState>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                    transform: GradientRotation(_animation.value * 2 * 3.14159),
                  ),
                ),
                child: const Icon(
                  Icons.wb_cloudy,
                  size: 40,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Weather...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Getting current conditions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}