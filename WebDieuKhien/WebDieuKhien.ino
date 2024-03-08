#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Servo.h>
#include <ESP8266mDNS.h>            // Thư viện dùng để thiết lập mDNS


const char* ssid = "APTX4869";     // Thay thế YOUR_WIFI_SSID bằng tên WiFi của bạn
const char* password = "11111111"; // Thay thế YOUR_WIFI_PASSWORD bằng mật khẩu WiFi của bạn

ESP8266WebServer server(80);
Servo myservo1; // Đối tượng Servo trụ xoay
Servo myservo2; // Đối tượng Servo trụ di chuyển camera

void setup() {
  Serial.begin(115200);
  myservo1.attach(15); // Sử dụng chân D4 trên ESP8266 cho servo trụ xoay
  myservo2.attach(2); // Sử dụng chân D5 trên ESP8266 cho servo trụ di chuyển camera

  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  
  Serial.println("Connected to WiFi");
  Serial.println(WiFi.localIP());

  if (!MDNS.begin("esp8266-1-controlservo")) 
   {             
     Serial.println("Error starting mDNS");
   }
   Serial.println("mDNS started");

  server.on("/", HTTP_GET, []() {
    server.send(200, "text/html", getHTML());
  });

  server.on("/servo", HTTP_GET, []() {
    if (server.hasArg("num") && server.hasArg("pos")) {
      int num = server.arg("num").toInt();
      int pos = server.arg("pos").toInt();
      
      if(num == 1) {
        myservo1.write(pos);
      } else if(num == 2) {
        myservo2.write(pos);
      }
      
      Serial.println("Servo " + String(num) + " to " + String(pos));
      server.send(200, "text/plain", "Moving servo " + server.arg("num") + " to " + server.arg("pos"));
    } else {
      server.send(400, "text/plain", "Bad Request");
    }
  });

  server.begin();
}

void loop() {
  MDNS.update();
  server.handleClient();
}

String getHTML() {
  String html = R"(
<!DOCTYPE html>
<html>
<body>
<h2>Servo Control</h2>
<p>Servo 1:</p>
<input type='range' min='0' max='180' value='90' onchange='updateServo(1, this.value)' id='servoSlider1'>
<p>Servo 2:</p>
<input type='range' min='0' max='180' value='90' onchange='updateServo(2, this.value)' id='servoSlider2'>
<script>
function updateServo(servo, pos) {
  var xhttp = new XMLHttpRequest();
  xhttp.open("GET", "servo?num=" + servo + "&pos=" + pos, true);
  xhttp.send();
}
</script>
</body>
</html>
)";
  return html;
}
