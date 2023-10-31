class Weather {
  final double? temperature;
  final double? temperatureFeelsLike;
  final double? humidity;
  final double? cloudinessPercent;

  final String? weatherCondition;
  final String? weatherdescription;

  final double? latitude;
  final double? longitude;

  final DateTime timestamp;

  final DateTime? sunrise;
  final DateTime? sunset;

  const Weather(
      {required this.temperature,
      required this.temperatureFeelsLike,
      required this.humidity,
      required this.cloudinessPercent,
      required this.weatherCondition,
      required this.weatherdescription,
      required this.latitude,
      required this.longitude,
      required this.timestamp,
      required this.sunrise,
      required this.sunset
      }
  );

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'temperature_feels_like': temperatureFeelsLike,
      'humidity': humidity,
      'cloudiness_percent': cloudinessPercent,
      'weather_condition': weatherCondition,
      'weather_description': weatherdescription,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toString(),
      'sunrise': sunrise.toString(),
      'sunset': sunset.toString(),
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      temperature: map['temperature'] as double,
      temperatureFeelsLike: map['temperature_feels_like'] as double,
      humidity: map['humidity'] as double,
      cloudinessPercent: map['cloudiness_percent'] as double,
      weatherCondition: map['weather_condition'] as String,
      weatherdescription: map['weather_description'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      timestamp: DateTime.parse(map['timestamp']),
      sunrise: DateTime.parse(map['sunrise']),
      sunset: DateTime.parse(map['sunset']),
    );
  }

  Weather copyWith({
    double? temperature,
    double? temperatureFeelsLike,
    double? humidity,
    double? cloudinessPercent,
    String? weatherCondition,
    String? weatherdescription,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return Weather(
      temperature: temperature ?? this.temperature,
      temperatureFeelsLike: temperatureFeelsLike ?? this.temperatureFeelsLike,
      humidity: humidity ?? this.humidity,
      cloudinessPercent: cloudinessPercent ?? this.cloudinessPercent,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherdescription: weatherdescription ?? this.weatherdescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }
}