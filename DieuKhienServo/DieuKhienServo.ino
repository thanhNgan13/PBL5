#include <Servo.h>

Servo myservo;  // Tạo đối tượng servo

void setup() {
  myservo.attach(15); // Gắn servo vào chân D1
}

void loop() {
  // Quay servo sang trái với tốc độ vừa phải
  myservo.write(-10); // Tốc độ và hướng quay phụ thuộc vào servo của bạn
  delay(1000); // Quay trong 1 giây

  // // Dừng servo
  // myservo.writeMicroseconds(1500); // Dừng servo
  // delay(1000); // Dừng trong 1 giây

  // // Quay servo sang phải với tốc độ vừa phải
  // myservo.writeMicroseconds(1700); // Tốc độ và hướng quay phụ thuộc vào servo của bạn
  // delay(1000); // Quay trong 1 giây

  // Lặp lại hoặc thay đổi logic theo yêu cầu
}
