import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:sqflite/sqflite.dart';

import 'helpers/sqlite_database_helper.dart';

class SurveyEntryProvider implements ISurveyEntryProvider {
  final SqliteDatabaseHelper _databaseHelper = SqliteDatabaseHelper();
  final String _tableName = "survey_entries";

  @override
  Future<void> insert(final SurveyEntry newSurvey) async {
    final Database db = await _databaseHelper.getDatabase();
    
    await db.insert(
      _tableName,
      newSurvey.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<SurveyEntry?> getLastEntryOfType(final String surveyId) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "survey_id = ?",
      whereArgs: [surveyId],
      orderBy: "id DESC",
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return SurveyEntry.fromMap(maps.first);
  }
}

abstract class ISurveyEntryProvider {
  Future<void> insert(final SurveyEntry newSurvey);
  Future<SurveyEntry?> getLastEntryOfType(final String surveyId);
}