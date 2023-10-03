import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Steps', () {
    test('can be converted to and from a map', () {
      final steps = Steps(steps: 100, date: DateTime.now());
      final stepsMap = steps.toMap();
      final newSteps = Steps.fromMap(stepsMap);

      expect(newSteps.steps, equals(steps.steps));
      expect(newSteps.date, equals(steps.date));
    });

    test('copyWith creates a new object with updated fields', () {
      final steps = Steps(steps: 100, date: DateTime.now());
      final newSteps = steps.copyWith(steps: 200);
      expect(newSteps.steps, equals(200));
      expect(newSteps.date, equals(steps.date));
    });
  });
}