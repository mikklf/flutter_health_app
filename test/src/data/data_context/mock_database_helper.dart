import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Suppress warning
  databaseFactoryOrNull = null;

  // Initialize ffi implementation
  sqfliteFfiInit();

  // Set global factory for tests
  databaseFactory = databaseFactoryFfi;
}

class MockDatabaseHelper implements IDatabaseHelper {
  @override
  Future<Database> getDatabase() async {
    sqfliteTestInit();
    return openDatabase(
      ':memory:',
      onCreate: _onDatabaseCreate,
      version: 1,
    );
  }

  void _onDatabaseCreate(Database db, int version) {
    var batch = db.batch();
    batch.execute(
        "CREATE TABLE survey_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, survey_id TEXT, date TEXT, result TEXT);");
    batch.execute(
        "CREATE TABLE steps(id INTEGER PRIMARY KEY AUTOINCREMENT, steps INTEGER, date TEXT);");
    batch.execute(
        "CREATE TABLE weights(id INTEGER PRIMARY KEY AUTOINCREMENT, weight REAL, date TEXT);");
    batch.execute(
        "CREATE TABLE locations (id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, is_home INTEGER, timestamp TEXT);");
    batch.execute(
        "CREATE TABLE heart_rate (id INTEGER PRIMARY KEY AUTOINCREMENT, beats_per_minute INTEGER, timestamp TEXT);");
    batch.execute(
        "CREATE TABLE weather (id INTEGER PRIMARY KEY AUTOINCREMENT, temperature REAL, temperature_feels_like REAL, humidity REAL, cloudiness_percent INTEGER, weather_condition TEXT, weather_description TEXT, latitude REAL, longitude REAL, timestamp TEXT, sunrise TEXT, sunset TEXT);");

    batch.commit();

    return;
  }
}
