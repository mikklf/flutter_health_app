import 'helpers/data_extractor_helper.dart';
import 'interfaces/data_extractor.dart';

/// Executes all the registered [IDataExtractor]s and 
/// combines their data into a single list of maps.
/// [IDataExtractor]s are registered in the DI container.
class DataExtractor implements IDataExtractor {
  final List<IDataExtractor> _preprocessors;

  DataExtractor(this._preprocessors);

  @override
  Future<List<Map<String, Object?>>> getData(DateTime startTime, DateTime endTime) async {
    
    /// Loop through all the registered preprocessors and get their data
    var data = await Future.wait(_preprocessors.map((e) => e.getData(startTime, endTime)));

    var combinedData = DataExtractorHelper.combineMapsByKey(data, 'Date');

    return combinedData;
  }
}
