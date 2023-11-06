import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';

import '../data_context/interfaces/location_datacontext.dart';

class LocationRepository implements ILocationRepository {
  final ILocationDataContext _locationContext;

  LocationRepository(this._locationContext);

  @override
  Future<Location?> getLastest() async {
    var result = await _locationContext.getLastest();

    if (result == null) {
      return null;
    }

    return Location.fromMap(result);
  }

  @override
  Future<void> insert(Location location) async {
    _locationContext.insert(location.toMap());
  }

  @override
  Future<List<Location>> getLocationsForDay(DateTime date) async {
    var result = await _locationContext.getLocationsForDay(date);

    return result.map((e) => Location.fromMap(e)).toList();
  }
}
