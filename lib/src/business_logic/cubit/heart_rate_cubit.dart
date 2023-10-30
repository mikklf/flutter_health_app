import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';

part 'heart_rate_state.dart';

class HeartRateCubit extends Cubit<HeartRateState> {
  final IHeartRateRepository _heartRateRepository;

  HeartRateCubit(this._heartRateRepository) : super(const HeartRateState());


  Future<void> getHeartRatesForDay() async {
    var currentTime = DateTime.now();
    var startOfDay = DateTime(currentTime.year, currentTime.month, currentTime.day);

    var heartRates = await _heartRateRepository.getHeartRatesInRange(startOfDay, currentTime);

    emit(state.copyWith(heartRateList: heartRates));
  }

}
