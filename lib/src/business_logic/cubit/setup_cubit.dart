import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  SetupCubit() : super(const SetupState());
  
  checkSetupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSetupCompleted = prefs.getBool('setupCompleted') ?? false;

    if (isSetupCompleted) {
      emit(state.copyWith(isSetupCompleted: true));
    } else {
      emit(state.copyWith(isSetupCompleted: false));
    }
  }

  completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupCompleted', true);
    emit(state.copyWith(isSetupCompleted: true));
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
}
