part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final String homeAddress;
  final bool isConsentGiven;
  final bool isLocationPermissionGranted;
  final bool isHealthPermissionGranted;

  final bool isSetupCompleted;

  final bool isLoading;

  /// Returns true if all setup tasks are completed
  bool get canFinishSetup =>
      isConsentGiven &&
      (homeAddress.isNotEmpty &&
      homeAddress != "No location found") &&
      isLocationPermissionGranted &&
      isHealthPermissionGranted;

  const SetupState({
    this.homeAddress = "",
    this.isSetupCompleted = false,
    this.isConsentGiven = false,
    this.isLocationPermissionGranted = false,
    this.isHealthPermissionGranted = false,
    this.isLoading = true,
  });

  @override
  List<Object> get props => [
        homeAddress,
        isSetupCompleted,
        isConsentGiven,
        isLocationPermissionGranted,
        isHealthPermissionGranted,
        isLoading,
      ];

  SetupState copyWith({
    String? homeAddress,
    bool? isSetupCompleted,
    bool? isConsentGiven,
    bool? isLocationPermissionGranted,
    bool? isHealthPermissionGranted,
    bool? isLoading,
  }) {
    return SetupState(
      homeAddress: homeAddress ?? this.homeAddress,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      isConsentGiven: isConsentGiven ?? this.isConsentGiven,
      isLocationPermissionGranted: isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isHealthPermissionGranted: isHealthPermissionGranted ?? this.isHealthPermissionGranted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
