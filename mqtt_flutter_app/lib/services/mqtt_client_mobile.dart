import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String broker, int port, String clientId) {
  final client = MqttServerClient(broker, clientId);
  client.port = port;

  print("Creating mqtt connection: port $port");

  return client;
}