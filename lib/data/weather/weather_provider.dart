import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/weather_dto.dart';

class WeatherProvider {
  WeatherProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  final http.Client _httpClient;

  Future<WeatherDTO> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true'
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

    return WeatherDTO.fromJson(weatherJson);
  }
}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}
