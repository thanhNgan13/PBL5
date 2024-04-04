#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include "FirebaseESP8266.h"

// Insert your RTDB URL
#define FIREBASE_HOST "fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app"    
// Insert Firebase Database secret
#define FIREBASE_AUTH "AIzaSyCSiBTRnU7u3aQee9-b2MhzCS6_dlHJsfE"
// Insert your network credentials
#define WIFI_SSID "pthanhNgan1331"                        
#define WIFI_PASSWORD "1highbarforfive!"  

// Khai báo biến firebaseData
FirebaseData firebaseData; 
/* 4, Define the FirebaseAuth data for authentication data */
FirebaseAuth auth;
/* Define the FirebaseConfig data for config data */
FirebaseConfig config;
const int mq7Pin = A0; // Chân ADC nối với MQ-7l
String path = "ESP8266_1/Outputs/"; // chứa đường dẫn đến trường dữ liệu trong firebase
String fireStatus = "";       // led status received from firebase
void setup() 
{
  Serial.begin(115200);
  delay(1000);    
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);            
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED) 
  {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);


  config.database_url = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

      // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  Firebase.reconnectNetwork(true);

    /* Initialize the library with the Firebase authen and config */
  Firebase.begin(&config, &auth);
  Firebase.setString(firebaseData, path + "Status_CO", "NORMAL"); //send initial string of led status
}
 
void loop() 
{
  int sensorValue = analogRead(mq7Pin);
  Firebase.setString(firebaseData, path + "Val_CO", sensorValue); //send initial string of led status

  if (sensorValue > 200) {
    Firebase.setString(firebaseData, path + "Status_CO", "Warning!!!"); //send initial string of led status
  }
  else {
    Firebase.setString(firebaseData, path + "Status_CO", "NORMAL"); //send initial string of led status
  }

}