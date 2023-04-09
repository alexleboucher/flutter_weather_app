import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/location_dto.dart';

class GeoProvider {
  GeoProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';
  final http.Client _httpClient;

  Future<LocationDTO> getLocation(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return LocationDTO.fromJson(results.first as Map<String, dynamic>);
  }
}

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}
