part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final double homeLongitude;
  final double homeLatitude;

  final String homeAddress;

  const SetupState({
    this.homeLongitude = 0,
    this.homeLatitude = 0,
    this.homeAddress = "",
  });

  @override
  List<Object> get props => [homeLongitude, homeLatitude, homeAddress];

  SetupState copyWith({
    double? homeLongitude,
    double? homeLatitude,
    String? homeAddress,
  }) {
    return SetupState(
      homeLongitude: homeLongitude ?? this.homeLongitude,
      homeLatitude: homeLatitude ?? this.homeLatitude,
      homeAddress: homeAddress ?? this.homeAddress,
    );
  }
}
