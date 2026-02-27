import 'sensor.dart';

class Device {
  late final String name;
  List<Sensor> _sensors = [];

  Device(this.name);

  void addSensor(String name) {
    Sensor sensor = Sensor(name);

    _sensors.add(sensor);
  }

  List<Sensor> get sensors => _sensors;

  void updateSensorValue(String name, double value) {
    Sensor sensor = Sensor(name);
    bool found = false;
    for (Sensor sensorItem in _sensors) {
      if (sensorItem.name == name) {
        found = true;
        sensor = sensorItem;
        break;
      }
    }
    if (!found) {
      _sensors.add(sensor);
    }

    sensor.value = value;
  }
}