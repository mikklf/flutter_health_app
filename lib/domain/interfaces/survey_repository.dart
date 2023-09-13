import 'package:flutter_health_app/src/data/models/survey.dart';

abstract interface class ISurveyRepository {
  Future<List<Survey>> getActive();
  Future<List<Survey>> getAll();
}