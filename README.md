# Project setup
Projekt obsahuje 3 moduly:

| Modul                | Jazyk  | Funkce                                                                                                         |
----------------------|--------|----------------------------------------------------------------------------------------------------------------
| mqtt_broker_docker   | -      | docker image mqtt broker(u) - https://hub.docker.com/_/eclipse-mosquitto                                       |
| mqtt_esp32_simulator | python | simulace mikrocontrolleru - připojí se na mqtt broker a publikuje zprávy                                       |
| mqtt_flutter_app     | dart   | multiplatformní implementace front-endu, připojí se na mqtt broker a čte-publikuje zprávy jednotlivým zařízením |

# Prerequisites
1. **Docker**
</br>Instalace popsaná na https://docs.docker.com/engine/install/
2. **Python**
</br> Instalace popsaná na https://www.python.org/downloads/
3. **Flutter**
</br>Instalace popsaná na https://flutter.dev/

# Running
1. Nastartuj MQTT broker v **mqtt_broker_docker** projektu
2. Nastartuj ESP32 simulator senzorů v **mqtt_esp32_simulator** projektu
3. Přidej testovací video do rtsp_server_docker/videos/test.mp4
4. Nastartuj RTSP server v **rtsp_server_docker** projektu
5. Nastartuj aplikaci v **mqtt_flutter_app** projektu