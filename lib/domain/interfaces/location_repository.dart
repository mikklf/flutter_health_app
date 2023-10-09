import 'package:flutter_health_app/src/data/models/location.dart';

abstract interface class ILocationRepository {
  Future<void> insert(Location location);
  Future<List<Location>?> getLocationsForDay(DateTime date);
}