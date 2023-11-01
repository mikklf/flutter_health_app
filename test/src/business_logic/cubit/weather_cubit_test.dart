import 'package:bloc_test/bloc_test.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter_health_app/src/business_logic/cubit/weather_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWeatherRepository extends Mock implements IWeatherRepository {}

class MockWeatherProvider extends Mock implements IWeatherProvider {}

class WeatherFake extends Fake implements Weather {}

void main() {
  late IWeatherRepository weatherRepository;
  late IWeatherProvider weatherProvider;
  late WeatherCubit weatherCubit;

  setUpAll(() {
    registerFallbackValue(WeatherFake());
  });

  setUp(() {
    weatherRepository = MockWeatherRepository();
    weatherProvider = MockWeatherProvider();
    weatherCubit = WeatherCubit(weatherRepository, weatherProvider);
  });

  group('WeatherCubit', () {
    final weather = Weather(
      temperature: 20,
      timestamp: DateTime.parse("2021-10-20 20:18:04.000"),
    );

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

    test('initial state is WeatherState with timestamp of DateTime(0)', () {
      expect(weatherCubit.state, WeatherState(timestamp: DateTime(0)));
    });

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState] when loadCurrentWeather is called',
      build: () {
        when(() => weatherRepository.getLastest())
            .thenAnswer((_) async => weather);
        return weatherCubit;
      },
      act: (cubit) => cubit.loadCurrentWeather(),
      expect: () => [
        WeatherState(
          weatherData: weather,
          timestamp: weather.timestamp,
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'does not emits [WeatherState] when loadCurrentWeather is called and lastest is null',
      build: () {
        when(() => weatherRepository.getLastest())
            .thenAnswer((_) async => null);
        return weatherCubit;
      },
      act: (cubit) => cubit.loadCurrentWeather(),
      expect: () => [],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState] when onLocationUpdates is called and lastest is null',
      build: () {
        when(() => weatherRepository.insert(any())).thenAnswer((_) async => {});
        when(() => weatherRepository.getLastest())
            .thenAnswer((_) async => null);
        when(() => weatherProvider.fetchWeather(any(), any()))
            .thenAnswer((_) async => weather);
        return weatherCubit;
      },
      act: (cubit) => cubit.onLocationUpdates(locationDto),
      expect: () => [
        WeatherState(
          weatherData: weather,
          timestamp: weather.timestamp,
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState] when onLocationUpdates is called and diff is greater than _minimumIntervalBetweenInsertsInMinutes',
      build: () {
        when(() => weatherRepository.insert(any())).thenAnswer((_) async => {});
        when(() => weatherRepository.getLastest())
            .thenAnswer((_) async => weather.copyWith(
                  timestamp:
                      DateTime.now().subtract(const Duration(minutes: 61)),
                ));
        when(() => weatherProvider.fetchWeather(any(), any()))
            .thenAnswer((_) async => weather);
        return weatherCubit;
      },
      act: (cubit) => cubit.onLocationUpdates(locationDto),
      expect: () => [
        WeatherState(
          weatherData: weather,
          timestamp: weather.timestamp,
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'does not emit when onLocationUpdates is called and diff is less than _minimumIntervalBetweenInsertsInMinutes',
      build: () {
        when(() => weatherRepository.getLastest())
            .thenAnswer((_) async => weather.copyWith(
                  timestamp:
                      DateTime.now().subtract(const Duration(minutes: 59)),
                ));
        return weatherCubit;
      },
      act: (cubit) => cubit.onLocationUpdates(locationDto),
      expect: () => [],
    );
  });
}
