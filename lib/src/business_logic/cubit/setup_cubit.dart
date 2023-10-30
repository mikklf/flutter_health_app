import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
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
    if (state == AppLifecycleState.resumed) {
      checkLocationPermission();
    }
  }

  checkLocationPermission() async {
    var status = await Permission.locationAlways.status;
    emit(state.copyWith(isLocationPermissionGranted: status.isGranted));
  }

  checkConstentGiven() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('consent_given') ?? false;
    emit(state.copyWith(isConsentGiven: status));
  }

  checkHomeAddressSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = prefs.getString('home_address') ?? "";
    emit(state.copyWith(homeAddress: address));
  }

  checkHealthPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('health_permission_given') ?? false;
    emit(state.copyWith(isHealthPermissionGranted: status));
  }

  checkSetupStatus() async {
    emit(state.copyWith(isLoading: true));

    // Run checks, each check handles emitting state changes
    await checkConstentGiven();
    await checkHomeAddressSet();
    await checkLocationPermission();
    await checkHealthPermissionStatus();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!state.canFinishSetup) {
      prefs.setBool('setup_completed', false);
    }

    bool isSetupCompleted = prefs.getBool('setup_completed') ?? false;

    emit(state.copyWith(isSetupCompleted: isSetupCompleted, isLoading: false));
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
    // TODO: Consider how to save the consent result.
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

  Future<void> requestLocationPermissions() async {
    // NOTE: This is a basic implementation of the location permission request.
    // It works but does not provide a good user experience.
    var status = await Permission.location.status;

    await Permission.location.request();

    if (status.isPermanentlyDenied) {
      emit(state.copyWith(
          snackbarMessage:
              "Location permission is required to use the app effectively. Please enable it in your phone settings."));
      return;
    }

    // Check if we can request locationAlways permission
    var alwaysStatus = await Permission.locationAlways.status;
    if (alwaysStatus.isDenied) {
      await Permission.locationAlways.request();
    }

    alwaysStatus = await Permission.locationAlways.status;
    if (alwaysStatus.isDenied || alwaysStatus.isPermanentlyDenied) {
      emit(state.copyWith(
          snackbarMessage:
              "Always access to location is required to use the app effectively. Please enable it in your phone settings."));
    }
  }

  Future<void> requestHealthPermissions() async {
    // NOTE: This is a minimal implementation of the health permission request.
    // It works but does not provide a good user experience.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var success = await services.get<IHealthProvider>().requestAuthorization();

    if (!success) {
      await prefs.setBool('health_permission_given', false);
      emit(state.copyWith(
          isHealthPermissionGranted: false,
          snackbarMessage:
              "Could not get health permissions. Access to health data is required to use the app effectively."));
      return;
    }

    await prefs.setBool('health_permission_given', true);
    emit(state.copyWith(
        isHealthPermissionGranted: true,
        snackbarMessage: "Health permissions granted."));
  }
}
