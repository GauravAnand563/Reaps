import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reaps/predictedWeather.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'historyPage.dart';
import 'locationChanger.dart';
import 'services.dart';
import 'states.dart';

import 'currentWeather.dart';
import 'frostedGlassButton.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

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
        ChangeNotifierProvider(create: (context) => IntervalChooserState())
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.location_pin,
                    color: kSecondaryColor,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  LocationChanger(selectedLocationIndex: selectedLocationIndex),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryPage()));
                    },
                    child: CircleAvatar(
                      backgroundColor: kSecondaryColor,
                      child: Icon(Icons.history),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
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
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Predicted Weather',
                  style: GoogleFonts.montserrat(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const IntervalChooser(),
              SizedBox(
                height: 10,
              ),
              const PredictedWeatherWidget(),
              // weatherConditionText == ""
              //     ? Container()
              //     : Image.network(weatherConditionText)
            ],
          ),
        ));
  }
}
