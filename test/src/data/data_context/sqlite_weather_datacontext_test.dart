import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_weather_datacontext.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'mock_database_helper.dart';

void main() {

  group('SQLite Weather DataContext', () {
  late IDatabaseHelper databaseHelper;
  late WeatherDataContext weatherDataContext;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    weatherDataContext = WeatherDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

    test('Inserts and retrieves weather data', () async {
      final weatherData = {
        'temperature': 25.0,
        'humidity': 50.0,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await weatherDataContext.insert(weatherData);

      final latestWeatherData = await weatherDataContext.getLastest();

      expect(latestWeatherData, isNotNull);
      expect(latestWeatherData!['temperature'], equals(25.0));
      expect(latestWeatherData['humidity'], equals(50.0));
    });

    test('Returns null when no weather data is available', () async {
      final latestWeatherData = await weatherDataContext.getLastest();

      expect(latestWeatherData, isNull);
    });
  });
}