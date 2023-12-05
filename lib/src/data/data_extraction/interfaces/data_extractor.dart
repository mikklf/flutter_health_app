abstract interface class IDataExtractor {
  /// Preprocesses the data between [startTime] and [endTime]
  /// and returns a list of maps with the preprocessed data.
  /// 
  /// The maps should have the following format: \
  /// {                        \
  ///  'Date': value,          \
  ///  'DataPoint1': value,    \
  ///  'DataPoint2': value,    \
  ///   ...                    \
  ///   'DataPointN': value,   \
  /// }
  Future<List<Map<String, Object?>>> getData(DateTime startTime, DateTime endTime);
}