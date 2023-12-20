import 'package:flutter_health_app/src/data/data_extraction/data_extraction_controller.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_sender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataExtractor extends Mock implements IDataExtractor {}
class MockSender extends Mock implements IDataSender {}

void main() {
  late DataExtractionController dataExtractor;
  late IDataExtractor mockExtractor1;
  late IDataExtractor mockExtractor2;

  setUp(() {
    mockExtractor1 = MockDataExtractor();
    mockExtractor2 = MockDataExtractor();
    dataExtractor = DataExtractionController([mockExtractor1, mockExtractor2], MockSender());
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

      var data = await dataExtractor.getExtractedData(startTime, endTime);

      var expected = [
        {'Date': '2022-01-01', 'Data1': 1, 'Data2': 4},
        {'Date': '2022-01-02', 'Data1': 2, 'Data2': 5},
        {'Date': '2022-01-03', 'Data1': 3, 'Data2': 6},
      ];

      expect(data, expected);
    });
  });
}
