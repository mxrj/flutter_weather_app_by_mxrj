import 'dart:async';

import 'package:flutter_weather_app_by_mxrj/events/WeatherEvent.dart';
import 'package:flutter_weather_app_by_mxrj/models/Weather.dart';
import 'package:flutter_weather_app_by_mxrj/services/WeatherService.dart';
import 'package:flutter_weather_app_by_mxrj/states/WeatherState.dart';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(null) {
    add(WeatherCurrentPositionRequested());
  }

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherRequested) {
      yield* _newWeatherRequested(event);
    }
    if (event is WeatherCurrentPositionRequested) {
      yield* _newWeatherCurrentPositionRequested();
    }
  }

  Stream<WeatherState> _newWeatherRequested(WeatherRequested event) async* {
    yield WeatherLoadInProgress();
    try {
      final Weather weather = await WeatherService.fetchCurrentWeather(
          query: event.city, lon: event.lon, lat: event.lat);
      final List<Weather> hourlyWeather =
      await WeatherService.fetchHourlyWeather(
          query: event.city, lon: event.lon, lat: event.lat);
      yield WeatherLoadSuccess(weather: weather, hourlyWeather: hourlyWeather);
    } catch (e) {
      yield WeatherLoadFailure();
    }
  }

  Stream<WeatherState> _newWeatherCurrentPositionRequested() async* {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position lastKnownPosition = await Geolocator.getLastKnownPosition();
      if(lastKnownPosition != null) {
        add(WeatherRequested(
            lat: lastKnownPosition.latitude.toString(),
            lon: lastKnownPosition.longitude.toString()));

      } else {
        Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        add(WeatherRequested(
            lat: position.latitude.toString(),
            lon: position.longitude.toString()));
      }
    } else {
      await Geolocator.requestPermission();
      add(WeatherCurrentPositionRequested());
    }
  }
}