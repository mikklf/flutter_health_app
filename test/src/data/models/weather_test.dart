import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Weather', () {
    test('toMap() should return a map with all properties', () {
      // Arrange
      final weather = Weather(
        temperature: 20,
        temperatureFeelsLike: 18,
        humidity: 70,
        cloudinessPercent: 50,
        weatherCondition: 'Cloudy',
        weatherdescription: 'Mostly cloudy skies',
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        sunrise: DateTime.now().add(const Duration(hours: 1)),
        sunset: DateTime.now().add(const Duration(hours: 10)),
      );

      // Act
      final map = weather.toMap();

      // Assert
      expect(map['temperature'], 20);
      expect(map['temperature_feels_like'], 18);
      expect(map['humidity'], 70);
      expect(map['cloudiness_percent'], 50);
      expect(map['weather_condition'], 'Cloudy');
      expect(map['weather_description'], 'Mostly cloudy skies');
      expect(map['latitude'], 37.7749);
      expect(map['longitude'], -122.4194);
      expect(map['sunrise'], weather.sunrise.toString());
      expect(map['sunset'], weather.sunset.toString());
    });

    test('fromMap() should return a Weather object with all properties', () {
      // Arrange
      final map = {
        'temperature': 20,
        'temperature_feels_like': 18,
        'humidity': 70,
        'cloudiness_percent': 50,
        'weather_condition': 'Cloudy',
        'weather_description': 'Mostly cloudy skies',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'timestamp': DateTime.now().toString(),
        'sunrise': DateTime.now().add(const Duration(hours: 1)).toString(),
        'sunset': DateTime.now().add(const Duration(hours: 10)).toString(),
      };

      // Act
      final weather = Weather.fromMap(map);

      // Assert
      expect(weather.temperature, 20);
      expect(weather.temperatureFeelsLike, 18);
      expect(weather.humidity, 70);
      expect(weather.cloudinessPercent, 50);
      expect(weather.weatherCondition, 'Cloudy');
      expect(weather.weatherdescription, 'Mostly cloudy skies');
      expect(weather.latitude, 37.7749);
      expect(weather.longitude, -122.4194);
      expect(weather.sunrise, isNotNull);
      expect(weather.sunset, isNotNull);
    });

    test('copyWith() should return a new Weather object with updated properties', () {
      // Arrange
      final weather = Weather(
        temperature: 20,
        temperatureFeelsLike: 18,
        humidity: 70,
        cloudinessPercent: 50,
        weatherCondition: 'Cloudy',
        weatherdescription: 'Mostly cloudy skies',
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        sunrise: DateTime.now().add(const Duration(hours: 1)),
        sunset: DateTime.now().add(const Duration(hours: 10)),
      );

      // Act
      final updatedWeather = weather.copyWith(
        temperature: 25,
        humidity: 80,
      );

      // Assert
      expect(updatedWeather.temperature, 25);
      expect(updatedWeather.temperatureFeelsLike, 18);
      expect(updatedWeather.humidity, 80);
      expect(updatedWeather.cloudinessPercent, 50);
      expect(updatedWeather.weatherCondition, 'Cloudy');
      expect(updatedWeather.weatherdescription, 'Mostly cloudy skies');
      expect(updatedWeather.latitude, 37.7749);
      expect(updatedWeather.longitude, -122.4194);
      expect(updatedWeather.sunrise, weather.sunrise);
      expect(updatedWeather.sunset, weather.sunset);
    });
  });
}