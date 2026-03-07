import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';

import 'screens/test_screen.dart';
import 'screens/iot_screen.dart';

const APP_NAME = "MQTT managing app";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      //home: const IoTScreen(),
      home: const TestScreen(),
    );
  }
}
