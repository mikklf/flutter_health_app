import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/weather_preprocessor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataPreprocessor weatherPreprocessor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    weatherPreprocessor = WeatherPreprocessor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("WeatherPreprocessor", () {
    test("getPreprocessedData with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      var data =
          await weatherPreprocessor.getPreprocessedData(startTime, endTime);
      expect(data, isEmpty);
    });

    test("getPreprocessedData with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      db.insert('weather', {
        'temperature': 20,
        'temperature_feels_like': 19,
        'humidity': 56,
        'cloudiness_percent': 0,
        'weather_condition': "Clear",
        'weather_description': "clear sky",
        'latitude': 0,
        'longitude': 0,
        'timestamp': "2022-01-01 04:28:20.432647",
        'sunrise': "2022-01-01 04:28:20.432647",
        'sunset': "2022-01-01 18:28:20.432647"
      });
      db.insert('weather', {
        'temperature': 22,
        'temperature_feels_like': 22,
        'humidity': 53,
        'cloudiness_percent': 2,
        'weather_condition': "Clear",
        'weather_description': "clear sky",
        'latitude': 0,
        'longitude': 0,
        'timestamp': "2022-01-01 10:28:20.432647",
        'sunrise': "2022-01-01 04:28:20.432647",
        'sunset': "2022-01-01 18:28:20.432647"
      });
      db.insert('weather', {
        'temperature': 10,
        'temperature_feels_like': 7,
        'humidity': 43,
        'cloudiness_percent': 53,
        'weather_condition': "Rain",
        'weather_description': "moderate rain",
        'latitude': 0,
        'longitude': 0,
        'timestamp': "2022-01-02 04:28:20.432647",
        'sunrise': "2022-01-02 04:28:20.432647",
        'sunset': "2022-01-02 18:28:20.432647"
      });
      db.insert('weather', {
        'temperature': 7,
        'temperature_feels_like': 5,
        'humidity': 50,
        'cloudiness_percent': 55,
        'weather_condition': "Rain",
        'weather_description': "moderate rain",
        'latitude': 0,
        'longitude': 0,
        'timestamp': "2022-01-02 10:28:20.432647",
        'sunrise': "2022-01-02 04:28:20.432647",
        'sunset': "2022-01-02 18:28:20.432647"
      });

      var data =
          await weatherPreprocessor.getPreprocessedData(startTime, endTime);

      var expectedData = [
        {
          'Date': '2022-01-01',
          'AverageTemperature': 21,
          'CloudinessPercent': 1.0,
          'DaylightTimeInHours': 14.0,
          'IsRaining': 0,
          'IsSnowing': 0
        },
        {
          'Date': '2022-01-02',
          'AverageTemperature': 8.5,
          'CloudinessPercent': 54.0,
          'DaylightTimeInHours': 14.0,
          'IsRaining': 1,
          'IsSnowing': 0
        }
      ];

      expect(data, expectedData);
    });
  });
}
