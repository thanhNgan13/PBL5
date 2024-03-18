#include <Wire.h> 
#include <LiquidCrystal_I2C.h>


#define sensor A0
#define led 10
#define digitalInputSensor 8
#define buttonPin 2 // Định nghĩa pin cho nút nhấn

LiquidCrystal_I2C lcd(0x27,16,2); 
int valueCO;
int limit;


void setup() {
  Serial.begin(9600);
  lcd.init();                    
  lcd.backlight();
  pinMode(digitalInputSensor, INPUT);
  pinMode(buttonPin, INPUT);
  pinMode(led, OUTPUT);

}

void loop() {
  valueCO = analogRead(sensor);
  limit = digitalRead(digitalInputSensor);


  lcd.setCursor(0,0);
  lcd.print("Co valueCOue: ");
  lcd.setCursor(15,0);
  lcd.print(valueCO);

  Serial.print("CO valueCOue: ");
  Serial.println(valueCO);
  Serial.print("limit valueCOue: ");
  Serial.println(limit);

  if (limit == LOW) {
    digitalWrite(led, HIGH);
  }
   else {
    digitalWrite(led, LOW); // Nếu không vượt ngưỡng, đèn sẽ tắt
  }
}
