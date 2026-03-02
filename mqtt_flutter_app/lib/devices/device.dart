import '../sensors/sensor_factory.dart';
import '../sensors/sensor.dart';

class Device {
  late final String id;
  late final String name;

  List<Sensor> _sensors = [];

  Device(this.id, this.name);

  List<Sensor> get sensors => _sensors;

  void updateSensorValue(Map<String, dynamic> message) {
    Sensor sensor = SensorFactory.fromJson(message);

    print("Device $name has ${_sensors.length} sensors.");

    int index = _sensors.indexWhere((item) => item.id == sensor.id);
    print('Update sensor value: ${message['sensor_type']} : index: $index : sensor: ${sensor.name} - ${sensor.id}');
    if (index != -1) {
      print("Sensor ${sensor.name} found");
      _sensors[index] = sensor;
    } else {
      print("Sensor ${sensor.name} not found");
      _sensors.add(sensor);
    }
    print("Device: $name - Sensors: ${_sensors.length}");
  }
}
