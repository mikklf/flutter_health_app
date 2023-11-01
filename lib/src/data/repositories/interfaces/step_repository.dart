import 'package:flutter_health_app/src/data/models/steps.dart';

abstract interface class IStepRepository {
  Future<void> updateStepsForDay(DateTime date, int steps);
  Future<List<Steps>> getStepsInRange(DateTime startDate, DateTime endDate);
  Future<void> syncSteps(DateTime startDate);
}
