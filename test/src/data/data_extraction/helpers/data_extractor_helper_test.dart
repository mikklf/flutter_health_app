import 'package:flutter_health_app/src/data/data_extraction/helpers/data_extractor_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    // Setup code
  });

  group('DataExtractorHelper', () {
    test("toCsv should return empty string for empty data", () {
      expect(DataExtractorHelper.toCsv([]), '');
    });

    test("toCsv - Single row", () {
      var data = [
        {'name': 'John', 'age': 30}
      ];
      var expected = 'name,age\nJohn,30';
      expect(DataExtractorHelper.toCsv(data), expected);
    });

    test("toCsv - Multiple rows", () {
      var data = [
        {'name': 'John', 'age': 30, 'weight': 80},
        {'name': 'Jane', 'age': 25}
      ];
      var expected = 'name,age,weight\nJohn,30,80\nJane,25,null';
      expect(DataExtractorHelper.toCsv(data), expected);
    });

    test("combineMapsByKey should return empty list for empty input", () {
      expect(DataExtractorHelper.combineMapsByKey([], "date"), isEmpty);
    });

    test(
        "combineMapsByKey throws ArgumentError if mapKey is not found in every map",
        () {
      var mapsList = [
        [
          {'date': '2022-01-01', 'value1': 1},
          {'date': '2022-01-02', 'value1': 2},
        ],
        [
          {'date': '2022-01-01', 'value2': 3},
          {'date': '2022-01-03', 'value2': 4},
        ],
      ];
      expect(() => DataExtractorHelper.combineMapsByKey(mapsList, ""),
          throwsA(isA<ArgumentError>()));
    });

    test("combineMapsByKey returns correct combined list", () {
      var mapsList = [
        [
          {'date': '2022-01-01', 'value1': 1},
          {'date': '2022-01-02', 'value1': 2},
        ],
        [
          {'date': '2022-01-01', 'value2': 3},
          {'date': '2022-01-03', 'value2': 4},
        ],
      ];

      var expected = [
        {'date': '2022-01-01', 'value1': 1, 'value2': 3},
        {'date': '2022-01-02', 'value1': 2},
        {'date': '2022-01-03', 'value2': 4},
      ];
      expect(DataExtractorHelper.combineMapsByKey(mapsList, "date"), expected);
    });
  });
}
