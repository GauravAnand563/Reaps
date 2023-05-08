import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reaps/services.dart';
import 'package:reaps/states.dart';

import 'constants.dart';
import 'frostedGlassButton.dart';
import 'main.dart';

class IntervalChooser extends StatelessWidget {
  const IntervalChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildIntervalChip('6 HR', context, 0),
          _buildIntervalChip('12 HR', context, 1),
          _buildIntervalChip('24 HR', context, 2),
        ],
      ),
    );
  }

  Widget _buildIntervalChip(String interval, BuildContext context, int index) {
    int selectedIndex =
        Provider.of<IntervalChooserState>(context).selectedInterval;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 30,
          // width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (selectedIndex == index)
                ? Colors.greenAccent.shade400.withGreen(160)
                : Colors.black12,
          ),
          child: InkWell(
            onTap: () {
              Provider.of<IntervalChooserState>(context, listen: false)
                  .setInterval(index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon(
                //         iconData,
                //         color: Colors.white,
                //         size: 16,
                //       ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  interval,
                  style: kh2.copyWith(
                      fontSize: 15, color: Colors.blueGrey.shade100),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PredictedWeatherWidget extends StatefulWidget {
  const PredictedWeatherWidget({super.key});

  @override
  State<PredictedWeatherWidget> createState() => _PredictedWeatherWidgetState();
}

class _PredictedWeatherWidgetState extends State<PredictedWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    int selectedCity = Provider.of<LocationIndex>(context).selectedIndex;
    return FutureBuilder<Forecast>(
        future: getHourlyForecast(WEATHER_API_KEY, locations[selectedCity]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              int selectedInterval =
                  Provider.of<IntervalChooserState>(context).selectedInterval;
              int start = 0, end = 0;
              if (selectedInterval == 0) {
                start = 0;
                end = 5;
              } else if (selectedInterval == 1) {
                start = 6;
                end = 12;
              } else {
                start = 13;
                end = 23;
              }
              List<Weather> forecasts = snapshot.data!.hourlyForecasts;
              return Column(
                children: [
                  for (int i = start; i <= end; i++)
                    WeatherForecastTile(weather: forecasts[i])
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                'Memory Limit Exceeded (Code : 0052x00f)',
                style: kh3,
              );
            }
          }
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Calculating Predictions',
                  style: kh4,
                )
              ],
            ),
          );
        });
  }
}

class WeatherForecastTile extends StatefulWidget {
  WeatherForecastTile({super.key, required this.weather});
  Weather weather;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Extreme weather label
                Expanded(
                  flex: 4,
                  child: Column(children: [
                    // Weather condition icon
                    const Spacer(),
                    Image.network(
                      widget.weather.conditionIcon,
                      height: 80,
                      scale: 0.5,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        (false ? 'Extreme Weather' : 'Non-Extreme Weather'),
                        style: GoogleFonts.abel(
                            // fontFamily: 'Abel',
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white70),
                      ),
                    ),
                    const Spacer()
                  ]),
                ),
                // VerticalDivider(width: 5, color: Colors.blueGrey.shade900),
                // Weather attribute icons and values
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWeatherAttributeWidget(
                        icon: Icons.water_drop,
                        label: 'Precipitation',
                        value: '${widget.weather.precipitation} mm/h',
                      ),
                      _buildWeatherAttributeWidget(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: '${widget.weather.temperature} °C',
                      ),
                      _buildWeatherAttributeWidget(
                        icon: Icons.cloud,
                        label: 'Humidity',
                        value: '${widget.weather.humidity} %',
                      ),
                      _buildWeatherAttributeWidget(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '${widget.weather.windSpeed} km/h',
                      ),
                      _buildWeatherAttributeWidget(
                        icon: Icons.compress,
                        label: 'Pressure',
                        value: '${widget.weather.pressure} hPa',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherAttributeWidget({
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
      _buildForecastAttributeWidget(
        icon: Icons.water_drop,
        label: 'Precipitation',
        value: '${widget.weather.precipitation} mm/h',
      ),
      _buildForecastAttributeWidget(
        icon: Icons.thermostat,
        label: 'Temperature',
        value: '${widget.weather.temperature} °C',
      ),
      _buildForecastAttributeWidget(
        icon: Icons.cloud,
        label: 'Humidity',
        value: '${widget.weather.humidity} %',
      ),
      _buildForecastAttributeWidget(
        icon: Icons.air,
        label: 'Wind Speed',
        value: '${widget.weather.windSpeed} km/h',
      ),
      _buildForecastAttributeWidget(
        icon: Icons.compress,
        label: 'Pressure',
        value: '${widget.weather.pressure} hPa',
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
        height: 100,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff2E2F34)),
                      // child: Image.network(thumbnail),
                      child: Image.network(widget.weather.conditionIcon),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Container(
                      width: 200,
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
                              constraints: BoxConstraints.tightFor(width: 200),
                              child: AnimatedSwitcher(
                                duration: Duration(seconds: 1),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                child: forecastAttributes[index],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          size: 24,
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
      // child: Row(
      //   children: [
      //     Icon(icon),
      //     const SizedBox(height: 5),
      //     Text(
      //       label,
      //       style: const TextStyle(fontFamily: 'Montserrat'),
      //     ),
      //     const SizedBox(height: 5),
      //     Text(
      //       value,
      //       style: const TextStyle(
      //         fontFamily: 'Montserrat',
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
