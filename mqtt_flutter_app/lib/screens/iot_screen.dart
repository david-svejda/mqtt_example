import 'package:flutter/material.dart';

import '../devices/device.dart';
import '../services/mqtt_service.dart';

class IoTScreen extends StatefulWidget {
  final Duration healthRefreshInterval;

  const IoTScreen({
    super.key,
    this.healthRefreshInterval = const Duration(seconds: 10),
  });

  @override
  State<IoTScreen> createState() => _IoTScreenState();
}

class _IoTScreenState extends State<IoTScreen> {
  late MqttService mqttService;

  List<Device> devices = [];

  @override
  void initState() {
    super.initState();

    mqttService = MqttService(
      topicBase: 'iot/devices',
      subscribedTopic: 'iot/devices/#',
      onMessage: _onMessage,
    );
  }

  void _onMessage(Map<String, dynamic> message) {
    String deviceId = message['device_id'];
    String sensor = message['sensor'];
    double value = message['data'];

    // Add device if it does not exist
    bool found = true;
    Device device = devices.firstWhere(
      (item) => item.name == deviceId,
      orElse: () {
        found = false;
        return Device(deviceId);
      },
    );

    device.updateSensorValue(sensor, value);

    if (!found) {
      devices.add(device);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: mqttService.healthNotifier,
              builder: (context, status, _) {
                String text = "CONNECTING";
                IconData icon = Icons.warning_amber_rounded;
                Color color = Colors.orange;

                if (status.name == BrokerHealth.up.name) {
                  text = "UP";
                  icon = Icons.check_circle;
                  color = Colors.green;
                }
                if (status.name == BrokerHealth.down.name) {
                  text = "DOWN";
                  icon = Icons.error;
                  color = Colors.red;
                }

                return Row(
                  children: [
                    Text('Broker status: '),
                    const SizedBox(width: 12),
                    Expanded(child: Text(text)),
                    const SizedBox(width: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        icon,
                        key: ValueKey(icon),
                        color: color,
                        size: 32,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            Text('Devices: ${devices.length}'),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, item) {
                  return Text('${devices[item].name}: ${devices[item].sensors[0].name} - ${devices[item].sensors[0].value}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
