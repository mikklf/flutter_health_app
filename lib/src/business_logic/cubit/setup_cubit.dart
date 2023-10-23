import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:research_package/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> with WidgetsBindingObserver {
  SetupCubit() : super(const SetupState()) {
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
      checkSetupStatus();
    }
  }

  checkSetupStatus() async {
    emit(state.copyWith(isLoading: true));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isConsentGiven = prefs.getBool('consentGiven') ?? false;
    bool isAddressSet = prefs.getDouble('home_longitude') != 0 &&
        prefs.getDouble('home_latitude') != 0;
    bool isLocationPermissionGranted =
        await Permission.locationAlways.isGranted;

    bool setupChecks = isConsentGiven && isAddressSet && isLocationPermissionGranted;

    if (!setupChecks) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('setupCompleted', false);
    }

    bool isSetupCompleted = prefs.getBool('setupCompleted') ?? false;

    if (isSetupCompleted) {
      emit(state.copyWith(isSetupCompleted: true));
    } else {
      emit(state.copyWith(isSetupCompleted: false));
    }

    emit(state.copyWith(isLoading: false));
  }

  completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupCompleted', true);
    emit(state.copyWith(isSetupCompleted: true));
  }

  resetSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupCompleted', false);
    emit(state.copyWith(isSetupCompleted: false));
  }

  Future<void> saveConsent(RPTaskResult result) async {
    // TODO: Save Constent
    debugPrint("Consent result: ${jsonEncode(result)}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('consentGiven', true);

    emit(state.copyWith(isConsentGiven: true));
  }

  Future<void> updateHomeAddress(String address) async {
    List<Location> locations;
    try {
      locations = await locationFromAddress(address);
    } on NoResultFoundException {
      emit(state.copyWith(homeAddress: "No location found"));
      return;
    }

    var location = locations.first;

    // Fetch address name from coordinates
    List<Placemark> placemarks;
    String addressName;
    try {
      placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      var placemark = placemarks.first;
      addressName =
          "${placemark.street}, ${placemark.postalCode} ${placemark.locality}, ${placemark.country}";
    } on NoResultFoundException {
      // If no address name is found, use coordinates
      addressName = "${location.latitude}, ${location.longitude}";
    }

    // Save coordinates to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("home_longitude", locations.first.longitude);
    prefs.setDouble("home_latitude", locations.first.latitude);

    emit(state.copyWith(
        homeAddress: addressName,
        homeLatitude: location.latitude,
        homeLongitude: location.longitude));
  }

  Future<bool> canFinshSetup() async {
    debugPrint("Can finish setup: ${state.isConsentGiven} ${state.homeLatitude} ${state.homeLongitude} ${await Permission.locationAlways.isGranted}");

    return state.isConsentGiven &&
        (state.homeLatitude != 0 && state.homeLongitude != 0) &&
        await Permission.locationAlways.isGranted;
  }
}
