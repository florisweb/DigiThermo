#include "connectionManager.h";
//#include "time.h";
//#include <array>;
#include <DHT.h>
#include <DHT_U.h>



const char* ssid = "";
const char* password = "";
const String deviceId = "DigiThermo";
const String deviceKey = "";

connectionManager ConnectionManager;


float targetTempValue = 19;


// DHT Sensor
float temperatureValue = 0;
float humidityValue = 0;
const int DHT11SensorPin = 33;
DHT_Unified dht(DHT11SensorPin, DHT11);


// Get the time
//const char* ntpServer = "pool.ntp.org";
//const long  gmtOffset_sec = 3600;
//const int   daylightOffset_sec = 3600;

// Steppermotor
#define dirPin 25
#define stepPin 27
#define stepsPerRevolution 200

#define maxRevolutions = 6.7;


void onMessage(DynamicJsonDocument message) {
  String error = message["error"];
  String packetType = message["type"];

  Serial.print("[OnMessage] Error: ");
  Serial.println(error);
  Serial.print("[OnMessage] type: ");
  Serial.println(packetType);

  if (packetType == "bounceTo") {
    float revolutions = message["data"];
    turn(revolutions, 0.5);
    delay(1000);
    turn(-revolutions, 0.5);
  } else if (packetType == "setTargetTemp") {
    targetTempValue = message["data"];
  }
}




void setup() {
  Serial.begin(115200);

  Serial.setDebugOutput(true);

  delay(1000);
  Serial.println("Waking up...");
  delay(1000);

  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  digitalWrite(stepPin, LOW);

  ConnectionManager.setup(ssid, password, deviceId, deviceKey, &onMessage);
  //  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);


  Serial.println("Setting up DHT...");
  dht.begin();
  // Print temperature sensor details.
  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  Serial.println(F("------------------------------------"));
  Serial.println(F("Temperature Sensor"));
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("°C"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("°C"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("°C"));
  Serial.println(F("------------------------------------"));

  // Print humidity sensor details.
  dht.humidity().getSensor(&sensor);
  Serial.println(F("Humidity Sensor"));
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("%"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("%"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("%"));
  Serial.println(F("------------------------------------"));

  Serial.println("Set up.");
}

void loop() {
  ConnectionManager.loop();

  if (millis() % (1000 * 30) == 0)
  {
    readTempAndHumidity();
    sendCurState();
  }
}





void sendCurState() {
  readTempAndHumidity();

  String dataString = "{\"type\": \"curState\", \"data\": {\"temperature\": " + String(temperatureValue) +
                      ", \"humidity\":" + String(humidityValue) +
                      ", \"targetTemp\":" + String(targetTempValue) +
                      "}}";

  Serial.println(dataString);
  ConnectionManager.send(dataString);
}


void readTempAndHumidity() {
  sensors_event_t event;
  dht.temperature().getEvent(&event);
  if (isnan(event.temperature)) {
    temperatureValue = -1;
  }
  else {
    temperatureValue = event.temperature;
  }

  dht.humidity().getEvent(&event);
  if (isnan(event.relative_humidity)) {
    humidityValue = -1;
  }
  else {
    humidityValue = event.relative_humidity;
  }
}




void turn(float _revolutions, float _revsPerSec) {
  if (_revolutions < 0) {
    digitalWrite(dirPin, LOW);
  } else {
    digitalWrite(dirPin, HIGH);
  }

  int stepDelay = _revsPerSec * 500000 / stepsPerRevolution;
  for (int i = 0; i < abs(_revolutions) * stepsPerRevolution; i++) {
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(stepDelay);
  }
}
