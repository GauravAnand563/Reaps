import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';


class Prediction {
  final double precipitation;
  final double temperature;
  final double windSpeed;
  final double pressure;
  final double humidity;

  Prediction(
      {required this.precipitation,
      required this.temperature,
      required this.windSpeed,
      required this.pressure,
      required this.humidity});
}


class WeatherPredictor extends StatefulWidget {
  @override
  _WeatherPredictorState createState() => _WeatherPredictorState();
}

class _WeatherPredictorState extends State<WeatherPredictor> {
  
  List<List<double>> historicalData = [];
  List<double> currentData = [];

  
  TextEditingController precipitationController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController windSpeedController = TextEditingController();
  TextEditingController pressureController = TextEditingController();
  TextEditingController humidityController = TextEditingController();

  
  void clearInputFields() {
    precipitationController.clear();
    temperatureController.clear();
    windSpeedController.clear();
    pressureController.clear();
    humidityController.clear();
  }

  
  Future loadWeatherModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
        model: 'assets/stacked_autoencoder.tflite', 
        labels: []);
    print('Weather model loaded: $res');
  }

  
  Future<List<List<String>>> predictWeather() async {
    
    await loadWeatherModel();

    
    int inputShape = 7;

    
    List<List<String>> predictions = [];

    
    for (int i = 6; i <= 24; i += 6) {
      
      List<List<double>> inputList = [];

      
      for (int j = 0; j < i; j++) {
        if (j < historicalData.length) {
          inputList.add(historicalData[j]);
        } else {
          inputList.add(currentData);
        }
      }

      
      inputList.add(currentData);

      
      List<dynamic>? result = await Tflite.runModelOnMatrix(
          model: 'stacked_autoencoder', 
          matrix: inputList,
          numResults: 1);
      String prediction = result![0][0].toStringAsFixed(2);

      
      predictions.add([prediction]);
    }

    
    clearInputFields();
    return predictions;
  }

  
  Future loadClassificationModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
        model: 'assets/isolation_classifier.tflite', 
        labels: []);
    print('Classification model loaded: $res');
  }

  
  Future<String> classifyWeather(Prediction prediction) async {
    
    await loadClassificationModel();

    
    int inputShape = 5;

    
    List<List<double>> inputList = [];
    inputList.add([prediction.precipitation, prediction.temperature, prediction.windSpeed, prediction.pressure, prediction.humidity]);
    
Tensor inputTensor = Tensor.fromList(inputList);


Tensor outputTensor = await classificationModel.predict(inputTensor);


String outputString = outputTensor.data.toString();


if (outputString.contains('1.0')) {
  return "Extreme Weather";
} else {
  return "Non-Extreme Weather";
}
  }