import 'package:equatable/equatable.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

enum TemperatureUnits {
  celsius,
  fahrenheit,
}

class Temperature extends Equatable {
  const Temperature({required double value}) : _value = value;

  final double _value;

  double get celsiusValue => _value;
  double get fahrenheitValue => _value * 1.8 + 32;

  @override
  List<Object?> get props => [_value];
}

class Weather extends Equatable {
  Weather({
    required this.location,
    required double temperature,
    required this.condition,
    DateTime? lastUpdated,
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        temperature = Temperature(value: temperature);

  final String location;
  final Temperature temperature;
  final WeatherCondition condition;
  final DateTime lastUpdated;

  @override
  List<Object> get props => [condition, lastUpdated, location, temperature];

  Map<String, dynamic> toJson() => {
        'location': location,
        'condition': condition.index,
        'lastUpdated': lastUpdated.toString(),
        'temperature': {
          'value': temperature._value,
        },
      };

  static Weather fromJson(dynamic json) {
    return Weather(
      location: json['location'],
      temperature: json['temperature']['value'],
      condition: WeatherCondition.values[json['condition']],
      lastUpdated: DateTime.tryParse(json['lastUpdated']),
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: 0,
    location: '--',
  );

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    double? temperature,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature._value,
    );
  }
}
