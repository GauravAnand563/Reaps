import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  //primary
  static const primary100 = Color(0xffD4DBEB);
  static const primary200 = Color(0xff7B859D);
  static const primary400 = Color(0xff3B445B);
  static const primary600 = Color(0xff383746);
  //secondary
  static const secondary100 = Color(0xffE9FFF5);
  static const secondary200 = Color(0xff95F8C9);
  static const secondary300 = Color(0xff49D292);
  static const secondary400 = Color(0xff29A46A);
  //accent
  static const accent100 = Color(0xffFEFEEF);
  static const accent200 = Color(0xffFEFFD2);
  static const accent300 = Color(0xffF5F79A);
  static const accent400 = Color(0xffF5F92A);
  //grey
  static const grey100 = Color(0xffFBFCFB);
  static const grey200 = Color(0xffEDEDED);
  static const grey300 = Color(0xffE4E4E4);
  static const grey400 = Color(0xffCACACA);
  static const grey500 = Color(0xff989898);
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

Future<HistoricalForecasts> getHistoricalForecast(
    String apiKey, String city) async {
  List<String> dates = [];
  DateTime now = DateTime.now();
  for (int i = 1; i <= 4; i++) {
    DateTime previousDay = now.subtract(Duration(days: i));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
    dates.add(formattedDate);
  }
  List<http.Response> responses = [];
  var url1 = Uri.parse(
      'http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${dates[0]}');
  var url2 = Uri.parse(
      'http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${dates[1]}');
  var url3 = Uri.parse(
      'http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${dates[2]}');
  var url4 = Uri.parse(
      'http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${dates[3]}');
  var response1 = await http.get(url1);
  var response2 = await http.get(url2);
  var response3 = await http.get(url3);
  var response4 = await http.get(url4);
  responses.add(response1);
  responses.add(response2);
  responses.add(response3);
  responses.add(response4);
  List<dynamic> historicalForecastsJsons = [];
  for (http.Response response in responses) {
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      historicalForecastsJsons.add(jsonResponse);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  return HistoricalForecasts.fromJson(
      historicalForecastsJsons[0],
      historicalForecastsJsons[1],
      historicalForecastsJsons[2],
      historicalForecastsJsons[3]);
}

Future<String> getWeatherImage(String apiKey, String weatherCondition) async {
  final response = await http.get(
    Uri.parse(
        'https://api.unsplash.com/photos/random?query=$weatherCondition&client_id=$apiKey&&orientation=landscape'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['urls']['regular'];
  } else {
    throw Exception('Failed to load image');
  }
}
