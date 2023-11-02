import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStepRepository extends Mock implements IStepRepository {}
class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

void main() {
  late MockStepRepository mockStepRepository;
  late MockHeartRateRepository mockHeartRateRepository;
  late SyncCubit syncCubit;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockStepRepository = MockStepRepository();
    mockHeartRateRepository = MockHeartRateRepository();
    syncCubit = SyncCubit(mockStepRepository, mockHeartRateRepository);
  });

  tearDown(() {
    syncCubit.close();
  });

  group("SyncCubit", () {
    test('initial state is SyncState where isSyncing is false', () {
      expect(syncCubit.state, const SyncState(isSyncing: false));
    });

    blocTest(
        '(if lastSyncTime == null) syncAll changes state from isSyncing false to true to false',
        build: () {
          when(() => mockStepRepository.syncSteps(any()))
              .thenAnswer((_) => Future.value());
          when(() => mockHeartRateRepository.syncHeartRates(any()))
              .thenAnswer((_) => Future.value());
          SharedPreferences.setMockInitialValues(<String, Object>{});
          return syncCubit;
        },
        act: (bloc) => bloc.syncAll(),
        expect: () => [
              const SyncState(isSyncing: true),
              const SyncState(isSyncing: false)
            ],
        verify: (_) {
          verify(() => mockStepRepository.syncSteps(any())).called(1);
        });

    blocTest(
        '(if lastSyncTime != null) syncAll changes state from isSyncing false to true to false',
        build: () {
          when(() => mockStepRepository.syncSteps(any()))
              .thenAnswer((_) => Future.value());
          when(() => mockHeartRateRepository.syncHeartRates(any()))
              .thenAnswer((_) => Future.value());
          SharedPreferences.setMockInitialValues(<String, Object>{
            'lastSyncStepsDateTime': DateTime(0).toString()
          });
          return syncCubit;
        },
        act: (bloc) => bloc.syncAll(),
        expect: () => [
              const SyncState(isSyncing: true),
              const SyncState(isSyncing: false)
            ],
        verify: (_) {
          verify(() => mockStepRepository.syncSteps(any())).called(1);
        });
  });
}
