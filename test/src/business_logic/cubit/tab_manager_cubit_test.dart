import 'package:flutter_health_app/src/logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  late TabManagerCubit tabManagerCubit;

  setUp(() {
    tabManagerCubit = TabManagerCubit();
  });

  tearDown(() {
    tabManagerCubit.close();
  });

  group('TabManagerCubit', () {
    test('initial state has [selectedTab] set to 0', () {
      expect(tabManagerCubit.state, const TabManagerState(0));
    });

    blocTest<TabManagerCubit, TabManagerState>(
      'selectedTab is changed to 1 when changeTab(1) is called',
      build: () => tabManagerCubit,
      act: (cubit) => cubit.changeTab(1),
      expect: () => [const TabManagerState(1)],
    );
  });
}
