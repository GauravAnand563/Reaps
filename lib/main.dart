import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reaps/constants.dart';
import 'package:provider/provider.dart';
import 'package:reaps/services.dart';
import 'package:reaps/states.dart';

import 'frostedGlassButton.dart';

void main() => runApp(const MyApp());

final locations = [
  'Ranchi',
  'Kolkata',
  'Gurgaon',
  'Mumbai',
  'Chennai',
  'Kashmir'
];
String currentLocation = 'Ranchi';
String weatherConditionText = "";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationIndex()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int selectedLocationIndex =
        Provider.of<LocationIndex>(context).selectedIndex;
    return Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              LocationChanger(selectedLocationIndex: selectedLocationIndex),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Current Weather',
                  style: GoogleFonts.montserrat(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              const CurrentWeatherWidget(),
              InkWell(
                onTap: () async {
                  final weather = await getCurrentWeather(
                      "b800477d63d7499991812851232603",
                      locations[selectedLocationIndex]);
                  final forecast = await getHourlyForecast(
                      "b800477d63d7499991812851232603",
                      locations[selectedLocationIndex]);
                  print(weather);
                  print(forecast);
                },
                child: Container(
                  color: Colors.green,
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Get Weather',
                    style: kh5,
                  ),
                ),
              ),
              // weatherConditionText == ""
              //     ? Container()
              //     : Image.network(weatherConditionText)
            ],
          ),
        ));
  }
}

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
            "b800477d63d7499991812851232603", locations[selectedLocationIndex]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<String>(
                  future: getWeatherImage(
                      "L38srwKsSIaA1JLWZb4fxxSkiz_IYnXkgW07I8flSU8",
                      "${snapshot.data!.conditionText} weather sky"),
                  builder: (context, weatherSnapshot) {
                    if (weatherSnapshot.connectionState ==
                            ConnectionState.done &&
                        weatherSnapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.all(20),
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
                                  flex: 5,
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
                                            fontSize: 18,
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
                color: Colors.green.shade900,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Calculating...',
                style: kh5,
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

class LocationChanger extends StatelessWidget {
  const LocationChanger({
    super.key,
    required this.selectedLocationIndex,
  });

  final int selectedLocationIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        showModalBottomSheet<void>(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            context: context,
            builder: (context) {
              return Container(
                height: 400,
                decoration: const BoxDecoration(
                    color: kScaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Choose Location',
                        style: kh4.copyWith(color: Colors.blueGrey.shade100),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LocationChip(
                        text: locations[selectedLocationIndex],
                        index: selectedLocationIndex,
                      ),
                      for (int i = 0; i < locations.length; i++)
                        (i != selectedLocationIndex)
                            ? InkWell(
                                onTap: () {
                                  Provider.of<LocationIndex>(context,
                                          listen: false)
                                      .setIndex(i);
                                  Navigator.pop(context);
                                },
                                child: LocationChip(
                                  text: locations[i],
                                  index: i,
                                ))
                            : Container()
                    ],
                  ),
                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            locations[Provider.of<LocationIndex>(context).selectedIndex],
            style: kh2,
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class LocationChip extends StatefulWidget {
  LocationChip({super.key, required this.text, required this.index});

  // bool isSelected;
  String text;
  int index;

  @override
  State<LocationChip> createState() => _LocationChipState();
}

class _LocationChipState extends State<LocationChip> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<LocationIndex>(context).selectedIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // color: currentIndex == widget.index
        //     ? kSecondaryColor
        //     : Colors.blueGrey.shade900,
        gradient: (currentIndex == widget.index)
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 78, 253, 151),
                  Color(0xff06C0B5),
                ],
              )
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: currentIndex == widget.index
                    ? Colors.white
                    : Colors.blueGrey.shade400,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == widget.index ? Colors.white : null,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: currentIndex == widget.index
                    ? Colors.white
                    : Colors.white30),
          ),
        ],
      ),
    );
  }
}
