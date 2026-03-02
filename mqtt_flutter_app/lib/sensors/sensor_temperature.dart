import 'package:flutter/material.dart';
import 'sensor.dart';

class TemperatureSensor extends Sensor {
  double? temperatureCelsius;

  TemperatureSensor({
    required super.id,
    required super.name,
    super.lastUpdated,
    this.temperatureCelsius,
  }) : super(type: SensorType.temperature);

  @override
  Widget buildWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.thermostat,),
        ),
        Expanded(
          flex: 6,
          child: Text(name),
        ),
        Expanded(
          flex: 3,
          child: Text('$temperatureCelsius °C'),
        ),
      ],
    );
  }
}
