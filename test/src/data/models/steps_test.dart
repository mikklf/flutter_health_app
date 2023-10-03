import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Steps', () {
    test('supports value equality', () {
      final steps1 = Steps(steps: 100, date: DateTime.now(), id: 1);
      final steps2 = Steps(steps: 100, date: DateTime.now(), id: 1);
      final steps3 = Steps(steps: 200, date: DateTime.now(), id: 2);
      expect(steps1, equals(steps2));
      expect(steps1 == steps3, isFalse);
    });

    test('can be converted to and from a map', () {
      final steps = Steps(steps: 100, date: DateTime.now());
      final stepsMap = steps.toMap();
      final newSteps = Steps.fromMap(stepsMap);
      expect(newSteps, equals(steps));
    });

    test('copyWith creates a new object with updated fields', () {
      final steps = Steps(steps: 100, date: DateTime.now());
      final newSteps = steps.copyWith(steps: 200);
      expect(newSteps.steps, equals(200));
      expect(newSteps.date, equals(steps.date));
    });
  });
}