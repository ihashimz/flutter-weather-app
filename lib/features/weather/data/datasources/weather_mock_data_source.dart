import '../../domain/entities/weather.dart';

class WeatherMockDataSource {
  static Weather getMockWeather() {
    return Weather(
      latitude: 44.34,
      longitude: 10.99,
      cityName: 'Zocca',
      country: 'IT',
      mainCondition: 'Clouds',
      description: 'broken clouds',
      iconCode: '04d',
      temperature: 301.1,
      feelsLike: 301.37,
      tempMin: 301.1,
      tempMax: 301.1,
      pressure: 1008,
      humidity: 48,
      windSpeed: 1.24,
      windDirection: 113,
      windGust: 3.56,
      cloudCoverage: 51,
      visibility: 10000,
      dateTime: DateTime.now(),
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 8)),
    );
  }

  static Weather getMockWeatherSunny() {
    return Weather(
      latitude: 25.276987,
      longitude: 55.296249,
      cityName: 'Dubai',
      country: 'AE',
      mainCondition: 'Clear',
      description: 'clear sky',
      iconCode: '01d',
      temperature: 305.15,
      feelsLike: 308.15,
      tempMin: 304.15,
      tempMax: 306.15,
      pressure: 1013,
      humidity: 65,
      windSpeed: 2.1,
      windDirection: 220,
      windGust: null,
      cloudCoverage: 0,
      visibility: 10000,
      dateTime: DateTime.now(),
      sunrise: DateTime.now().subtract(const Duration(hours: 1)),
      sunset: DateTime.now().add(const Duration(hours: 10)),
    );
  }

  static Weather getMockWeatherRainy() {
    return Weather(
      latitude: 51.5074,
      longitude: -0.1278,
      cityName: 'London',
      country: 'GB',
      mainCondition: 'Rain',
      description: 'moderate rain',
      iconCode: '10d',
      temperature: 288.15,
      feelsLike: 286.15,
      tempMin: 287.15,
      tempMax: 289.15,
      pressure: 1008,
      humidity: 87,
      windSpeed: 4.5,
      windDirection: 180,
      windGust: 7.2,
      cloudCoverage: 90,
      visibility: 8000,
      dateTime: DateTime.now(),
      sunrise: DateTime.now().subtract(const Duration(hours: 3)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
    );
  }
}