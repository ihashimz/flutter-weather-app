import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Use CORS proxy for web testing, direct API for mobile/desktop
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String corsProxyUrl = 'https://cors-anywhere.herokuapp.com/https://api.openweathermap.org/data/2.5';
  
  // Load API key from environment variables
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  
  static const String weatherEndpoint = '/weather';
  
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Get appropriate base URL based on platform
  static String getBaseUrl() {
    // You can add kIsWeb check here if needed
    return baseUrl; // Use direct API for now
  }
}