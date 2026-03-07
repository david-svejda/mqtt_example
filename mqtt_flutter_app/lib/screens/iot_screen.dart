import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;

  List<Device> devices = [];

  @override
  void initState() {
    super.initState();

    mqttService = MqttService(
      topicBase: 'iot/devices',
      subscribedTopic: 'iot/devices/#',
      onMessage: _onMessage,
    );

    String url = "http://localhost:8888/stream/index.m3u8";
    print("Running RTSP stream on $url");
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.initialize().then((_) {
      print("Video controller is initialized");

      _controller.setVolume(kIsWeb ? 0.0 : 1.0);

      // small delay ensures first frame renders
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.play();
        setState(() {
          print("START PLAYING");
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMessage(Map<String, dynamic> message) {
    String deviceId = message['device_id'];
    String deviceName = message['device_name'];

    // Add device if it does not exist
    int index = devices.indexWhere((item) => item.id == deviceId);
    if (index != -1) {
      print("Device $deviceName found.");

      devices[index].updateSensorValue(message);
    } else {
      print("Device $deviceName not found.");

      Device device = Device(deviceId, deviceName);
      device.updateSensorValue(message);
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(devices[item].name),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: devices[item].sensors.length,
                          itemBuilder: (BuildContext context, int index) {
                            return devices[item].sensors[index].buildWidget(
                              context,
                            );
                            //return Text('sensor ${devices[item].sensors[index].name}');
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                // Use [Video] widget to display video output.
                child: VideoPlayer(_controller),
                /*
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Text(
                        '${_controller.value.isInitialized}',
                      ),
                 */
              ),
            ),
          ],
        ),
      ),
    );
  }
}
