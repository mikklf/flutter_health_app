import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/heart_rate_datacontext.dart';

class HeartRateDataContext implements IHeartRateDataContext {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "heart_rate";

  @override
  Future<List<Map<String, dynamic>>?> getHeartRatesInRange(
      DateTime startTime, DateTime endTime) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      orderBy: "timestamp ASC",
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps;
  }

  @override
  Future<void> insert(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();

    await db.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
