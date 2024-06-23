#include <AccelStepper.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <ArduinoWebsockets.h>
#include <vector>
#include <WiFiManager.h>
#include <ESP_EEPROM.h>

using namespace std;

#define EEPROM_SIZE 50

int lastPos;
int is_turn;

const char* WIFI_SSID = "Ty King";
const char* WIFI_PASS = "07092003";

const String CODE_SYSTEM = "Pbl50001"; // Mỗi ESP8266 trong hệ thống sẽ có 1 mã code

#if 1
// Khi kết nối trong môi trường local
const char* websocket_server_host = "192.168.154.96";
const uint16_t websocket_server_port = 8999;
#endif

#if 0 
// Khi kết nối trong môi trường public
const char* websocket_server_url = "https://hrl4vkc2-8999.asse.devtunnels.ms/esp8266";
#endif 

// Địa chỉ server detect fire
String URL_SERVER_DETECT = "http://192.168.2.49:6868/";

using namespace websockets;
WebsocketsClient client;

#define BUZZER_PIN 13 //D7

// ULN2003 Motor Driver Pins
#define IN1 5 // D1
#define IN2 4 // D2
#define IN3 14 // D5
#define IN4 12 // D6

// Vị trí của 4 cảm biến
int station1 = 0; 
int station2 = 1024;
int station3 = 2048;
int station4 = 3072;
int station1_2 = 512;
int station2_3 = 1536;
int station3_4 = 2560;
int station4_1 = 3584;

// Định nghĩa các loại động cơ
const int stepsPerRevolution = 2048;
AccelStepper myStepper(AccelStepper::HALF4WIRE, IN1, IN3, IN2, IN4);

// Đối tượng Wifi Client
WiFiClient wifiClient;

void onEventsCallback(WebsocketsEvent event, String data) {
  if(event == WebsocketsEvent::ConnectionOpened) {
      Serial.println("Connnection Opened");
  } else if(event == WebsocketsEvent::ConnectionClosed) {
      Serial.println("Connnection Closed");
      ESP.restart();
  } else if(event == WebsocketsEvent::GotPing) {
      Serial.println("Got a Ping!");
  } else if(event == WebsocketsEvent::GotPong) {
      Serial.println("Got a Pong!");
  }
}

void onMessageCallback(WebsocketsMessage message) {
  Serial.println("Got Message: ");
  // Serial.println(message.data());
  // Kiểm tra nội dung của thông điệp
  String msg = message.data(); // Lấy thông điệp nhận được
  // Kiểm tra nội dung thông điệp để xác định có phải là lệnh điều khiển servo
  if (msg.startsWith("stepper: ")) {    
    Serial.print("Location motor before moving: ");
    Serial.println(myStepper.currentPosition());
    int step = msg.substring(9).toInt();
    if(myStepper.distanceToGo() == 0)
    {
      myStepper.move(step);
      lastPos = myStepper.currentPosition();
      EEPROM.put(0, lastPos + step);
      EEPROM.commit();

      is_turn = 1;
      EEPROM.put(10, is_turn);
      EEPROM.commit();

      int res, res_2;
      EEPROM.get(0, res);
      Serial.print("Get from EEPROM res1: ");
      Serial.println(res);

      EEPROM.get(10, res_2);
      Serial.print("Get from EEPROM res2: ");
      Serial.println(res_2);
    }
    myStepper.currentPosition() + step;
    Serial.print("Location motor after moving: ");
    Serial.println(myStepper.currentPosition() + step);

    checkCurrentPos();

  } 

  else if (msg.startsWith("turnstp: ")) {    
    Serial.print("Location motor before moving: ");
    Serial.println(myStepper.currentPosition());
    int step = msg.substring(9).toInt();
    Serial.println(step);
    if(myStepper.distanceToGo() == 0)
    {
      myStepper.move(step);
      lastPos = myStepper.currentPosition();
      EEPROM.put(0, lastPos + step);
      EEPROM.commit();

      is_turn = 1;
      EEPROM.put(10, is_turn);
      EEPROM.commit();

      int res, res_2;
      EEPROM.get(0, res);
      Serial.print("Get from EEPROM res1: ");
      Serial.println(res);

      EEPROM.get(10, res_2);
      Serial.print("Get from EEPROM res2: ");
      Serial.println(res_2);
    }
    myStepper.currentPosition() + step;
    Serial.print("Location motor after moving: ");
    Serial.println(myStepper.currentPosition() + step);

    checkCurrentPos();

    client.send("Done");
  } 


  else if (message.data() == "TURN ON BUZZER") {
    tone(BUZZER_PIN, 500);
    Serial.println("BUZZER turned on");
  }
  else if (message.data() == "TURN OFF BUZZER") {
    noTone(BUZZER_PIN);
    Serial.println("BUZZER turned on");
  }

  else {
    const char* json = msg.c_str();
    StaticJsonDocument<200> doc;  // Tạo một đối tượng JSON Document với kích thước đủ để chứa dữ liệu

    DeserializationError error = deserializeJson(doc, json);  // Phân tích cú pháp JSON
    if (error) {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.c_str());
        return;
    }
    // Tính độ dài của mảng JSON
    size_t count = doc.size();  // Lấy số lượng phần tử trong mảng JSON
    Serial.print("Number of IDs in JSON: ");
    Serial.println(count);
    if (count == 1) {
      detectFire();
#if 1
      const char* input = doc[0];
      if (strcmp(input, "ESP8266_1") == 0) {
        vector<String> order = {"ESP8266_1", "ESP8266_4", "ESP8266_1", "ESP8266_2", "ESP8266_1"};
        for (const String& station : order) {
          Serial.print("Location now before warning is: ");
          Serial.println(myStepper.currentPosition());

          moveToPosition(station);

          Serial.print("Location now after warning is: ");
          Serial.println(myStepper.currentPosition());
        }
      }

      else if (strcmp(input, "ESP8266_2") == 0) {
        vector<String> order = {"ESP8266_2", "ESP8266_1", "ESP8266_2", "ESP8266_3", "ESP8266_2"};
        for (const auto& station : order) {
          moveToPosition(station);

        }
      } else if (strcmp(input, "ESP8266_3") == 0) {
        vector<String> order = {"ESP8266_3", "ESP8266_2", "ESP8266_3", "ESP8266_4", "ESP8266_3"};
        for (const auto& station : order) {
          moveToPosition(station);

        }
      } else if (strcmp(input, "ESP8266_4") == 0) {
        vector<String> order = {"ESP8266_4", "ESP8266_3", "ESP8266_4", "ESP8266_1", "ESP8266_4"};
        for (const auto& station : order) {
          moveToPosition(station);

        }
      }
#endif
    }

    else if (count == 2) {
      detectFire();
      const char* input1 = doc[0];
      const char* input2 = doc[1];
      String s1(input1);
      String s2(input2);

      if ((s1 == "ESP8266_1" && s2 == "ESP8266_2") || (s1 == "ESP8266_2" && s2 == "ESP8266_1")) {
        vector<String> order = {"ESP8266_1", "ESP8266_4", "ESP8266_1", "ESP8266_2", "ESP8266_3", "ESP8266_2", "station1_2"};
        for (const auto& station : order) {
          moveToPosition(station);
        }
      }
      else if ((s1 == "ESP8266_2" && s2 == "ESP8266_3") || (s1 == "ESP8266_3" && s2 == "ESP8266_2")) {
        vector<String> order = {"ESP8266_2", "ESP8266_1", "ESP8266_2", "ESP8266_3", "ESP8266_4", "ESP8266_3", "station2_3"};
        for (const auto& station : order) {
          moveToPosition(station);
        }
      }
      else if ((s1 == "ESP8266_3" && s2 == "ESP8266_4") || (s1 == "ESP8266_4" && s2 == "ESP8266_3")) {
        vector<String> order = {"ESP8266_3", "ESP8266_2", "ESP8266_3", "ESP8266_4", "ESP8266_1", "ESP8266_4", "station3_4"};
        for (const auto& station : order) {
          moveToPosition(station);
        }
      }
      else if ((s1 == "ESP8266_4" && s2 == "ESP8266_1") || (s1 == "ESP8266_1" && s2 == "ESP8266_4")) {
        vector<String> order = {"ESP8266_4", "ESP8266_3", "ESP8266_4", "ESP8266_1", "ESP8266_2", "ESP8266_1", "station4_1"};
        for (const auto& station : order) {
          moveToPosition(station);
        }
      }
      else {
        rotateFullCircle();
      }
    }
    else if (count == 3 || count == 4) {
      detectFire();
      rotateFullCircle();
    }
    
  }
}
void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("Program begun!");
  pinMode(BUZZER_PIN, OUTPUT);

  EEPROM.begin(EEPROM_SIZE);
  int is_turned;
  EEPROM.get(10, is_turned);
  Serial.print("is_turned: ");
  Serial.println(is_turned);

  int lastedPos;
  EEPROM.get(0, lastedPos);
  Serial.print("Lasted position: ");
  Serial.println(lastedPos);

  int turn = -(int)lastedPos;

  myStepper.setMaxSpeed(1000);
  myStepper.setAcceleration(200);

  myStepper.moveTo(turn);
  while (myStepper.distanceToGo() != 0 && is_turned == 1) {
    myStepper.run();
    Serial.print(".");
  }
  myStepper.setCurrentPosition(0);

  EEPROM.put(0, lastedPos);
  EEPROM.commit();

  EEPROM.put(10, 0);
  EEPROM.commit();

  int myVar;
  EEPROM.get(0, myVar);
  Serial.println(myVar);
  //---------------------------
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
#if 1 
  // Sử dụng thư viện truyền thống để kết nối wifi
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.print("\n");
#endif
#if 0 
  // Sử dụng thư viện để kết nối tự động 
  WiFiManager wm;
  bool res;
  res = wm.autoConnect("AutoConnectAP"); // password protected ap

  if(!res) 
      Serial.println("Failed to connect");
  else 
      Serial.println("connected...yeey");
#endif
  Serial.println("Program Begun");
  Serial.print("Waiting for connect to server");


  // Setup Callbacks
  client.onMessage(onMessageCallback);
  client.onEvent(onEventsCallback);
#if 0
  // Connect to server
  while(!client.connect(websocket_server_url)) {
    Serial.print(".");
    delay(500);
  }
#endif
#if 1
  while(!client.connect(websocket_server_host, websocket_server_port, "/esp8266")) {
    Serial.print(".");
    delay(500);
  }
#endif
  
  // Send a ping
  client.ping();
  client.send(CODE_SYSTEM);

}

void loop() {
  client.poll();
  myStepper.run(); 
}


void detectFire() {
  HTTPClient http;
  http.begin(wifiClient, URL_SERVER_DETECT + "detect_fire?id=" + CODE_SYSTEM);
  int httpCode = http.GET();
  if (httpCode == HTTP_CODE_OK) {
    Serial.println("Detecting");
  } else {
    Serial.println("Error To Detect");
  }
  http.end();
}

void checkCurrentPos() {
  // Kiểm tra và reset currentPosition
  if (abs(myStepper.currentPosition()) >= 4096) {
    myStepper.setCurrentPosition(0);
  }
}

int moveToPosition(String device_id) {
  int targetPosition;

  if (device_id == "ESP8266_1") {
      targetPosition = station1;
  } else if (device_id == "ESP8266_2") {
      targetPosition = station2;
  } else if (device_id == "ESP8266_3") {
      targetPosition = station3;
  } else if (device_id == "ESP8266_4") {
      targetPosition = station4;
  } else if (device_id == "station1_2") {
      targetPosition = station1_2;
  } else if (device_id == "station2_3") {
      targetPosition = station2_3;
  } else if (device_id == "station3_4") {
      targetPosition = station3_4;
  } else if (device_id == "station4_1") {
      targetPosition = station4_1;
  }else {
      Serial.println("Invalid device ID");
      return -1; // Trả về -1 nếu device_id không hợp lệ
  }

  int currentPosition = myStepper.currentPosition();
  int directDistance = targetPosition - currentPosition;
  int reverseDistance = (targetPosition >= currentPosition) ? (4096 - targetPosition + currentPosition) : (currentPosition - targetPosition);

  // Chọn khoảng cách ngắn nhất
  if (abs(directDistance) < abs(reverseDistance)) {
    myStepper.moveTo(currentPosition + directDistance);
    int var = currentPosition + directDistance;
    EEPROM.put(0, var);
    EEPROM.commit();

    EEPROM.put(10, 1);
    EEPROM.commit();
  } else {
    myStepper.moveTo(currentPosition - reverseDistance);
    int var = currentPosition - reverseDistance;
    EEPROM.put(0, var);
    EEPROM.commit(); // Quay ngược

    EEPROM.put(10, 1);
    EEPROM.commit();
  }

  while (myStepper.distanceToGo() != 0) {
    myStepper.run();
    Serial.print("Current Position: ");
    Serial.println(myStepper.currentPosition());
  }

  // Kiểm tra và reset currentPosition
  checkCurrentPos();

  return 0; // Trả về 0 nếu hoàn thành thành công
}


void rotateFullCircle() {
  Serial.println("Quay 1 theo chiều kim đồng hồ");
  myStepper.move(4096);
  while (myStepper.distanceToGo() != 0) {
    myStepper.run();
    Serial.print("Current Position: ");
    Serial.println(myStepper.currentPosition());
  }

  Serial.println("Quay 1 theo ngược chiều kim đồng hồ");
  myStepper.move(-4096);
  while (myStepper.distanceToGo() != 0) {
    myStepper.run();
    Serial.print("Current Position: ");
    Serial.println(myStepper.currentPosition());
  }
  checkCurrentPos();
}
