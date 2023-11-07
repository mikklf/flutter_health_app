import 'package:flutter_health_app/src/data/models/location.dart';

class HomeStayHelper {
  /// Calculates the percentage of time spent at home for a range of [locations]. 
  /// Returns the percentage of time spent at home or throws an [ArgumentError] if the list is empty.
  static double calculateHomestay(List<Location> locations) {
    if (locations.isEmpty) {
      throw ArgumentError("locations cannot be empty");
    }

    // Sort the locations by timestamp on a copy of the list
    var sortedLocations = List.from(locations);
    sortedLocations.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var startOfDay = DateTime(sortedLocations.first.timestamp.year, sortedLocations.first.timestamp.month, sortedLocations.first.timestamp.day);
    var lastEntry = sortedLocations.last;


    var homeStayDuration = 0;
    var lastDataPointTime = startOfDay;

    for (var location in locations) {
      if (location.isHome) {
        homeStayDuration +=
            location.timestamp.difference(lastDataPointTime).inSeconds;
      }

      lastDataPointTime = location.timestamp;
    }

    var elapsedTime = lastEntry.timestamp.difference(startOfDay).inSeconds;

    var percentage = (homeStayDuration / elapsedTime) * 100;

    return percentage;
  }
}
