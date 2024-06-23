#include <ESP8266WiFi.h>
#include "FirebaseESP8266.h"
#include <WiFiManager.h>
#include "MQ2.h"

#define mq2PinAnalog A0
#define mq2PinDigital D5
   
// Insert your RTDB URL
#define FIREBASE_HOST "fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app"    
// Insert Firebase Database secret
#define FIREBASE_AUTH "AIzaSyCSiBTRnU7u3aQee9-b2MhzCS6_dlHJsfE"

// Insert your network credentials
const char* WIFI_SSID = "Quang Sang";
const char* WIFI_PASS = "07092003";

// Khai báo biến firebaseData
FirebaseData firebaseData; 
/* Define the FirebaseAuth data for authentication data */
FirebaseAuth auth;
/* Define the FirebaseConfig data for config data */
FirebaseConfig config;

String CODE_SYSTEM = "Pbl50001";
String CODE_ESP8266 = "ESP8266_";
String path = "Sensor/" + CODE_SYSTEM + "/" + CODE_ESP8266 + "/";
String isSmoke = "";       
int sensorValueAnalog;
int sensorValueDigital;

float lpg, co, smoke;
MQ2 mq2(mq2PinAnalog);

void setup() 
{
  Serial.begin(115200);
  pinMode(mq2PinDigital, INPUT);
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
  Serial.println("Program Begun!");

  config.database_url = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

  // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  Firebase.reconnectNetwork(true);

  /* Initialize the library with the Firebase authen and config */
  Firebase.begin(&config, &auth);
  mq2.begin();
}
 
void loop() 
{
  sendDataToFirebase();
}

void sendDataToFirebase() {
  float* values= mq2.read(true); //set it false if you don't want to print the values to the Serial
  // lpg = values[0];
  lpg = mq2.readLPG();
  // co = values[1];
  co = mq2.readCO();
  // smoke = values[2];
  smoke = mq2.readSmoke();

  sensorValueAnalog = analogRead(mq2PinAnalog);
  sensorValueDigital = digitalRead(mq2PinDigital);

  if (sensorValueDigital == 0) {
    isSmoke = "true";
    Firebase.setString(firebaseData, path + "Status", isSmoke); 
  }

  else {
    isSmoke = "false";
    Firebase.setString(firebaseData, path + "Status", isSmoke); 
  }

  Firebase.setString(firebaseData, path + "Val_Analog", sensorValueAnalog);
  Firebase.setString(firebaseData, path + "Val_Digital", sensorValueDigital);

  Firebase.setString(firebaseData, path + "LPG", lpg);
  Firebase.setString(firebaseData, path + "CO", co);
  Firebase.setString(firebaseData, path + "SMOKE", smoke);

}


