abstract interface class ISurveyEntryDataContext {
  Future<void> insert(Map<String, Object?> values);
  Future<Map<String, dynamic>?> getLastEntryOfType(final String surveyId);
}