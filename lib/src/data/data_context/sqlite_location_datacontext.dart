import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/location_datacontext.dart';

class LocationDataContext implements ILocationDataContext {
  final IDatabaseHelper _databaseHelper;
  final String _tableName = "locations";

  LocationDataContext(this._databaseHelper);

  /// Inserts a new location into the database
  @override
  Future<void> insert(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();

    await db.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Returns a list of locations for a given day
  @override
  Future<List<Map<String, dynamic>>> getLocationsForDay(DateTime date) async {
    final Database db = await _databaseHelper.getDatabase();

    var startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startOfDay.toString(), endOfDay.toString()],
    );

    return maps;
  }

  /// Returns the last entry in the database
  @override
  Future<Map<String, dynamic>?> getLastest() async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: "timestamp DESC",
      limit: 1,
    );

    return maps.firstOrNull;
  }
}