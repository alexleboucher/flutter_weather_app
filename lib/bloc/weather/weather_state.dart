part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

class WeatherState extends Equatable {
  WeatherState({
    this.status = WeatherStatus.initial,
    this.unit = TemperatureUnits.celsius,
    Weather? weather,
  }) : weather = weather ?? Weather.empty;

  final WeatherStatus status;
  final Weather weather;
  final TemperatureUnits unit;

  @override
  List<Object> get props => [status, weather, unit];

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    TemperatureUnits? unit,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.index,
        'unit': unit.index,
        'weather': weather.toJson(),
      };

  static WeatherState fromJson(dynamic json) {
    return WeatherState(
      status: WeatherStatus.values[json['status']],
      unit: TemperatureUnits.values[json['unit']],
      weather: Weather.fromJson(json['weather']),
    );
  }
}
