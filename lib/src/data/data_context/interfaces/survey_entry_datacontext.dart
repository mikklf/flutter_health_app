abstract interface class ISurveyEntryDataContext {
  /// Inserts the given map of values representing a survey entry into the database.
  Future<void> insert(Map<String, Object?> values);

  /// Returns a map representing the last entry of the given survey type.
  /// Returns null if no entry is found.
  Future<Map<String, dynamic>?> getLastEntryOfType(final String surveyId);
}