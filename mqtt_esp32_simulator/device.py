import time
import json
import random
import threading
import paho.mqtt.client as mqtt
from paho.mqtt.enums import CallbackAPIVersion, MQTTErrorCode

"""DEVICE configuration"""
PUBLISH_INTERVAL = 2        # interval in seconds for reading sensors and publishing value
SUBSCRIBE_INTERVAL = 2      # interval in seconds for reading from the queue
RECONNECT_INTERVAL = 5      # interval for reconnecting to a queue in case of failure

class Device:
    def __init__(self, name: str, broker_host: str, broker_port: int, broker_base_topic: str, broker_connection_retries: int) -> None:
        self.name = name
        self.broker_host = broker_host
        self.broker_port = broker_port
        self.broker_base_topic = broker_base_topic
        self.broker_connection_retries = broker_connection_retries

        self.connected_event = threading.Event()

    def on_connect(self, client, userdata, connect_flags, reason_code, properties):
        if reason_code == 0:
            print(f"✅ Simulator of device {self.name} connected to MQTT broker")
            client.subscribe(f"{self.broker_base_topic}/{self.name}/command")
            self.connected_event.set()
        else:
            print("❌ Connection failed with code", reason_code)
            self.connected_event.clear()

    def on_disconnect(self, client, userdata, disconnect_flags, reason_code, properties):
        print("🔌 Simulator disconnected")
        self.connected_event.clear()

    def on_message(self, client, userdata, msg):
        print(f"📥 {self.name} <- {msg.topic}: {msg.payload.decode()}")

    def simulate(self) -> None:
        print(f"🚀 Starting device {self.name} ...")

        topic = f"{self.broker_base_topic}/{self.name}/telemetry"
        value = round(random.uniform(18.0, 35.0), 2)

        client = mqtt.Client(client_id=f"sim_{self.name}", callback_api_version=CallbackAPIVersion.VERSION2)
        client.on_connect = self.on_connect
        client.on_disconnect = self.on_disconnect
        client.on_message = self.on_message

        retries = 0
        while not self.connected_event.is_set() and retries < self.broker_connection_retries:
            try:
                client.connect(self.broker_host, self.broker_port, 60)
                client.loop_start()

            except Exception as e:
                print(f"{self.name}: MQTT connection error: ", e)

            retries += 1
            if retries < self.broker_connection_retries:
                time.sleep(RECONNECT_INTERVAL)

        while True:
            if self.connected_event.is_set():
                value_change = random.randint(0, 1)
                value_change = round(random.uniform(-0.5, 0.5), 2) if value_change > 0 else 0
                if (value + value_change) > 35.0 or (value + value_change) < 18.0:
                    value_change = 0
                else:
                    value += value_change

                payload = {
                    "device_id": self.name,
                    "timestamp": int(time.time()),
                    "sensor": "temperature",
                    "data": round(value, 2),
                    "status": "STABLE" if value_change == 0 else "CHANGE"
                }

                client.publish(topic, json.dumps(payload), qos=1)
                print(f"📤 {self.name} -> {topic}: {payload}")

            time.sleep(PUBLISH_INTERVAL)