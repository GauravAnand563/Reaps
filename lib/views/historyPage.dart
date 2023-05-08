import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reaps/constants.dart';
import 'package:reaps/services.dart';
import 'package:reaps/states.dart';

import 'frostedGlassButton.dart';
import 'graphPage.dart';
import 'main.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    int selectedCity = Provider.of<LocationIndex>(context).selectedIndex;
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GraphPage()));
              },
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                child: Icon(Icons.bar_chart_rounded),
              ),
            ),
          ),
        ],
        title: Center(
          child: Text(
            'History',
            style: kh2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<HistoricalForecasts>(
                future: getHistoricalForecast(
                    WEATHER_API_KEY, locations[selectedCity]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Weather> hourly = snapshot.data!.hourlyForecasts;
                      List<Weather> predicted =
                          snapshot.data!.predictedForecasts;
                      return Column(
                        children: [
                          for (int i = 0; i < hourly.length; i++)
                            WeatherForecastTile(
                                weather: hourly[i],
                                predictedWeather: predicted[i])
                        ],
                      );
                    } else if (snapshot.hasError) {}
                  }
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: kSecondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Retrieving history from saved memory..',
                          style: kh4,
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class WeatherForecastTile extends StatefulWidget {
  WeatherForecastTile(
      {super.key, required this.weather, required this.predictedWeather});
  Weather weather;
  Weather predictedWeather;
  @override
  State<WeatherForecastTile> createState() => _WeatherForecastTileState();
}

class _WeatherForecastTileState extends State<WeatherForecastTile> {
  int index = 0;

  late OverlayEntry _popupDialog;

  OverlayEntry _createTopicPopup() {
    return OverlayEntry(
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 250,
            decoration: BoxDecoration(
              color: kScaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherAttributeWidget(
                  icon: Icons.circle,
                  label: 'Parameters',
                  value: 'Recorded',
                  alt: 'Predicted',
                ),
                Divider(
                  thickness: 3,
                  color: Colors.blueGrey.shade400,
                ),
                SizedBox(
                  height: 7,
                ),
                _buildWeatherAttributeWidget(
                  icon: Icons.water_drop,
                  label: 'Precipitation',
                  value: '${widget.weather.precipitation} mm/h',
                  alt: '${widget.predictedWeather.precipitation} mm/h',
                ),
                _buildWeatherAttributeWidget(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${widget.weather.temperature} °C',
                  alt: '${widget.predictedWeather.temperature} °C',
                ),
                _buildWeatherAttributeWidget(
                  icon: Icons.cloud,
                  label: 'Humidity',
                  value: '${widget.weather.humidity} %',
                  alt: '${widget.predictedWeather.humidity} %',
                ),
                _buildWeatherAttributeWidget(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${widget.weather.windSpeed} km/h',
                  alt: '${widget.predictedWeather.windSpeed} km/h',
                ),
                _buildWeatherAttributeWidget(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '${widget.weather.pressure} hPa',
                  alt: '${widget.predictedWeather.pressure} hPa',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherAttributeWidget(
      {required IconData icon,
      Color? color,
      required String label,
      required String value,
      required String alt}) {
    return FrostedGlassButton(
      onTap: () {},
      color: color ?? Colors.black12,
      label: label,
      iconData: icon,
      alt: alt,
      text: value,
    );
  }

  late final timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        index = (index + 1) % 5;
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> forecastAttributes = [
      _buildWeatherAttributeWidget(
        icon: Icons.water_drop,
        label: 'Precipitation',
        value: '${widget.weather.precipitation} mm/h',
        alt: '${widget.predictedWeather.precipitation} mm/h',
      ),
      _buildWeatherAttributeWidget(
        icon: Icons.thermostat,
        label: 'Temperature',
        value: '${widget.weather.temperature} °C',
        alt: '${widget.predictedWeather.temperature} °C',
      ),
      _buildWeatherAttributeWidget(
        icon: Icons.cloud,
        label: 'Humidity',
        value: '${widget.weather.humidity} %',
        alt: '${widget.predictedWeather.humidity} %',
      ),
      _buildWeatherAttributeWidget(
        icon: Icons.air,
        label: 'Wind Speed',
        value: '${widget.weather.windSpeed} km/h',
        alt: '${widget.predictedWeather.windSpeed} km/h',
      ),
      _buildWeatherAttributeWidget(
        icon: Icons.compress,
        label: 'Pressure',
        value: '${widget.weather.pressure} hPa',
        alt: '${widget.predictedWeather.pressure} hPa',
      ),
    ];
    return GestureDetector(
      onLongPress: () {
        _popupDialog = _createTopicPopup();
        Overlay.of(context)?.insert(_popupDialog);
      },
      onLongPressEnd: (details) {
        _popupDialog.remove();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xff22262B).withOpacity(0.7),
                  child: Container(
                    // width: 200,
                    constraints: const BoxConstraints.tightForFinite(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            widget.weather.time!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: GoogleFonts.notoSans(
                                fontSize: 14, color: Colors.teal.shade100),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: 300),
                          child: AnimatedSwitcher(
                            duration: Duration(seconds: 1),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            child: forecastAttributes[index],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _popupDialog = _createTopicPopup();
                  Overlay.of(context)?.insert(_popupDialog);
                  Future.delayed(Duration(seconds: 2), () {
                    _popupDialog.remove();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.cyan,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Details',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForecastAttributeWidget({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return FrostedGlassButton(
      onTap: () {},
      color: Colors.black12,
      label: label,
      iconData: icon,
      text: value,
    );
  }
}
