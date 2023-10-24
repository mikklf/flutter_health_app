part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final bool isLoading;

  final String homeAddress;
  final bool isConsentGiven;
  final bool isLocationPermissionGranted;
  final bool isHealthPermissionGranted;

  final bool isSetupCompleted;

  const SetupState({
    this.isLoading = false,
    this.homeAddress = "",
    this.isSetupCompleted = false,
    this.isConsentGiven = false,
    this.isLocationPermissionGranted = false,
    this.isHealthPermissionGranted = false,
  });

  @override
  List<Object> get props => [
        homeAddress,
        isSetupCompleted,
        isConsentGiven,
        isLoading,
        isLocationPermissionGranted,
        isHealthPermissionGranted
      ];

  SetupState copyWith({
    String? homeAddress,
    bool? isSetupCompleted,
    bool? isConsentGiven,
    bool? isLoading,
    bool? isLocationPermissionGranted,
    bool? isHealthPermissionGranted,
  }) {
    return SetupState(
      homeAddress: homeAddress ?? this.homeAddress,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      isConsentGiven: isConsentGiven ?? this.isConsentGiven,
      isLoading: isLoading ?? this.isLoading,
      isLocationPermissionGranted: isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isHealthPermissionGranted: isHealthPermissionGranted ?? this.isHealthPermissionGranted,
    );
  }
}
