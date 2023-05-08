import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services.dart';
import 'states.dart';

import 'constants.dart';
import 'frostedGlassButton.dart';
import 'main.dart';

class CurrentWeatherWidget extends StatefulWidget {
  const CurrentWeatherWidget({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    int selectedLocationIndex =
        Provider.of<LocationIndex>(context).selectedIndex;
    return FutureBuilder<Weather>(
        future: getCurrentWeather(
            WEATHER_API_KEY, locations[selectedLocationIndex]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<String>(
                  future: getWeatherImage(IMAGE_API_KEY,
                      "${snapshot.data!.conditionText} weather sky"),
                  builder: (context, weatherSnapshot) {
                    if (weatherSnapshot.connectionState ==
                            ConnectionState.done &&
                        weatherSnapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.greenAccent.shade100
                                      .withOpacity(0.3),
                                  blurRadius: 30)
                            ],
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 179, 164, 82),
                              Color(0xff06C0B5),
                            ]),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  weatherSnapshot.data!,
                                ))),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.3, sigmaY: 1.3),
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
                                      snapshot.data!.conditionIcon,
                                      height: 80,
                                      scale: 0.5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white30,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        (false
                                            ? 'Extreme Weather'
                                            : 'Non-Extreme Weather'),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildWeatherAttributeWidget(
                                        icon: Icons.water_drop,
                                        label: 'Precipitation',
                                        value:
                                            '${snapshot.data!.precipitation} mm/h',
                                      ),
                                      _buildWeatherAttributeWidget(
                                        icon: Icons.thermostat,
                                        label: 'Temperature',
                                        value:
                                            '${snapshot.data!.temperature} °C',
                                      ),
                                      _buildWeatherAttributeWidget(
                                        icon: Icons.cloud,
                                        label: 'Humidity',
                                        value: '${snapshot.data!.humidity} %',
                                      ),
                                      _buildWeatherAttributeWidget(
                                        icon: Icons.air,
                                        label: 'Wind Speed',
                                        value:
                                            '${snapshot.data!.windSpeed} km/h',
                                      ),
                                      _buildWeatherAttributeWidget(
                                        icon: Icons.compress,
                                        label: 'Pressure',
                                        value: '${snapshot.data!.pressure} hPa',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  });
            } else if (snapshot.hasError) {
              return Text(
                'Calcuation stopped abrupty',
                style: kh3.copyWith(color: Colors.red),
              );
            }
          }
          return Center(
              child: Column(
            children: [
              CircularProgressIndicator(
                color: Colors.blueGrey.shade100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Calculating Current Weather...',
                style: kh3,
              )
            ],
          ));
        });
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
