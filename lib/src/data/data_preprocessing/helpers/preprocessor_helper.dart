class PreprocessorHelper {
  /// Converts a list of maps to a CSV string
  static String toCsv(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return '';
    }

    final Set<String> allKeys = {};

    // Iterate through each map and add its keys to the set
    for (final map in data) {
      allKeys.addAll(map.keys);
    }

    final headers = allKeys.toList();

    final csvData = [];

    // Add the headers to the CSV data
    csvData.add(headers.join(','));

    // Add the data
    for (final row in data) {
      final values = headers.map((header) => row[header]).toList();
      csvData.add(values.join(','));
    }

    return csvData.join('\n');
  }

  /// Combines a list of maps by a given key and returns a sorted list of the combined maps.
  ///
  /// The method takes in a list of lists of maps and a string representing the key to combine the maps by.
  /// It then combines the maps by the given key and returns a sorted list of the combined maps.
  static List<Map<String, Object?>> combineMapsByKey(
      List<List<Map<String, Object?>>> mapsList, String mapKey) {
    // Combine the maps
    var combinedMaps = <String, Map<String, Object?>>{};
    for (var maps in mapsList) {
      for (var map in maps) {
        if (!map.containsKey(mapKey)) {
          throw ArgumentError('mapKey $mapKey not found in map $map');
        }
        var key = map[mapKey] as String;
        combinedMaps.putIfAbsent(key, () => {}).addAll(map);
      }
    }

    var combinedList = combinedMaps.values.toList();

    combinedList
        .sort((a, b) => a[mapKey].toString().compareTo(b[mapKey].toString()));

    return combinedList;
  }
}
