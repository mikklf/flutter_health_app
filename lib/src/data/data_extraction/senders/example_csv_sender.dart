import 'package:flutter_health_app/src/data/data_extraction/helpers/data_extractor_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_sender.dart';
import 'package:http/http.dart' as http;

/// Example implementation of [IDataSender] that sends to a simple Flask server
/// running on localhost that preprocesses the data and stores it locally.
/// See the server code in the `python` folder in the root of the project.
class ExampleCsvSender implements IDataSender {
  @override
  Future<bool> sendData(List<Map<String, Object?>> data) async {
    var csv = DataExtractorHelper.toCsv(data);

    // Change this to the IP address of the external services.
    // If using an emulator, you must use a special IP address to access the host machine.
    // For Android emulators, see https://developer.android.com/studio/run/emulator-networking
    // or https://stackoverflow.com/questions/5528850/how-do-you-connect-localhost-in-the-android-emulator
    var url = "http://10.0.2.2:5000";

    var response = await http.post(Uri.parse(url), body: csv, headers: {
      "Content-Type": "text/csv",
    });

    return response.statusCode == 200;
  }
}
