import 'package:flutter_health_app/src/data/data_context/interfaces/weather_datacontext.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/data/repositories/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherDataContext extends Mock implements IWeatherDataContext {}

void main() {
  group('WeatherRepository', () {
    late IWeatherRepository weatherRepository;
    late IWeatherDataContext mockWeatherDataContext;

    setUp(() {
      mockWeatherDataContext = MockWeatherDataContext();
      weatherRepository = WeatherRepository(mockWeatherDataContext);
    });

    test('insert should call insert on the data context', () async {
      // Arrange
      final weather =
          Weather(temperature: 18, timestamp: DateTime(2023, 11, 1));
      when(() => mockWeatherDataContext.insert(weather.toMap()))
          .thenAnswer((_) async => {});

      // Act
      await weatherRepository.insert(weather);

      // Assert
      verify(() => mockWeatherDataContext.insert(weather.toMap())).called(1);
    });

    test('getLastest should return null if data context returns null',
        () async {
      // Arrange
      when(() => mockWeatherDataContext.getLastest())
          .thenAnswer((_) async => null);

      // Act
      final result = await weatherRepository.getLastest();

      // Assert
      expect(result, isNull);
    });

    test(
        'getLastest should return a Weather object if data context returns a map',
        () async {
      // Arrange
      final weatherMap = {
        'temperature': 18,
        'timestamp': DateTime(2023, 11, 1, 14, 00, 30).toString(),
      };
      final expectedWeather = Weather.fromMap(weatherMap);
      when(() => mockWeatherDataContext.getLastest())
          .thenAnswer((_) async => weatherMap);

      // Act
      final result = await weatherRepository.getLastest();

      // Assert
      expect(result?.toMap(), expectedWeather.toMap());
    });
  });
}
