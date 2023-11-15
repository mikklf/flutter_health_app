import 'package:sqflite/sqflite.dart';

/// Interface for the [SqliteDatabaseHelper] class.
/// Currently is tightly coupled with the sqflite package 
/// and is only used for mocking purposes.
abstract interface class IDatabaseHelper {

  /// Returns a future [Database] object represents a connection to a SQLite database.
  Future<Database> getDatabase();
}