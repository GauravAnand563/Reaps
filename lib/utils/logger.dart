import 'package:logger/logger.dart';

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(
    methodCount: 0, // number of method calls to be displayed
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 20, // width of the output
    colors: false, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false, // Should each log print contain a timestamp
    noBoxingByDefault: false, // show boxes for each log
    excludeBox: const {Level.verbose: false}, //hide box for specific logs
  ),
);
