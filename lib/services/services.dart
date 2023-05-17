// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final String location;
  final num temperature;
  final num pressure;
  final num precipitation;
  final num humidity;
  final num windSpeed;
  final String conditionText;
  final String? time;
  final String conditionIcon;

  Weather(
      {required this.location,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.precipitation,
      required this.windSpeed,
      this.time,
      required this.conditionIcon,
      required this.conditionText});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        location: json['location']['name'],
        temperature: json['current']['temp_c'],
        pressure: json['current']['pressure_mb'],
        humidity: json['current']['humidity'],
        windSpeed: json['current']['wind_kph'],
        conditionIcon: "http:" + json['current']['condition']['icon'],
        precipitation: json['current']['precip_mm'],
        conditionText: json['current']['condition']['text']);
  }

  @override
  String toString() {
    return 'Weather(location: $location, temperature: $temperature, pressure: $pressure, precipitation: $precipitation, humidity: $humidity, windSpeed: $windSpeed, conditionText: $conditionText, time: $time, conditionIcon: $conditionIcon)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'temperature': temperature,
      'pressure': pressure,
      'precipitation': precipitation,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'conditionText': conditionText,
      'time': time,
      'conditionIcon': conditionIcon,
    };
  }

  String toJson() => json.encode(toMap());
}

class Forecast {
  final String location;
  final List<Weather> hourlyForecasts;

  Forecast({
    required this.location,
    required this.hourlyForecasts,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<Weather> hourlyForecasts = [];
    for (var forecast in json['forecast']['forecastday']) {
      for (var hour in forecast['hour']) {
        hourlyForecasts.add(Weather(
          location: json['location']['name'],
          temperature: hour['temp_c'],
          pressure: hour['pressure_mb'],
          humidity: hour['humidity'],
          windSpeed: hour['wind_kph'],
          time: hour['time'],
          conditionIcon: "http:" + hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['precip_mm'],
        ));
      }
    }
    return Forecast(
      location: json['location']['name'],
      hourlyForecasts: hourlyForecasts,
    );
  }

  @override
  String toString() =>
      'Forecast(location: $location, hourlyForecasts: $hourlyForecasts)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'hourlyForecasts': hourlyForecasts.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class HistoricalForecasts {
  final String location;
  final List<Weather> hourlyForecasts;
  final List<Weather> predictedForecasts;
  HistoricalForecasts({
    required this.location,
    required this.hourlyForecasts,
    required this.predictedForecasts,
  });

  factory HistoricalForecasts.fromJson(
      Map<String, dynamic> json1,
      Map<String, dynamic> json2,
      Map<String, dynamic> json3,
      Map<String, dynamic> json4) {
    List<Weather> hourlyForecasts = [];
    List<Weather> predictedForecasts = [];
    for (var forecast in json1['forecast']['forecastday']) {
      for (var hour in forecast['hour']) {
        hourlyForecasts.add(Weather(
          location: json1['location']['name'],
          temperature: hour['temp_c'],
          pressure: hour['pressure_mb'],
          humidity: hour['humidity'],
          windSpeed: hour['wind_kph'],
          time: hour['time'],
          conditionIcon: "http:" + hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['precip_mm'],
        ));
      }
    }
    for (var forecast in json3['forecast']['forecastday']) {
      for (var hour in forecast['hour']) {
        hourlyForecasts.add(Weather(
          location: json3['location']['name'],
          temperature: hour['temp_c'],
          pressure: hour['pressure_mb'],
          humidity: hour['humidity'],
          windSpeed: hour['wind_kph'],
          time: hour['time'],
          conditionIcon: "http:" + hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['precip_mm'],
        ));
      }
    }
    for (var forecast in json2['forecast']['forecastday']) {
      for (var hour in forecast['hour']) {
        predictedForecasts.add(Weather(
          location: json2['location']['name'],
          temperature: hour['temp_c'],
          pressure: hour['pressure_mb'],
          humidity: hour['humidity'],
          windSpeed: hour['wind_kph'],
          time: hour['time'],
          conditionIcon: "http:" + hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['precip_mm'],
        ));
      }
    }
    for (var forecast in json4['forecast']['forecastday']) {
      for (var hour in forecast['hour']) {
        predictedForecasts.add(Weather(
          location: json4['location']['name'],
          temperature: hour['temp_c'],
          pressure: hour['pressure_mb'],
          humidity: hour['humidity'],
          windSpeed: hour['wind_kph'],
          time: hour['time'],
          conditionIcon: "http:" + hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['precip_mm'],
        ));
      }
    }
    return HistoricalForecasts(
        location: json1['location']['name'],
        hourlyForecasts: hourlyForecasts,
        predictedForecasts: predictedForecasts);
  }

  @override
  String toString() =>
      'HistoricalForecasts(location: $location, hourlyForecasts: $hourlyForecasts, predictedForecasts: $predictedForecasts)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'hourlyForecasts': hourlyForecasts.map((x) => x.toMap()).toList(),
      'predictedForecasts': predictedForecasts.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

Future<Weather> getCurrentWeather(String apiKey, String city) async {
  var url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return Weather.fromJson(jsonResponse);
  } else {
    print(response.statusCode.toString() + " " + response.body);
    throw Exception('Failed to load weather data');
  }
}
