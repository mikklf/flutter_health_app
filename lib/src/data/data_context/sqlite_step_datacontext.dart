import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/step_datacontext.dart';

/// SQLite implementation of the [IStepDataContext].
class StepDataContext implements IStepDataContext {
  final IDatabaseHelper _databaseHelper;
  final String _tableName = "steps";

  StepDataContext(this._databaseHelper);

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

    await db
        .update(_tableName, values, where: "id = ?", whereArgs: [values["id"]]);
  }

  @override
  Future<Map<String, dynamic>?> getStepsForDay(DateTime date) async {
    final Database db = await _databaseHelper.getDatabase();

    var startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [startOfDay.toString(), endOfDay.toString()],
      limit: 1,
    );

    return maps.firstOrNull;
  }

  @override
  Future<List<Map<String, dynamic>>> getSteps(
      DateTime startTime, DateTime endTime) async {
    final Database db = await _databaseHelper.getDatabase();

    var start = 
      DateTime(startTime.year, startTime.month, startTime.day, 0, 0, 0);
    var end = DateTime(endTime.year, endTime.month, endTime.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [start.toString(), end.toString()],
    );
    
    return maps;
  }
}
