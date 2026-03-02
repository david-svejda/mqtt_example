import random
from sensor import Sensor


class TemperatureSensor(Sensor):
    def __init__(self, sensor_id, name):
        super().__init__(sensor_id, name, "temperature")
        self.temperature = round(random.uniform(18.0, 35.0), 2)
        self.unit = "C"

    def generate_data(self):
        self.temperature = self.generate_random_value(self.temperature, 18.0, 35.0, 0.5)

        return {
            "temperature": round(self.temperature, 2),
            "unit": self.unit
        }