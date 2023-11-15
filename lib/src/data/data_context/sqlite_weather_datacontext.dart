import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/weather_datacontext.dart';

/// SQLite implementation of the [IWeatherDataContext].
class WeatherDataContext implements IWeatherDataContext {
  final IDatabaseHelper _databaseHelper;
  final String _tableName = "weather";

  WeatherDataContext(this._databaseHelper);

  @override
  Future<void> insert(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();
    // insert
    await db.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<Map<String, dynamic>?> getLastest() async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: "timestamp DESC",
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps.first;
  }
}
