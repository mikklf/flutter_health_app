abstract interface class IDataPreprocessor {
  
  Future<List<Map<String, Object?>>> getPreprocessedData();

}