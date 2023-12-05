import 'package:flutter_health_app/src/data/data_extraction/extractors/data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataDataExtractor extends Mock implements IDataExtractor {}

void main() {
  late IDataExtractor dataExtractor;
  late IDataExtractor mockExtractor1;
  late IDataExtractor mockExtractor2;

  setUp(() {
    mockExtractor1 = MockDataDataExtractor();
    mockExtractor2 = MockDataDataExtractor();
    dataExtractor = DataExtractor([mockExtractor1, mockExtractor2]);
  });

  group("DataDataExtractor", () {
    test("getData", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      when(() => mockExtractor1.getData(any(), any()))
          .thenAnswer((_) async => [
                {'Date': '2022-01-01', 'Data1': 1},
                {'Date': '2022-01-02', 'Data1': 2},
                {'Date': '2022-01-03', 'Data1': 3},
              ]);

      when(() => mockExtractor2.getData(any(), any()))
          .thenAnswer((_) async => [
                {'Date': '2022-01-01', 'Data2': 4},
                {'Date': '2022-01-02', 'Data2': 5},
                {'Date': '2022-01-03', 'Data2': 6},
              ]);

      var data = await dataExtractor.getData(startTime, endTime);

      var expected = [
        {'Date': '2022-01-01', 'Data1': 1, 'Data2': 4},
        {'Date': '2022-01-02', 'Data1': 2, 'Data2': 5},
        {'Date': '2022-01-03', 'Data1': 3, 'Data2': 6},
      ];

      expect(data, expected);
    });
  });
}
