part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final double homeLongitude;
  final double homeLatitude;

  final String homeAddress;

  final bool isSetupCompleted;

  const SetupState({
    this.homeLongitude = 0,
    this.homeLatitude = 0,
    this.homeAddress = "",
    this.isSetupCompleted = false,
  });

  @override
  List<Object> get props => [homeLongitude, homeLatitude, homeAddress, isSetupCompleted];

  SetupState copyWith({
    double? homeLongitude,
    double? homeLatitude,
    String? homeAddress,
    bool? isSetupCompleted,
  }) {
    return SetupState(
      homeLongitude: homeLongitude ?? this.homeLongitude,
      homeLatitude: homeLatitude ?? this.homeLatitude,
      homeAddress: homeAddress ?? this.homeAddress,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
    );
  }
}
