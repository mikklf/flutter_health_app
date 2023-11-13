abstract interface class IDataPreprocessor {
  /// Preprocesses the data and returns a list of maps with the preprocessed data.
  Future<List<Map<String, Object?>>> getPreprocessedData();
}