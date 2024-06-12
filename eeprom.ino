#include <AccelStepper.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <ArduinoWebsockets.h>
#include <vector>
#include <WiFiManager.h>

#define EEPROM_SIZE 12

using namespace std;

const char* WIFI_SSID = "pthanhNgan1331";
const char* WIFI_PASS = "1highbarforfive!";

const String CODE_SYSTEM = "Pbl50001"; // Mỗi ESP8266 trong hệ thống sẽ có 1 mã code

// Địa chỉ server NodeJS
const char* websocket_server_url = "https://hrl4vkc2-8989.asse.devtunnels.ms/";

// Địa chỉ server detect fire
String URL_SERVER_DETECT = "http://192.168.1.3:6868/";

using namespace websockets;
WebsocketsClient client;

#define servoPin 5 // GPIO 5
// ULN2003 Motor Driver Pins
#define IN1 5
#define IN2 4
#define IN3 14
#define IN4 12

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
Servo myservo; // Dùng để điều khiển hướng lên xuống

// Dữ liệu từ các ESP8266 xung quanh
String status = "";
int value = 0;

// Đối tượng Wifi Client
WiFiClient wifiClient;

void onEventsCallback(WebsocketsEvent event, String data) {
  if(event == WebsocketsEvent::ConnectionOpened) {
      Serial.println("Connnection Opened");
  } else if(event == WebsocketsEvent::ConnectionClosed) {
      Serial.println("Connnection Closed");
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
  if (msg.startsWith("servo: ")) {
    int pos = msg.substring(7).toInt(); 
    myservo.write(pos);
    Serial.print("Servo position set to: ");
    Serial.println(pos);
  } 
  else if (msg.startsWith("stepper: ")) {    
    Serial.print("Location motor before moving: ");
    Serial.println(myStepper.currentPosition());
    int step = msg.substring(9).toInt();
    if(myStepper.distanceToGo() == 0)
    {
      myStepper.move(step);
    }
    myStepper.currentPosition() + step;
    Serial.print("Location motor after moving: ");
    Serial.println(myStepper.currentPosition() + step);

    checkCurrentPos();

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
      const char* input = doc[0];
      if (strcmp(input, "ESP8266_1") == 0) {
        vector<String> order = {"ESP8266_1", "ESP8266_4", "ESP8266_1", "ESP8266_2", "ESP8266_1"};
        for (const String& station : order) {
          Serial.print("Location now before warning is: ");
          Serial.println(myStepper.currentPosition());

          moveToPosition(station);
          EEPROM.put(add_lastPos, lastPos);

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
    }

    else if (count == 2) {
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
      rotateFullCircle();
    }
    
  }
}

int add_lastPos = 0;
int lastPos;

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("Program begun!");

  EEPROM.begin(EEPROM_SIZE);
  
  EPPROM.get(add_lastPos, lastPos);

  // Cấu hình các chân của động cơ
  myservo.attach(servoPin); 

  myStepper.setMaxSpeed(1000);
  myStepper.setAcceleration(200);
  myStepper.moveTo(-lastPos);
  EPPROM.PUT(add_lastPos, lastPos)
  myStepper.setCurrentPosition(0);
  //---------------------------
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFiManager wm;
  bool res;
  res = wm.autoConnect("AutoConnectAP"); // password protected ap

  if(!res) 
      Serial.println("Failed to connect");
  else 
      Serial.println("connected...yeey :)");
  // Setup Callbacks
  client.onMessage(onMessageCallback);
  client.onEvent(onEventsCallback);

  // Connect to server
  while(!client.connect(websocket_server_url)) {
    Serial.print("Connection failed");
    delay(500);
  }
  
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
  http.begin(wifiClient, URL_SERVER_DETECT + "detect_fire");
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
  } else {
    myStepper.moveTo(currentPosition - reverseDistance); // Quay ngược
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
