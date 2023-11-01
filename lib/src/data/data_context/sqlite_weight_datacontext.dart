import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/weight_datacontext.dart';

class WeightDataContext implements IWeightDataContext {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "weights";

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
  Future<List<Map<String, dynamic>>> getWeightsInRange(
      DateTime startTime, DateTime endTime) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
    );

    return maps;
  }

  @override
  Future<List<Map<String, dynamic>>> getLastestWeights(int numOfEntries) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: "date DESC",
      limit: numOfEntries,
    );

    return maps;
  }
}
