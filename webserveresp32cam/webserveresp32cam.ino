#include <WiFi.h>
#include <WebServer.h>
#include "ESPAsyncWebServer.h"
#include <ESP32Servo.h> // Sử dụng thư viện ESP32Servo thay vì thư viện Servo mặc định
#include <AccelStepper.h>




const char* ssid = "pthanhNgan1331";
const char* password = "1highbarforfive!";

WebServer server(80);
Servo myservo; // Đối tượng Servo trụ di chuyển camera


const int stepsPerRevolution = 2048;  // change this to fit the number of steps per revolution
// ULN2003 Motor Driver Pins
#define IN1 14
#define IN2 15
#define IN3 13
#define IN4 12
// initialize the stepper library
AccelStepper stepper(AccelStepper::FULL4WIRE, IN1, IN3, IN2, IN4);

void setup() {
  Serial.begin(115200);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(14, OUTPUT);
  pinMode(15, OUTPUT);
  myservo.attach(2); // SỬ DỤNG CHÂN GPIO 2
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  Serial.println(WiFi.localIP());


  server.on("/", HTTP_GET, []() {
    server.send(200, "text/html", getHTML());
  });


  server.on("/control", HTTP_GET, []() {
    if (server.hasArg("num") && server.hasArg("pos")) {
      int num = server.arg("num").toInt();
      int pos = server.arg("pos").toInt();
      
      if(num == 2) {
        myservo.write(pos);
      }
      
      Serial.println("Servo " + String(num) + " to " + String(pos));
      server.send(200, "text/plain", "Moving servo " + server.arg("num") + " to " + server.arg("pos"));
    } else {
      server.send(400, "text/plain", "Bad Request"); 
    }
  });

  server.on("/controla", HTTP_GET, []() {
  if (server.hasArg("angle")) {
    int angle = server.arg("angle").toInt();
    int steps = map(angle, 0, 360, 0, 2048); // Điều chỉnh 2048 bước này tùy theo động cơ của bạn
    stepper.moveTo(steps);
    Serial.println("Servo " + String(steps));

    server.send(200, "text/plain", "Rotating to " + String(angle) + " degrees");
  } else {
    server.send(400, "text/plain", "Argument 'angle' not found");

        Serial.println("ERROR");

  }
});

  server.begin();
}

void loop() {
  server.handleClient();
  if(stepper.distanceToGo() != 0) {
    stepper.run();
  }
}


String getHTML() {
  String html = R"(
<!DOCTYPE html>
<html>
<body>
<h1>Control servo</h1>
<h2>Servo Control</h2>
<p>Angle (0 to 360): <input type='range' min='0' max='360' value='180' id='angleSlider' onchange='updateAngle(this.value)' /></p>
<p>Servo 2:</p>
<input type='range' min='0' max='180' value='90' onchange='updateServo(2, this.value)' id='servoSlider2'>
<script>
function updateServo(servo, pos) {
  var xhttp = new XMLHttpRequest();
  xhttp.open("GET", "control?num=" + servo + "&pos=" + pos, true);
  xhttp.send();
}

function updateAngle(angle) {
                  var xhr = new XMLHttpRequest();
                  xhr.open('GET', '/controla?angle=' + angle, true);
                  xhr.send();
                }
</script>
</body>
</html>
)";
  return html;
}
