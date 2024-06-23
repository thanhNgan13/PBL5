#include <WiFi.h>
#include <esp32cam.h>
#include <ArduinoJson.h>
#include <ArduinoWebsockets.h>
#include <WebServer.h>
#include <ESP32Servo.h>
#include <WiFiManager.h>

#define FLASH_PIN 4
#define BUZZER_PIN 14 //GPIO 12
#define SERVO_PIN 13 // GPIO 13

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
Servo myServo;

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

  // Kiểm tra nội dung của thông điệp
  if (message.data() == "TURN ON LED") {
    digitalWrite(FLASH_PIN, HIGH); // Bật đèn LED
    Serial.println("LED turned on");
  } else if (message.data() == "TURN OFF LED") {
    digitalWrite(FLASH_PIN, LOW); // Tắt đèn LED
    Serial.println("LED turned off");
  }
  else if (message.data() == "TURN ON BUZZER") {
    digitalWrite(BUZZER_PIN,HIGH);
    Serial.println("BUZZER turned on");
  }
  else if (message.data() == "TURN OFF BUZZER") {
    digitalWrite(BUZZER_PIN,LOW);
    Serial.println("BUZZER turned on");
  }
  else if (msg.startsWith("servo: ")) {
    int pos = msg.substring(7).toInt(); 
    myServo.write(pos);
    Serial.print("Servo position set to: ");
    Serial.println(pos);
  } 
}

const char* rootCACertificate = \
"-----BEGIN CERTIFICATE-----\n" \
"MIIFrDCCBJSgAwIBAgIQBRllJkSaXj0aOHSPXc/rzDANBgkqhkiG9w0BAQwFADBh\n" \
"MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3\n" \
"d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBH\n" \
"MjAeFw0yMzA2MDgwMDAwMDBaFw0yNjA4MjUyMzU5NTlaMF0xCzAJBgNVBAYTAlVT\n" \
"MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLjAsBgNVBAMTJU1pY3Jv\n" \
"c29mdCBBenVyZSBSU0EgVExTIElzc3VpbmcgQ0EgMDMwggIiMA0GCSqGSIb3DQEB\n" \
"AQUAA4ICDwAwggIKAoICAQCUaitvevlZirydcTjMIt2fr5ei7LvQx7bdIVobgEZ1\n" \
"Qlqf3BH6etKdmZChydkN0XXAb8Ysew8aCixKtrVeDCe5xRRCnKaFcEvqg2cSfbpX\n" \
"FevXDvfbTK2ed7YASOJ/pv31stqHd9m0xWZLCmsXZ8x6yIxgEGVHjIAOCyTAgcQy\n" \
"8ItIjmxn3Vu2FFVBemtP38Nzur/8id85uY7QPspI8Er8qVBBBHp6PhxTIKxAZpZb\n" \
"XtBf2VxIKbvUGEvCxWCrKNfv+j0oEqDpXOqGFpVBK28Q48u/0F+YBUY8FKP4rfgF\n" \
"I4lG9mnzMmCL76k+HjyBtU5zikDGqgm4mlPXgSRqEh0CvQS7zyrBRWiJCfK0g67f\n" \
"69CVGa7fji8pz99J59s8bYW7jgyro93LCGb4N3QfJLurB//ehDp33XdIhizJtopj\n" \
"UoFUGLnomVnMRTUNtMSAy7J4r1yjJDLufgnrPZ0yjYo6nyMiFswCaMmFfclUKtGz\n" \
"zbPDpIBuf0hmvJAt0LyWlYUst5geusPxbkM5XOhLn7px+/y+R0wMT3zNZYQxlsLD\n" \
"bXGYsRdE9jxcIts+IQwWZGnmHhhC1kvKC/nAYcqBZctMQB5q/qsPH652dc73zOx6\n" \
"Bp2gTZqokGCv5PGxiXcrwouOUIlYgizBDYGBDU02S4BRDM3oW9motVUonBnF8JHV\n" \
"RwIDAQABo4IBYjCCAV4wEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU/glx\n" \
"QFUFEETYpIF1uJ4a6UoGiMgwHwYDVR0jBBgwFoAUTiJUIBiV5uNu5g/6+rkS7QYX\n" \
"jzkwDgYDVR0PAQH/BAQDAgGGMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcD\n" \
"AjB2BggrBgEFBQcBAQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2lj\n" \
"ZXJ0LmNvbTBABggrBgEFBQcwAoY0aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29t\n" \
"L0RpZ2lDZXJ0R2xvYmFsUm9vdEcyLmNydDBCBgNVHR8EOzA5MDegNaAzhjFodHRw\n" \
"Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRHbG9iYWxSb290RzIuY3JsMB0G\n" \
"A1UdIAQWMBQwCAYGZ4EMAQIBMAgGBmeBDAECAjANBgkqhkiG9w0BAQwFAAOCAQEA\n" \
"AQkxu6RRPlD3yrYhxg9jIlVZKjAnC9H+D0SSq4j1I8dNImZ4QjexTEv+224CSvy4\n" \
"zfp9gmeRfC8rnrr4FN4UFppYIgqR4H7jIUVMG9ECUcQj2Ef11RXqKOg5LK3fkoFz\n" \
"/Nb9CYvg4Ws9zv8xmE1Mr2N6WDgLuTBIwul2/7oakjj8MA5EeijIjHgB1/0r5mPm\n" \
"eFYVx8xCuX/j7+q4tH4PiHzzBcfqb3k0iR4DlhiZfDmy4FuNWXGM8ZoMM43EnRN/\n" \
"meqAcMkABZhY4gqeWZbOgxber297PnGOCcIplOwpPfLu1A1K9frVwDzAG096a8L0\n" \
"+ItQCmz7TjRH4ptX5Zh9pw==\n" \
"-----END CERTIFICATE-----\n" \
"";


// Các thông số của camera
static auto loRes = esp32cam::Resolution::find(320, 240);
static auto midRes = esp32cam::Resolution::find(350, 530);
static auto hiRes = esp32cam::Resolution::find(800, 600);
static auto cusRes = esp32cam::Resolution::find(640, 640);
esp32cam::Resolution initialResolution;


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
  //-------------------
  {
    using namespace esp32cam;
    Config cfg;
    cfg.setPins(pins::AiThinker);
    cfg.setResolution(cusRes);
    cfg.setBufferCount(2);
    cfg.setJpeg(80);

    bool ok = Camera.begin(cfg);
    if (!ok) {
      Serial.println("-----------------------------");
      Serial.println("Camera initialize failure!");
      ESP.restart();
    }
    else {
      Serial.println("Camera OK");
    }
  }
  pinMode(FLASH_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(SERVO_PIN, OUTPUT);

  myServo.attach(SERVO_PIN);

  // Setup Callbacks
  client.onMessage(onMessageCallback);
  client.onEvent(onEventsCallback);
  client.setCACert(rootCACertificate);

  
#if 0
  // Connect to server
  while(!client.connect(websocket_server_url)) {
    Serial.print(".");
    delay(500);
  }
#endif

#if 1
  while(!client.connect(websocket_server_host, websocket_server_port, "/sendImage")) {
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
  sendImage();
}

void sendImage() {
  auto frame = esp32cam::capture();
  if (frame == nullptr) {
    Serial.println("CAPTURE FAIL");
    return;
  }
  else {
    client.sendBinary((const char*)(frame->data()), frame->size());
  }
}





