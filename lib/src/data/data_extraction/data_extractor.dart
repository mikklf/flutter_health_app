import 'package:flutter_health_app/di.dart';

import 'helpers/data_extractor_helper.dart';
import 'interfaces/data_extractor.dart';
import 'interfaces/data_sender.dart';

/// Handles the extraction and transmission of data.
class DataExtractor {
  final List<IDataExtractor> _dataExtractors;

  DataExtractor(this._dataExtractors);

  /// Gets the extracted data from the registered [IDataExtractor]s.
  /// Returns a list of maps where each map represents a row of data.
  Future<List<Map<String, Object?>>> getExtractedData(DateTime startTime, DateTime endTime) async {
    
    /// Loop through all the registered data extractors and get their data
    var data = await Future.wait(_dataExtractors.map((e) => e.getData(startTime, endTime)));

    var combinedData = DataExtractorHelper.combineMapsByKey(data, 'Date');

    return combinedData;
  }

  /// Sends the extracted data to the registered [IDataSender].
  /// Returns true if the data was sent successfully.
  Future<bool> sendExtractedData(DateTime startTime, DateTime endTime) async {
    var data = await getExtractedData(startTime, endTime);

    var isSuccess = await services.get<IDataSender>().sendData(data);

    return isSuccess;

  }
}
