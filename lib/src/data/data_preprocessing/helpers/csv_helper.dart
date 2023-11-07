class CsvHelper {
  static String toCsv(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return '';
    }

    // Get headers
    final headers = data.first.keys;

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
}
