import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient createMqttClient(String broker, int port, String clientId) {
  final client = MqttBrowserClient(
    'ws://$broker:$port/mqtt',
    clientId,
  );
  client.port = port;
  client.websocketProtocols = ['mqtt'];

  print("Creating web socket connection: port $port");

  return client;
}