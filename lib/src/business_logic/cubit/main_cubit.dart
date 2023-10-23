import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(InitialMainState());

  initializeMainState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSetupCompleted = prefs.getBool('setupCompleted') ?? false;

    if (isSetupCompleted) {
      emit(SetupCompletedState());
    } else {
      emit(SetupRequiredState());
    }
  }

  completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupCompleted', true);
    emit(SetupCompletedState());
  }

  resetSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupCompleted', false);
    emit(SetupRequiredState());
  }
}
