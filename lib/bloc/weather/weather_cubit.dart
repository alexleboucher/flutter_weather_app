import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/weather/weather_repository.dart';
import '../../models/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await _weatherRepository.getWeather(city);

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weather: weather,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;
    try {
      final weather =
          await _weatherRepository.getWeather(state.weather.location);

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weather: weather,
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  void toggleUnits() {
    final unit = state.unit == TemperatureUnits.fahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;

    emit(state.copyWith(unit: unit));
    print(unit);
  }

  Map<String, dynamic> toJson() => state.toJson();

  WeatherState fromJson(dynamic json) => WeatherState.fromJson(json);
}
