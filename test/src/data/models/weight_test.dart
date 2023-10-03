import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Weight', () {
    test('supports value equality', () {
      final weight1 = Weight(weight: 70.0, date: DateTime.now(), id: 1);
      final weight2 = Weight(weight: 70.0, date: DateTime.now(), id: 1);

      expect(weight1, equals(weight2));
    });

    test('can be copied with new values', () {
      final weight1 = Weight(weight: 70.0, date: DateTime.now(), id: 1);
      final weight2 = weight1.copyWith(weight: 75.0);

      expect(weight1.weight, equals(70.0));
      expect(weight2.weight, equals(75.0));
    });

    test('can be converted to and from a map', () {
      final weight = Weight(weight: 70.0, date: DateTime.now(), id: 1);
      final map = weight.toMap();
      final fromMap = Weight.fromMap(map);

      expect(fromMap, equals(weight));
    });
  });
}