import random
import time
from abc import ABC, abstractmethod

class Sensor(ABC):
    def __init__(self, sensor_id, name, sensor_type):
        self.id = sensor_id
        self.name = name
        self.type = sensor_type

    @abstractmethod
    def generate_data(self):
        pass

    def generate_random_value(self, actual_value, low, high, spread) -> float:
        value_change = 0
        # simulate if the change is monitored
        if random.choice([True, False]):
            value_change = round(random.uniform(-spread, spread), 2)

        # boundaries of the value
        if (actual_value + value_change) > high or (actual_value + value_change) < low:
            value_change = 0

        return actual_value + value_change

    def payload(self):
        return {
            "sensor_name": self.name,
            "sensor_id": self.id,
            "sensor_type": self.type,
            "timestamp": int(time.time()),
            "data": self.generate_data()
        }