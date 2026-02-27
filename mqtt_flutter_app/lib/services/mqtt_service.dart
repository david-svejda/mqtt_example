import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_client_factory.dart';

enum BrokerHealth { up, connecting, down }

class MqttService {
  late MqttClient client;
  late final String broker;
  late final String topicBase;
  late final String subscribedTopic;
  final Function(Map<String, dynamic>)? onMessage;

  bool _isConnecting = false;
  Timer? healthTimer;

  ValueNotifier<BrokerHealth> healthNotifier = ValueNotifier<BrokerHealth>(
    BrokerHealth.connecting,
  );

  MqttService({
    this.broker = 'localhost',
    this.topicBase = 'iot/devices',
    this.subscribedTopic = 'iot/devices/#',
    this.onMessage,
  }) {
    client = createMqttClient(broker, kIsWeb ? 8083 : 1883, 'flutter_client_1');

    client.keepAlivePeriod = 20;
    client.autoReconnect = true;
    client.resubscribeOnAutoReconnect = true;

    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onAutoReconnect = () => print("🔁 Auto reconnecting...");
    client.onAutoReconnected = () => print("✅ Reconnected");

    _connect();
    _startHealthCheck();
  }

  Future<void> _connect() async {
    if (_isConnecting) return; // prevent parallel attempts
    _isConnecting = true;

    try {
      print("🔁 Trying to reconnect...");
      await client.connect();
    } catch (e) {
      print("Reconnect failed: $e");
    } finally {
      _isConnecting = false;
      getHealth();
    }
  }

  void _startHealthCheck() {
    healthTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (getHealth() != BrokerHealth.up &&
          getHealth() != BrokerHealth.connecting) {
        print("💔 Broker not reachable");
        await _connect();
      }
    });
  }

  void _onConnected() {
    print("✅ Connected to broker");

    client.subscribe(subscribedTopic, MqttQos.atLeastOnce);
    client.updates!.listen((events) => _process(events));
  }

  Map<String, dynamic> _process(List<MqttReceivedMessage<MqttMessage>> events) {
    MqttPublishMessage message = events[0].payload as MqttPublishMessage;
    Map<String, dynamic> data = jsonDecode(
      MqttPublishPayload.bytesToStringAsString(message.payload.message),
    );

    onMessage?.call(data);

    return data;
  }

  void _onDisconnected() {
    print("❌ Disconnected from broker");
  }

  BrokerHealth getHealth() {
    final state = client.connectionStatus?.state;
    late BrokerHealth health;

    if (state == MqttConnectionState.connected) {
      health = BrokerHealth.up;
    } else if (state == MqttConnectionState.connecting) {
      health = BrokerHealth.connecting;
    } else {
      health = BrokerHealth.down;
    }

    if (healthNotifier.value != health) {
      healthNotifier.value = health;
    }
    return health;
  }
}
