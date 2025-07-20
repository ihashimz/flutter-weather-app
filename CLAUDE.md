## Project Architecture and Design

- Created a Flutter weather app using clean architecture principles
- Implemented a domain-driven design with a structured approach
- Core layer includes foundational components:
  * API setup
  * Constants
  * Error handling
  * Network configuration
  * Services
  * Utility functions
- Features layer focuses on weather feature with layered structure:
  * Data layer
  * Domain layer
  * Presentation layer
- Used Dio for network requests
- Utilized Cubit for state management

## API Configuration

- Integrated OpenWeatherMap API for retrieving weather data
- Example API endpoint: `https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=2f4565f193d4a168ef3b85cd40075a71`
- Uses GET request to fetch weather information based on latitude and longitude
- Requires API key for authentication

## API Response Examples

- Sample weather data response for Zocca, Italy:
  * Coordinates: Longitude 10.99, Latitude 44.34
  * Weather condition: Broken clouds (ID: 803)
  * Temperature: 301.1K (feels like 301.37K)
  * Humidity: 48%
  * Wind speed: 1.24 m/s, Direction: 113 degrees
  * Cloud coverage: 51%
  * Country: Italy
  * Timestamp: Represents a specific moment in time