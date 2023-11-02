import 'package:flutter_health_app/src/data/models/location.dart';

abstract interface class ILocationRepository {
  /// Inserts a new [Location] into the database. 
  /// If the last entry is older then the set threshold.
  /// Returns true if the location was inserted, false otherwise.
  Future<bool> insert(Location location);

  /// Returns a list of [Location] for a given day.
  /// Returns an empty list if no locations are found.
  Future<List<Location>> getLocationsForDay(DateTime date);
}