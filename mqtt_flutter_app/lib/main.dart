import 'package:flutter/material.dart';

import 'screens/iot_screen.dart';

const APP_NAME = "MQTT managing app";

void main() {
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
      home: const IoTScreen(),
    );
  }
}
