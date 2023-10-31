import 'package:flutter_health_app/domain/interfaces/location_provider.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/models/location.dart';

class LocationRepository implements ILocationRepository {
  final ILocationProvider _locationProvider;

  final int _minimumIntervalBetweenInsertsInMinutes = 10;

  LocationRepository(this._locationProvider);

  /// Inserts a new [Location] into the database. If the last entry is less than 10 minutes old.
  /// Returns true if the location was inserted, false otherwise.
  @override
  Future<bool> insert(Location location) async {
    var result = await _locationProvider.getLastest();

    if (result == null) {
      _locationProvider.insert(location.toMap());
      return true;
    }

    var entry = Location.fromMap(result);

    // If the last entry is less than 10 minutes old, don't insert
    // to avoid overloading the database
    if (location.date.difference(entry.date).inMinutes <
        _minimumIntervalBetweenInsertsInMinutes) {
      return false;
    }

    _locationProvider.insert(location.toMap());

    return true;
  }

  /// Returns a list of [Location] for a given day
  @override
  Future<List<Location>> getLocationsForDay(DateTime date) async {
    var result = await _locationProvider.getLocationsForDay(date);

    if (result == null) {
      return [];
    }

    return result.map((e) => Location.fromMap(e)).toList();
  }
}
