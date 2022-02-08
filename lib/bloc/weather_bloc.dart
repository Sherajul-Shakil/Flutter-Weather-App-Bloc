import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_weather_app_bloc/data/model/weather.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'weather_event.dart';
part 'weather_state.dart';
part 'weather_bloc.freezed.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  //String Dhaka;
  WeatherBloc() : super(const WeatherState.initial()) {
    on<GetWeatherPressed>((event, emit) async {
      emit(const WeatherState.loading());
      final weather = await _fetchWeatherFromFakeApi(event.cityName);
      emit(WeatherState.success(weather));
    });
  }
}

Future<Weather> _fetchWeatherFromFakeApi(String cityName) {
  return Future.delayed(
    const Duration(seconds: 1),
    () {
      return Weather(
        cityName: cityName,
        temperatureCelsius: (20 + Random().nextInt(15)) + Random().nextDouble(),
        temperatureFahrenheit:
            (40 + Random().nextInt(15)) + Random().nextDouble(),
      );
    },
  );
}

// Future<Weather> fetchDetailedWeather(
//     String cityName, double tempValueC, double tempValueF) {
//   // Simulate network delay
//   return Future.delayed(
//     const Duration(seconds: 1),
//     () {
//       return Weather(
//         cityName: cityName,
//         temperatureCelsius: tempValueC,
//         temperatureFahrenheit: tempValueF,
//       );
//     },
//   );
// }
