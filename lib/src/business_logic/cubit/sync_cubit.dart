import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> with WidgetsBindingObserver {
  final IStepRepository _stepRepository;
  final IHeartRateRepository _heartRateRepository;

  SyncCubit(this._stepRepository, this._heartRateRepository) : super(const SyncState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Ensures that data is synced every time the app is opened
    // regardless of the state of the app
    if (state == AppLifecycleState.resumed) {
      syncAll();
    }
  }

  /// Syncs all data with backend
  Future<void> syncAll() async {
    emit(state.copyWith(isSyncing: true));
   
    // Register all sync functions here
    await syncSteps();
    await syncHeartRates();

    emit(state.copyWith(isSyncing: false));
  }

  /// Syncs steps with backend
  Future<void> syncSteps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? lastSyncTime = prefs.getString('lastSyncStepsDateTime');

    if (lastSyncTime == null) {
      await _stepRepository.syncSteps(DateTime.now());
    } else {
      await _stepRepository.syncSteps(DateTime.parse(lastSyncTime));
    }

    prefs.setString('lastSyncStepsDateTime', DateTime.now().toString());
  }

  Future<void> syncHeartRates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? lastSyncTime = prefs.getString('lastSyncHeartRateDateTime');

    if (lastSyncTime == null) {
      await _heartRateRepository.syncHeartRates(DateTime.now().subtract(const Duration(seconds: 10)));
    } else {
      await _heartRateRepository.syncHeartRates(DateTime.parse(lastSyncTime));
    }

    prefs.setString('lastSyncHeartRateDateTime', DateTime.now().toString());
  }

}
