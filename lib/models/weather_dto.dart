class WeatherDTO {
  const WeatherDTO({required this.temperature, required this.weatherCode});

  final double temperature;
  final double weatherCode;

  static WeatherDTO fromJson(dynamic json) {
    return WeatherDTO(
      temperature: json['temperature'],
      weatherCode: json['weathercode'].toDouble(),
    );
  }
}
