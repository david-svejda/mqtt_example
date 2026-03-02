import 'package:flutter/material.dart';

enum SensorType {
  temperature,
  smoke,
  camera,
  speaker,
}

abstract class Sensor {
  final String id;
  String name;
  final SensorType type;
  DateTime? lastUpdated;

  String? data;

  Sensor({required this.id, required this.type, this.name = '', this.lastUpdated});

  Widget buildWidget(BuildContext context);
}