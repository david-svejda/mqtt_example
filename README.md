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