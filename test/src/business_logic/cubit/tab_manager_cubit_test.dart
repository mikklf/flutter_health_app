import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('TabManagerCubit', () {
    late TabManagerCubit tabManagerCubit;

    setUp(() {
      tabManagerCubit = TabManagerCubit();
    });

    tearDown(() {
      tabManagerCubit.close();
    });

    test('initial state has [selectedTab] set to 0', () {
      expect(tabManagerCubit.state, const TabManagerInitial(0));
    });

    blocTest<TabManagerCubit, TabManagerState>(
      'selectedTab is changed to 1 when changeTab is called',
      build: () => tabManagerCubit,
      act: (cubit) => cubit.changeTab(1),
      expect: () => [const TabManagerInitial(1)],
    );
  });
}