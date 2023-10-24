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
      checkLocationPermission();
    }
  }

  checkLocationPermission() {
    Permission.locationAlways.status.then((status) {
      emit(state.copyWith(isLocationPermissionGranted: status.isGranted));
    });
  }

  checkConstentGiven() {
    SharedPreferences.getInstance().then((prefs) {
      emit(state.copyWith(
          isConsentGiven: prefs.getBool('consent_given') ?? false));
    });
  }

  checkHomeAddressSet() {
    SharedPreferences.getInstance().then((prefs) {
      emit(state.copyWith(homeAddress: prefs.getString('home_address') ?? ""));
    });
  }

  checkHealthPermissionStatus() {
    SharedPreferences.getInstance().then((prefs) {
      emit(state.copyWith(isHealthPermissionGranted: prefs.getBool('health_permission_given') ?? false));
    });
  }

  checkSetupStatus() async {
    emit(state.copyWith(isLoading: true));

    // Run checks, each check handles emitting state changes
    checkConstentGiven();
    checkHomeAddressSet();
    checkLocationPermission();
    checkHealthPermissionStatus();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!await canFinshSetup()) {
      prefs.setBool('setup_completed', false);
    }

    bool isSetupCompleted = prefs.getBool('setup_completed') ?? false;
    emit(state.copyWith(isSetupCompleted: isSetupCompleted));

    emit(state.copyWith(isLoading: false));
  }

  completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setup_completed', true);
    emit(state.copyWith(isSetupCompleted: true));
  }

  resetSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setup_completed', false);
    emit(state.copyWith(isSetupCompleted: false));
  }

  Future<void> saveConsent(RPTaskResult result) async {
    // TODO: Save Constent
    debugPrint("Consent result: ${jsonEncode(result)}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('consent_given', true);

    emit(state.copyWith(isConsentGiven: true));
  }

  Future<void> updateHomeAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Location> locations;
    try {
      locations = await locationFromAddress(address);
    } on NoResultFoundException {
      prefs.setDouble("home_longitude", 0);
      prefs.setDouble("home_latitude", 0);
      prefs.setString("home_address", "");
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
    prefs.setDouble("home_longitude", locations.first.longitude);
    prefs.setDouble("home_latitude", locations.first.latitude);
    prefs.setString("home_address", addressName);

    emit(state.copyWith(homeAddress: addressName));
  }

  /// Saves the health permission status to shared preferences
  /// [success] is true if the permission was granted, false otherwise
  Future<void> saveHealthPermission({bool success = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('health_permission_given', success);
    emit(state.copyWith(isHealthPermissionGranted: success));
  }

  Future<bool> canFinshSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConsentGiven = prefs.getBool('consent_given') ?? false;

    bool isAddressSet = prefs.getDouble('home_longitude') != 0 &&
        prefs.getDouble('home_latitude') != 0;

    bool isLocationPermissionGranted =
        await Permission.locationAlways.isGranted;

    bool isHealthPermissionGranted = prefs.getBool('health_permission_given') ?? false;

    return isConsentGiven && isAddressSet && isLocationPermissionGranted && isHealthPermissionGranted;
  }
}
