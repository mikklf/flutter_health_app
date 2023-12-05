abstract interface class IDataSender {
  /// Sends [data] to an external service.
  /// returns true if the data was sent successfully.
  /// Otherwise returns false.
  Future<bool> sendData(List<Map<String, Object?>> data);
}