import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/logic/weather_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

class MockWeatherProvider extends Mock implements IWeatherProvider {}

void main() {
  late Database db;
  late WeatherCubit weatherCubit;

  setUp(() async {
    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerFactory<IDatabaseHelper>(() => InMemoryDatabaseHelper());

    services.unregister<IWeatherProvider>();
    services.registerSingleton<IWeatherProvider>(MockWeatherProvider());

    weatherCubit = WeatherCubit(
        services.get<IWeatherRepository>(), services.get<IWeatherProvider>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  group('Weather integration test', () {
    test('load lastest weather information from database', () async {
      var weather = Weather(
        temperature: 20,
        temperatureFeelsLike: 25,
        humidity: 60,
        cloudinessPercent: 20,
        weatherCondition: 'Clear',
        latitude: 40.7128,
        longitude: -74.0060,
        timestamp: DateTime(2023, 1, 1, 6, 0, 0),
        sunrise: DateTime(2023, 1, 1, 6, 30, 0),
        sunset: DateTime(2023, 1, 1, 18, 0, 0),
      );

      // Arrange
      await db.insert(
          'weather',
          Weather(
            temperature: 11,
            timestamp: DateTime(2022, 12, 31, 6, 0, 0),
          ).toMap());
      await db.insert('weather', weather.toMap());

      // Act
      await weatherCubit.loadCurrentWeather();

      // Assert
      expect(weatherCubit.state.weatherData?.temperature, weather.temperature);
    });

    test('save weather information on location update', () async {
      // Arrange
      final locationDto = LocationDto.fromJson({
      'latitude': 0.0,
      'longitude': 0.0,
      'altitude': 0.0,
      'accuracy': 0.0,
      'speed': 0.0,
      'speed_accuracy': 0.0,
      'heading': 0.0,
      'time': 0.0,
      'is_mocked': false,
      'provider': 'fused',
      });

      when(() => services.get<IWeatherProvider>().fetchWeather(any(), any()))
          .thenAnswer((_) async => Weather(
            temperature: 16,
            temperatureFeelsLike: 14,
            humidity: 60,
            cloudinessPercent: 20,
            weatherCondition: 'Clear',
            latitude: 40.7128,
            longitude: -74.0060,
            timestamp: DateTime(2023, 1, 1, 6, 0, 0),
            sunrise: DateTime(2023, 1, 1, 6, 30, 0),
            sunset: DateTime(2023, 1, 1, 18, 0, 0),
          ));

      // Act
      await weatherCubit.onLocationUpdates(locationDto);

      // Assert
      expect(weatherCubit.state.weatherData?.temperature, 16);

    }); 
  });
}
