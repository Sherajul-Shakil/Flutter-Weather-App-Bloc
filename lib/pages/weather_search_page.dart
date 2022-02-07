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
            child: state.when(
              initial: () => buildInitialInput(),
              loading: () => buildLoading(),
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
        RaisedButton(
          child: const Text('See Details'),
          color: Colors.lightBlue[100],
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<WeatherBloc>(context),
                child: WeatherDetailPage(
                  masterWeather: Weather(
                    cityName: weather.cityName,
                    temperatureCelsius: weather.temperatureCelsius,
                    temperatureFahrenheit: weather.temperatureFahrenheit,
                  ),
                  // key: null!,
                ),
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
              // context
              //     .read<WeatherBloc>()
              //     .add(const WeatherEvent.getWeatherPressed("dhaka"));
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    context.read<WeatherBloc>().add(WeatherEvent.getWeatherPressed(cityName));
  }
}
