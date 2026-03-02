import 'package:flutter/material.dart';
import 'sensor.dart';

class SmokeSensor extends Sensor {
  bool? smokeDetected;
  double? obscuration;

  SmokeSensor({
    required super.id,
    required super.name,
    super.lastUpdated,
    this.smokeDetected,
    this.obscuration,
  }) : super(type: SensorType.smoke);

  @override
  Widget buildWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.local_fire_department,),
        ),
        Expanded(
          flex: 6,
          child: Text(name),
        ),
        Expanded(
          flex: 3,
          child: Text('$obscuration'),
        ),
      ],
    );
  }
}
