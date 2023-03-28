// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

class Weather {
  final String location;
  final double temperature;
  final double pressure;
  final double precipitation;
  final double humidity;
  final double windSpeed;
  final String conditionText;
  final String conditionIcon;

  Weather(
      {required this.location,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.precipitation,
      required this.windSpeed,
      required this.conditionIcon,
      required this.conditionText});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        location: json['location']['name'],
        temperature: json['current']['temp_c'],
        pressure: json['current']['pressure_mb'],
        humidity: json['current']['humidity'],
        windSpeed: json['current']['wind_kph'],
        conditionIcon: json['current']['condition']['icon'],
        precipitation: json['current']['precip_mm'],
        conditionText: json['current']['condition']['text']);
  }

  @override
  String toString() {
    return 'Weather(location: $location, temperature: $temperature, pressure: $pressure, precipitation: $precipitation, humidity: $humidity, windSpeed: $windSpeed, conditionText: $conditionText, conditionIcon: $conditionIcon)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'temperature': temperature,
      'pressure': pressure,
      'precipitation': precipitation,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'conditionIcon': conditionIcon,
      'conditionText': conditionText
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      location: map['location'] as String,
      temperature: map['temperature'] as double,
      pressure: map['pressure'] as double,
      precipitation: map['precipitation'] as double,
      humidity: map['humidity'] as double,
      windSpeed: map['windSpeed'] as double,
      conditionIcon: map['conditionIcon'] as String,
      conditionText: map['conditionText'] as String,
    );
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
          conditionIcon: hour['condition']['icon'],
          conditionText: hour['condition']['text'],
          precipitation: hour['condition']['precip_mm'],
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
}

Future<Weather> getCurrentWeather(String apiKey, String city) async {
  var url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return Weather.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<Forecast> getHourlyForecast(String apiKey, String city) async {
  var url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=1');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return Forecast.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<String> getWeatherImage(String apiKey, String weatherCondition) async {
  final response = await http.get(
    Uri.parse(
        'https://api.unsplash.com/photos/random?query=$weatherCondition&client_id=$apiKey&&orientation=landscape&width=600&height=200'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['urls']['regular'];
  } else {
    throw Exception('Failed to load image');
  }
}
