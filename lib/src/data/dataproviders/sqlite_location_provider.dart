import 'package:flutter_health_app/domain/interfaces/location_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'helpers/sqlite_database_helper.dart';

class SqliteLocationProvider implements ILocationProvider {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "locations";

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

  /// Updates a location in the database
  @override
  Future<void> update(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();

    // Ensure that we have an id field
    if (!values.containsKey("id")) {
      throw ArgumentError("Values must contain an id field");
    }

    await db
        .update(_tableName, values, where: "id = ?", whereArgs: [values["id"]]);
  }

  /// Returns a list of locations for a given day
  @override
  Future<List<Map<String, dynamic>>?> getLocationsForDay(DateTime date) async {
    final Database db = await _databaseHelper.getDatabase();

    var startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [startOfDay.toString(), endOfDay.toString()],
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps;
  }

  /// Returns the last entry in the database
  @override
  Future<Map<String, dynamic>?> getLastest() async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: "id DESC",
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps.first;
  }
}