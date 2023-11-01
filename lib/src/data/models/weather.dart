class Weather {
  final num? temperature;
  final num? temperatureFeelsLike;
  final num? humidity;
  final num? cloudinessPercent;

  final String? weatherCondition;
  final String? weatherdescription;

  final num? latitude;
  final num? longitude;

  final DateTime timestamp;

  final DateTime? sunrise;
  final DateTime? sunset;

  const Weather(
      {required this.temperature,
      this.temperatureFeelsLike,
      this.humidity,
      this.cloudinessPercent,
      this.weatherCondition,
      this.weatherdescription,
      this.latitude,
      this.longitude,
      required this.timestamp,
      this.sunrise,
      this.sunset
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
      temperature: map['temperature'],
      temperatureFeelsLike: map['temperature_feels_like'],
      humidity: map['humidity'],
      cloudinessPercent: map['cloudiness_percent'],
      weatherCondition: map['weather_condition'],
      weatherdescription: map['weather_description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.parse(map['timestamp']),
      sunrise: map['sunrise'] == null ? null : DateTime.parse(map['sunrise']),
      sunset: map['sunset'] == null ? null : DateTime.parse(map['sunset']),
    );
  }

  Weather copyWith({
    num? temperature,
    num? temperatureFeelsLike,
    num? humidity,
    num? cloudinessPercent,
    String? weatherCondition,
    String? weatherdescription,
    num? latitude,
    num? longitude,
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