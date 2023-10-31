import 'package:flutter_health_app/src/data/models/location.dart';

abstract interface class ILocationRepository {
  Future<bool> insert(Location location);
  Future<List<Location>> getLocationsForDay(DateTime date);
}