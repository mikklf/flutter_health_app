import 'package:flutter_health_app/domain/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/data/dataproviders/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:sqflite/sqflite.dart';

class WeightRepository implements IWeightRepository {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "weights";

  /// Inserts or updates the weight for the given date
  @override
  Future<void> updateWeight(DateTime date, double weight) async {
    final Database db = await _databaseHelper.getDatabase();

    var weightEntry = await getWeight(date);

    if (weightEntry == null) {
      await db.insert(
        _tableName,
        Weight(weight: weight, date: date).toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return;
    }

    var updatedEntry = weightEntry.copyWith(weight: weight);

    await db.update(_tableName, updatedEntry.toMap(),
        where: "id = ?", whereArgs: [updatedEntry.id]);
  }

  /// Gets the weight for the given date. Returns null if no weight is found
  @override
  Future<Weight?> getWeight(DateTime date) async {
    final Database db = await _databaseHelper.getDatabase();

    // Check if we have weight for this date
    var startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [startOfDay.toString(), endOfDay.toString()],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return Weight.fromMap(maps.first);
  }

  /// Gets the weight for the given date range.
  /// Returns an empty list if no weight is found
  @override
  Future<List<Weight>> getWeights(DateTime startDate, DateTime endDate) async {
    final Database db = await _databaseHelper.getDatabase();

    var start = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    var end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "date BETWEEN ? AND ?",
      whereArgs: [start.toString(), end.toString()],
    );

    if (maps.isEmpty) return [];

    return maps.map((e) => Weight.fromMap(e)).toList();

  }

  /// Get the latest weight entries. Returns an empty list if no weight is found
  @override
  Future<List<Weight>> getLatestWeights(int numOfEntries) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: "date DESC",
      limit: numOfEntries,
    );

    if (maps.isEmpty) return [];

    return maps.map((e) => Weight.fromMap(e)).toList();
  }


}
