import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app_bloc/bloc/weather_bloc.dart';
import 'package:flutter_weather_app_bloc/data/model/weather.dart';

import 'weather_detail_page.dart';

class WeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Weather Search"),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: state.map(
              initial: (_) => buildInitialInput(),
              loading: (_) {
                return buildLoading();
              },
              success: (d) => buildColumnWithData(context, d),
            ),
          ),
        );
      },
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Success success) {
    final cityName = success.when(
        initial: () => '',
        loading: () => '',
        success: (weather) => weather.cityName);
    final String temperatureCelsius = success
        .when(
            initial: () => '',
            loading: () => '',
            success: (weather) => weather.temperatureCelsius)
        .toString();
    final String temperatureFahrenheit = success
        .when(
            initial: () => '',
            loading: () => '',
            success: (weather) => weather.temperatureFahrenheit)
        .toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${temperatureCelsius} °C",
          style: const TextStyle(fontSize: 80),
        ),
        RaisedButton(
          child: const Text('See Details'),
          color: Colors.lightBlue[100],
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => WeatherDetailPage(
                masterWeather: Weather(
                    cityName: cityName,
                    temperatureCelsius: double.parse(temperatureCelsius),
                    temperatureFahrenheit: double.parse(temperatureFahrenheit)),
                // key: null!,
              ),
            ));
          },
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            onPressed: () {
              context
                  .read<WeatherBloc>()
                  .add(const WeatherEvent.getWeatherPressed("S=dhaka"));
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    //TODO: Fetch the weather from the repository and display it somehow
  }
}
