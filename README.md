<!-- # Flutter weather app bloc

This project is on BLoC pattern.

## Dependency:

~~~
  flutter_bloc: ^8.0.1
  freezed_annotation: ^1.1.0
  freezed: ^1.1.1
~~~

## Getting Started

For this project fristly we need a model.

## Model:
~~~
class Weather {
  final String cityName;
  final double temperatureCelsius;
  final double temperatureFahrenheit;

  Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.temperatureFahrenheit,
  });
}
~~~

Then we need a fake data generator cause we are not taking real api.

## Data generator 
~~~
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
~~~

For working with BLoC we need bloc, state and event file.
In block state we need to define our total state needed.

## State:

~~~
@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = _Initial;
  const factory WeatherState.loading() = Loading;
  const factory WeatherState.success(Weather weather) = Success;
}
~~~

Then need to set event what we trigger from UI.

## Event:

~~~
@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.started() = _Started;
  const factory WeatherEvent.getWeatherPressed(String cityName) =
      GetWeatherPressed;
}
~~~

From bloc file, handle state and event.

~~~
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(const WeatherState.initial()) {
    on<GetWeatherPressed>((event, emit) async {
      emit(const WeatherState.loading());
      final weather = await _fetchWeatherFromFakeApi(event.cityName);
      emit(WeatherState.success(weather));
    });
  }
}
~~~

BLoC setup is done. Now it's time to use bloc.

To use bloc, wrap the page with BlocProvider and call the Bloc file in create.

~~~
home: BlocProvider(
        create: (context) => WeatherBloc(),
        child: WeatherSearchPage(),
      )
~~~

Wrap the widget with BlocBuilder where we need to catch the bloc properties. 
BlocBuilder have a builder, builder have state in parameter, all the bloc state belong in state.

~~~
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
~~~

To pass data from one page to another page we need to use use "BlocProvider.vlaue" in Navigator builder method. These data will be in the state of bloc.

~~~
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
~~~

To catch the provided value from first page we need BlocBuilder again and the data will be available in state.when.

~~~
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
~~~

😍😍😍This is it. The project is done.😍😍😍 -->