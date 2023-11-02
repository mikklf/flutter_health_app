import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/heart_rate_datacontext.dart';

class HeartRateDataContext implements IHeartRateDataContext {
  final IDatabaseHelper _databaseHelper;
  final String _tableName = "heart_rate";

  HeartRateDataContext(this._databaseHelper);

  @override
  Future<List<Map<String, dynamic>>> getHeartRatesInRange(
      DateTime startTime, DateTime endTime) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      orderBy: "timestamp ASC",
    );

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
