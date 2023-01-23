import 'package:flutter_weather_app_by_mxrj/models/Weather.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}  //когда не происходит ничего

class WeatherLoadInProgress extends WeatherState {} //когда мы загружаем данные о погоде

class WeatherLoadSuccess extends WeatherState {  //когда данные загружены успешно
  final Weather weather;
  final List<Weather> hourlyWeather;

  const WeatherLoadSuccess(
      {@required this.weather, @required this.hourlyWeather})
      : assert(weather != null);

  @override
  List<Object> get props => [weather, hourlyWeather];
}

class WeatherLoadFailure extends WeatherState {}  //когда произошла какая-то ошибка