from sensor_smoke import SmokeSensor
from sensor_temperature import TemperatureSensor

class SensorFactory:
    @staticmethod
    def create(sensor_type, sensor_id, name):
        if sensor_type == "temperature":
            return TemperatureSensor(sensor_id, name)
        elif sensor_type == "smoke":
            return SmokeSensor(sensor_id, name)
        else:
            raise ValueError(f"Unknown sensor type: {sensor_type}")