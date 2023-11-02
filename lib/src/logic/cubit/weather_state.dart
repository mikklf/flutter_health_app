part of 'weather_cubit.dart';

final class WeatherState extends Equatable {
  final Weather? weatherData;

  final DateTime timestamp;

  const WeatherState(
      {this.weatherData,
      required this.timestamp}
  );


  @override
  List<Object> get props => [timestamp];

  WeatherState copyWith({
    Weather? weatherData,
    DateTime? timestamp,
  }) {
    return WeatherState(
      weatherData: weatherData ?? this.weatherData,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}