import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseHelper {
  final String _databaseName = "health_app_database.db";

  Future<Database> getDatabase() async {
    return openDatabase(
      await _getSqliteDatabasePath(),
      onCreate: _onDatabaseCreate,
      version: 2,
    );
  }

  void _onDatabaseCreate(Database db, int version) {
    debugPrint("Creating database");
    var batch = db.batch();
    batch.execute(
        "CREATE TABLE IF NOT EXISTS survey_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, survey_id TEXT, date TEXT, result TEXT);");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS steps(id INTEGER PRIMARY KEY AUTOINCREMENT, steps INTEGER, date TEXT);");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS weights(id INTEGER PRIMARY KEY AUTOINCREMENT, weight REAL, date TEXT);");
    batch.execute(
      "CREATE TABLE IF NOT EXISTS location (id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, date TEXT);");
    batch.commit();

    return;
  }

  Future<String> _getSqliteDatabasePath() async {
    return join(await getDatabasesPath(), _databaseName);
  }
}
