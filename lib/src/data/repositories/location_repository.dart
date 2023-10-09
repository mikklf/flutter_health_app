import 'package:flutter_health_app/domain/interfaces/location_provider.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/models/location.dart';

class LocationRepository implements ILocationRepository {
  final ILocationProvider _locationProvider;

  LocationRepository(this._locationProvider);

  /// Inserts a new [Location] into the database 
  /// if the last entry is less than 10 minutes old.
  @override
  Future<void> insert(Location location) async {
    var result = await _locationProvider.getLastest();

    if (result == null) {
      _locationProvider.insert(location.toMap());
      return;
    }

    var entry = Location.fromMap(result);

    // If the last entry is less than 10 minutes old, don't insert
    // avoid overloading the database
    if (entry.date.difference(location.date).inMinutes < 10) {
      return;
    }

    _locationProvider.insert(location.toMap());
    
  }

  /// Returns a list of [Location] for a given day
  @override
  Future<List<Location>?> getLocationsForDay(DateTime date) async {
    var result = await _locationProvider.getLocationsForDay(date);

    if (result == null) {
      return null;
    }

    return result.map((e) => Location.fromMap(e)).toList();
  }
  
}


