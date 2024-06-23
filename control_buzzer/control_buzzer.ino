#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
#include <ArduinoWebsockets.h>
#include <WiFiManager.h>

#define BUZZER_PIN 14 //GPIO 12

const char* WIFI_SSID = "Ty King";
const char* WIFI_PASS = "07092003";

const String CODE_SYSTEM = "Pbl50001"; // Mỗi ESP32Cam trong hệ thống sẽ có 1 mã code

#if 1
// Khi kết nối trong môi trường local
const char* websocket_server_host = "192.168.154.96";
const uint16_t websocket_server_port = 8999; 
#endif

#if 0 
// Khi kết nối trong môi trường public
const char* websocket_server_url = "wss://hrl4vkc2-8999.asse.devtunnels.ms/sendImage";
#endif 

using namespace websockets;
WebsocketsClient client;

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
  Serial.print("Got Message: ");
  Serial.println(message.data());
  String msg = message.data(); // Lấy thông điệp nhận được

  if (message.data() == "TURN ON BUZZER") {
    digitalWrite(BUZZER_PIN,HIGH);
    Serial.println("BUZZER turned on");
  }
  else if (message.data() == "TURN OFF BUZZER") {
    digitalWrite(BUZZER_PIN,LOW);
    Serial.println("BUZZER turned on");
  }
 
}


void setup() {
  Serial.begin(115200);
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);

#if 1 
  // Sử dụng thư viện truyền thống để kết nối wifi
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
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
 
  pinMode(BUZZER_PIN, OUTPUT);


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
  while(!client.connect(websocket_server_host, websocket_server_port, "/esp8266_buzzer")) {
    Serial.print(".");
    delay(500);
  }
  Serial.print("\n");
#endif
  
  // Send a ping
  client.ping();
  client.send(CODE_SYSTEM);
}

void loop() {
  //server.handleClient();
  client.poll();
}





