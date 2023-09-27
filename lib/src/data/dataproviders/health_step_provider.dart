import 'package:flutter_health_app/domain/interfaces/step_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'helpers/sqlite_database_helper.dart';

class HealthStepProvider implements IStepProvider {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "steps";

  @override
  Future<void> insert(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();

    await db.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<void> update(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();

    // Ensure that we have an id field
    if (!values.containsKey("id")) {
      throw ArgumentError("Values must contain an id field");
    }

    await db.update(_tableName, values, where: "id = ?", whereArgs: [values["id"]]);
  }

  @override
  Future<Map<String, dynamic>?> getStepsForDay(DateTime date) async {
    final Database db = await _databaseHelper.getDatabase();

    //  Alternative:
    //  DateTime dt = DateTime.now();
    //  final result = '${dt.year}-${dt.month}-${dt.day}';
    //  print(result);
    //  result = 2023-09-27 

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

    return maps.first;
  }

  /// Returns the total number of steps between [startTime] and [endTime]. Returns 0 if no steps are found.
  @override
  Future<int> getSteps(DateTime startTime, DateTime endTime) async {
    // TODO: implement getSteps
    throw UnimplementedError();
  }
}

