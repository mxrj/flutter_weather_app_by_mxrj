import 'dart:convert';

import 'package:flutter_weather_app_by_mxrj/models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static String _apiKey = "1bc60fc7baa57242fa2daec45c2c0b61"; //API ключ от сервиса OPENWEATHER.org

  static Future<Weather> fetchCurrentWeather({query, String lat = "", String lon =""}) async {  //метод получения текущей погоды
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$query&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {  //Проверка на доступность сервиса
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static Future<List<Weather>> fetchHourlyWeather({String query, String lat = "", String lon =""}) async {  //метод получения погоды по часам
    var url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$query&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Weather> data = (jsonData['list'] as List<dynamic>)
          .map((item) {
        return Weather.fromJson(item);
      }).toList();
      return data;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
