
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
//----------------------------------------Include the Servo Library
#include <Servo.h>
const char MAIN_page[] PROGMEM = R"=====(
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      .slidecontainer {
        width: 50%;
      }

      .slid {
          -webkit-appearance: none;
          width: 200px;
          height: 20px;
          border-radius: 5px;
          background: #111;
          outline: none;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: inset 0 0 5px rgba (0,0,0,1);
        }
        
        .slid::-webkit-slider-thumb {
          -webkit-appearance: none;
          
          width: 19px;
          height: 19px;
          border-radius: 50%;
          background: #ec1249;
          cursor: pointer;
          border: 4px solid rgb(247, 176, 176);
          box-shadow: -560px 0 0 550px #f10a0a;
        }
        #quay{
            font-family: Arial, Helvetica;
            color: #f10a3c;
        }
        #do{
            font-family: Arial, Helvetica;
            color: #f10a3c;
        }
        h2{
            color: rgb(116, 119, 77);
            margin-left: 100px;
            margin-top: 40px;
        }
    </style>
  </head>
  <body>
          <h2>Điều khiển gốc quay Servo</h2>
          <br><br>
          <div class="slidecontainer">
            <input type="range" min="0" max="180" value="50" class="slid" id="my">
              <p id="quay">Quay : <span id="demo"></span><span id="do"> độ</span></p>
          </div>
        
    <script>
      function sendData(pos) {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
            console.log(this.responseText);
          }
        };
        xhttp.open("GET", "setPOS?servoPOS="+pos, true);
        xhttp.send();
      } 
     var s = document.getElementById("my");
            var o = document.getElementById("demo");
            o.innerHTML = s.value;
      
            s.oninput = function() {
              o.innerHTML = this.value;
              sendData(o.innerHTML);
            }
    </script>

  </body>
</html>
)=====";



Servo myservo; 

ESP8266WebServer server(80);  //--> Server on port 80

void handleRoot() {
 String s = MAIN_page; //Read HTML contents
 server.send(200, "text/html", s); //Send web page
}

void handleServo(){
  String POS = server.arg("servoPOS");
  int pos = POS.toInt();
  myservo.write(pos);   
  delay(15);
  Serial.print("Servo Angle:");
  Serial.println(pos);
  server.send(200, "text/plane","");
}

void setup() {
  Serial.begin(115200);
  WiFi.begin("pthanhNgan1331", "1highbarforfive!");     //Connect to your WiFi router using ssid and pwd given above
  Serial.println("");
  // Connection wait
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");

  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  myservo.attach(15); 
  
  server.on("/",handleRoot);  //--> Routine to handle at root location. This is to display web page.
  server.on("/setPOS",handleServo); //--> Sets servo position from Web request
  server.begin();  
  Serial.println("HTTP server started");
}
void loop() {
 server.handleClient();
}
//------------------------------------------------------------------------------------
