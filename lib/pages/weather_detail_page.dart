import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app_bloc/bloc/weather_bloc.dart';

import '../data/model/weather.dart';

class WeatherDetailPage extends StatelessWidget {
  final Weather masterWeather;

  const WeatherDetailPage({
    Key? key,
    required this.masterWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Detail"),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: state.when(
              initial: () => Container(),
              loading: () => buildLoading(),
              success: (d) => buildColumnWithData(context, d),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(2)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        Text(
          "${weather.temperatureFahrenheit.toStringAsFixed(2)} °F",
          style: const TextStyle(fontSize: 80),
        ),
      ],
    );
  }
}
