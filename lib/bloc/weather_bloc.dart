import 'dart:js';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_weather_app_bloc/data/model/weather.dart';
import 'package:flutter_weather_app_bloc/data/weather_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'weather_event.dart';
part 'weather_state.dart';
part 'weather_bloc.freezed.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  //String Dhaka;
  WeatherBloc() : super(const WeatherState.initial()) {
    on<GetWeatherPressed>((event, emit) async {
      emit(const WeatherState.loading());
      final weather = await _fetchWeatherFromFakeApi('Dhaka');
      emit(WeatherState.success(weather));
    });
  }
}

Future<Weather> _fetchWeatherFromFakeApi(String cityName) {
  // Simulate network delay
  return Future.delayed(
    Duration(seconds: 1),
    () {
      return Weather(
        cityName: cityName,
        temperatureCelsius: (20 + Random().nextInt(15)) + Random().nextDouble(),
        temperatureFahrenheit:
            (20 + Random().nextInt(15)) + Random().nextDouble(),
      );
    },
  );
}
