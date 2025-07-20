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