import 'helpers/preprocessor_helper.dart';
import 'interfaces/data_preprocessor.dart';

/// Executes all the registered [IDataPreprocessor]s and 
/// combines their data into a single list of maps.
/// [IDataPreprocessor]s are registered in the DI container.
class DataPreprocessor implements IDataPreprocessor {
  final List<IDataPreprocessor> _preprocessors;

  DataPreprocessor(this._preprocessors);

  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
    
    /// Loop through all the registered preprocessors and get their data
    var data = await Future.wait(_preprocessors.map((e) => e.getPreprocessedData()));

    var combinedData = PreprocessorHelper.combineMapsByKey(data, 'Date');

    return combinedData;
  }
}
