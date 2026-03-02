import 'sensor.dart';
import 'sensor_temperature.dart';
import 'sensor_smoke.dart';

class SensorFactory {
  static Sensor fromJson(Map<String, dynamic> json) {
    final type = SensorType.values.byName(json['sensor_type']);
    final DateTime lastUpdate = DateTime.fromMicrosecondsSinceEpoch(1000 * (json['timestamp'] as num).toInt(), isUtc: true);

    switch (type) {
      case SensorType.temperature:
        return TemperatureSensor(
          id: json['sensor_id'],
          name: json['sensor_name'],
          lastUpdated: lastUpdate,
          temperatureCelsius: json['data']['temperature'],
        );

      case SensorType.smoke:
        return SmokeSensor(
          id: json['sensor_id'],
          name: json['sensor_name'],
          lastUpdated: lastUpdate,
          smokeDetected: json['data']['smoke_detected'],
          obscuration: json['data']['obscuration'],
        );

      default:
        throw UnsupportedError("Unknown sensor type");
    }
  }
}