import 'package:flutter/material.dart';

class SunTimesCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunTimesCard({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSunTimeItem(
              icon: Icons.wb_sunny,
              label: 'Sunrise',
              time: _formatTime(sunrise),
              color: Colors.orange.shade300,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildSunTimeItem(
              icon: Icons.brightness_3,
              label: 'Sunset',
              time: _formatTime(sunset),
              color: Colors.deepPurple.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}