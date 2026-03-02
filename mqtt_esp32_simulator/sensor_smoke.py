import random
from sensor import Sensor

class SmokeSensor(Sensor):
    def __init__(self, sensor_id, name):
        super().__init__(sensor_id, name, "smoke")
        self.smoke_detected = False
        self.obscuration = round(random.uniform(0.0, 0.02), 2)

    def generate_data(self):
        self.obscuration = self.generate_random_value(self.obscuration, 0.0, 10.0, 0.05)
        self.smoke_detected = True if self.obscuration > 0.3 else False

        return {
            "smoke_detected": self.smoke_detected,
            "obscuration": round(self.obscuration, 2),
        }