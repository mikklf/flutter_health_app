import 'package:flutter_health_app/src/data/models/location.dart';

class HomeStayHelper {
  /// Calculates the percentage of time spent at home for a given day. 
  /// 
  /// [locationsForDay] is a list of locations for a given day. \
  /// [until] is the time of day until which the percentage should be calculated. 
  /// 
  /// Returns the percentage of time spent at home. \
  /// Returns null if [locationsForDay] is empty.
  static double? calculateForDayUntil(List<Location> locationsForDay, DateTime until) {
    var locations = locationsForDay
        .where((element) => element.timestamp.isBefore(until) || element.timestamp.isAtSameMomentAs(until))
        .toList();

    if (locations.isEmpty) {
      return null;
    }

    var homeStayDuration = 0;
    var lastDataPointTime =
        DateTime(until.year, until.month, until.day, 0, 0, 0, 0, 0);

    for (var location in locations) {
      if (location.isHome) {
        homeStayDuration +=
            location.timestamp.difference(lastDataPointTime).inSeconds;
      }

      lastDataPointTime = location.timestamp;
    }

    var elapsedTime = lastDataPointTime
        .difference(DateTime(until.year, until.month, until.day, 0, 0, 0, 0, 0))
        .inSeconds;

    var percentage = (homeStayDuration / elapsedTime) * 100;

    return percentage;
  }
}
