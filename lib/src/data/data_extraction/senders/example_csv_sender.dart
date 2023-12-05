import 'package:flutter_health_app/src/data/data_extraction/helpers/data_extractor_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_sender.dart';
import 'package:http/http.dart' as http;

/// Example implementation of [IDataSender] that sends to a simple Flask server
/// running on localhost that preprocesses the data and stores it locally.
class ExampleSender implements IDataSender {
  @override
  Future<bool> sendData(List<Map<String, Object?>> data) async {
    var csv = DataExtractorHelper.toCsv(data);

    var url = "http://10.0.2.2:5000";

    var response = await http.post(Uri.parse(url), body: csv, headers: {
      "Content-Type": "text/csv",
    });

    return response.statusCode == 200;
  }
}
