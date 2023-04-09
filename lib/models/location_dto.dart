class LocationDTO {
  const LocationDTO({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;

  static LocationDTO fromJson(dynamic json) {
    return LocationDTO(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
