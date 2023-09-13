import 'package:flutter_health_app/src/data/models/survey.dart';

abstract interface class ISurveyProvider {
  Future<Survey> getById(String id);
  Future<List<Survey>> getAll();
}