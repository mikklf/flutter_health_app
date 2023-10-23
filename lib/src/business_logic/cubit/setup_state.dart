part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final bool isLoading;

  final double homeLongitude;
  final double homeLatitude;

  final String homeAddress;

  final bool isSetupCompleted;

  final bool isConsentGiven;

  const SetupState({
    this.isLoading = false,
    this.homeLongitude = 0,
    this.homeLatitude = 0,
    this.homeAddress = "",
    this.isSetupCompleted = false,
    this.isConsentGiven = false,
  });

  @override
  List<Object> get props => [
        homeLongitude,
        homeLatitude,
        homeAddress,
        isSetupCompleted,
        isConsentGiven,
        isLoading,
      ];

  SetupState copyWith({
    double? homeLongitude,
    double? homeLatitude,
    String? homeAddress,
    bool? isSetupCompleted,
    bool? isConsentGiven,
    bool? isLoading,
  }) {
    return SetupState(
      homeLongitude: homeLongitude ?? this.homeLongitude,
      homeLatitude: homeLatitude ?? this.homeLatitude,
      homeAddress: homeAddress ?? this.homeAddress,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      isConsentGiven: isConsentGiven ?? this.isConsentGiven,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
