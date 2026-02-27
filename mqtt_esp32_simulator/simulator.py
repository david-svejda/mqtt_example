import threading
import time
from typing import List

from device import Device

"""BROKER configuration"""
BROKER_HOST = "localhost"
BROKER_PORT = 1883
BROKER_BASE_TOPIC = "iot/devices"
BROKER_CONNECTION_RETRIES = 3

"""DEVICE configuration"""
DEVICE_COUNT = 2            # number of simulated devices
SUBSCRIBE_INTERVAL = 2      # interval in seconds for reading from the queue

class Simulator:
    def __init__(self) -> None:
        print("🚀 Starting IoT device simulator...")

        self.threads: List[threading.Thread] = []
        for i in range(1, DEVICE_COUNT + 1):
            device_id = f"device_{i}"
            device = Device(device_id, BROKER_HOST, BROKER_PORT, BROKER_BASE_TOPIC, BROKER_CONNECTION_RETRIES)
            t = threading.Thread(target=device.simulate)
            t.daemon = True
            self.threads.append(t)
            t.start()

    def run(self):
        threads_are_running = True

        while threads_are_running:
            running_threads_count = 0
            for i in range(0, len(self.threads)):
                if self.threads[i].is_alive():
                    running_threads_count += 1

            if running_threads_count == 0:
                threads_are_running = False
            else:
                time.sleep(1)