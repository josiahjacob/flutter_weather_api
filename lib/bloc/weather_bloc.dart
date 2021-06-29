import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_http_test/WeatherModel.dart';
import 'package:json_http_test/WeatherRepo.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo repository;
  WeatherBloc(this.repository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    yield WeatherLoading();
    // Branching the executed logic by checking the event type
    if (event is GetWeather) {
      // Emit either Loaded or Error
      try {
        final weather = await repository.getWeather(event.cityName);
        yield WeatherLoaded(weather);
      } catch (_) {
        print(_);
        yield WeatherError("Couldn't fetch weather. Is the device online?");
      }
    } else if (event is ResetWeather) {
      yield WeatherInitial();
    }
  }
}
