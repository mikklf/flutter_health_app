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
      temperature: map['temperature'] as num,
      temperatureFeelsLike: map['temperature_feels_like'] as num,
      humidity: map['humidity'] as num,
      cloudinessPercent: map['cloudiness_percent'] as num,
      weatherCondition: map['weather_condition'] as String,
      weatherdescription: map['weather_description'] as String,
      latitude: map['latitude'] as num,
      longitude: map['longitude'] as num,
      timestamp: DateTime.parse(map['timestamp']),
      sunrise: DateTime.parse(map['sunrise']),
      sunset: DateTime.parse(map['sunset']),
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