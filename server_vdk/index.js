const WebSocket = require("ws");
const http = require("http");
const url = require("url");
const express = require("express");
const admin = require("firebase-admin");

var serviceAccount = require(__dirname +
  "/service/fire-warning-system-2d9c2-firebase-adminsdk-v2fuj-887ee7c21a.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL:
    "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
});

// Lấy tham chiếu đến cơ sở dữ liệu
const db = admin.database();
const app = express();
const server = http.createServer(app);
const ESP8266_CONTROL_DOORS = new WebSocket.Server({ port: 6666 });

let devicesESP8266 = {}; // Lưu trữ danh sách các ESP8266 kết nối

ESP8266_CONTROL_DOORS.on("connection", function (ws) {
  ws.on("message", function (data) {
    try {
      if (typeof data === "string" && !devicesESP8266[ws.esp8266ID]) {
        ws.esp8266ID = data;
        devicesESP8266[data] = { socket: ws };
        console.log("ESP8266 ID registered: " + data);
      }
    } catch (error) {
      console.error("Error handling message from ESP8266: ", error);
    }
  });

  ws.on("error", function (error) {
    console.error("Error in ESP8266 connection: ", error);
  });

  ws.on("close", function () {
    console.log(`Client ${ws.esp8266ID} disconnected`);
    delete devicesESP8266[ws.esp8266ID];
  });
});

const ids = ["DOOR1", "DOOR2", "DOOR3"];
let waterLevels = {};

// Hàm để lấy dữ liệu từ Water_Level1
function fetchWaterLevelData() {
  ids.forEach((id, index) => {
    const ref = db.ref(`ESP8266_CK/Water_Level/${id}`);
    ref.on("value", (snapshot) => {
      const value = parseInt(snapshot.val(), 10); // Chuyển đổi giá trị từ string sang int
      waterLevels[id] = value;
      console.log("Water Level " + id + ": " + value);
      compareWaterLevels(); // Gọi hàm so sánh sau khi cập nhật giá trị
    });
  });
}

function compareWaterLevels() {
  if (
    waterLevels["DOOR1"] !== undefined &&
    waterLevels["DOOR2"] !== undefined
  ) {
    const absDifference1 = Math.abs(
      waterLevels["DOOR1"] - waterLevels["DOOR2"]
    );
    if (absDifference1 >= 1 && absDifference1 <= 3) {
      console.log(
        "Giá trị tuyệt đối giữa DOOR1 và DOOR2 nằm trong khoảng từ 1 đến 3. Thực hiện hành động..."
      );

      if (devicesESP8266["ESP8266_DOOR1"]) {
        devicesESP8266["ESP8266_DOOR1"].socket.send("TURN OFF MOTOR AUTO");
        console.log("ESP8266_DOOR1 TURN OFF MOTOR AUTO");
      } else {
        console.log("ESP8266_DOOR1 not connected");
      }
    }
  }

  if (
    waterLevels["DOOR2"] !== undefined &&
    waterLevels["DOOR3"] !== undefined
  ) {
    const absDifference2 = Math.abs(
      waterLevels["DOOR2"] - waterLevels["DOOR3"]
    );
    if (absDifference2 >= 1 && absDifference2 <= 3) {
      console.log(
        "Giá trị tuyệt đối giữa DOOR2 và DOOR3 nằm trong khoảng từ 1 đến 3. Thực hiện hành động..."
      );

      if (devicesESP8266["ESP8266_DOOR2"]) {
        devicesESP8266["ESP8266_DOOR2"].socket.send("TURN OFF MOTOR AUTO");
        console.log("ESP8266_DOOR2 TURN OFF MOTOR AUTO");
      } else {
        console.log("ESP8266_DOOR2 not connected");
      }
    }
  }
}

// Định nghĩa các API để gửi thông điệp lại cho ESP8266
app.get("/controlDoor/:esp8266ID", (req, res) => {
  const esp8266ID = req.params.esp8266ID;
  const step = req.query.step;
  if (devicesESP8266[esp8266ID]) {
    devicesESP8266[esp8266ID].socket.send(`stepper: ${step}`);
    res.send(`Device ${esp8266ID} Stepper moved ${step} steps`);
    console.log("Device: " + esp8266ID + " Stepper moved steps: " + step);
  } else {
    res.status(404).send("No ESP8266 available for this ID");
    console.log("No ESP8266 available for this ID");
  }
});

app.get("/:esp8266ID/turnOffMotor", (req, res) => {
  const esp8266ID = req.params.esp8266ID;
  if (devicesESP8266[esp8266ID]) {
    devicesESP8266[esp8266ID].socket.send("TURN OFF MOTOR");
    res.send(`Device ${esp8266ID} Motor turned off`);
    console.log("Device: " + esp8266ID + " Motor turned off");
  } else {
    res.status(404).send("No ESP8266 available for this ID");
    console.log("No ESP8266 available for this ID");
  }
});

app.get("/:esp8266ID/turnOnMotor", (req, res) => {
  const esp8266ID = req.params.esp8266ID;
  if (devicesESP8266[esp8266ID]) {
    devicesESP8266[esp8266ID].socket.send("TURN ON MOTOR");
    res.send(`Device ${esp8266ID} Motor turned on`);
    console.log("Device: " + esp8266ID + " Motor turned on");
  } else {
    res.status(404).send("No ESP8266 available for this ID");
    console.log("No ESP8266 available for this ID");
  }
});

server.listen(5555, () => {
  //setInterval(fetchWaterLevelData, 1 * 1000); // 10 phút
  fetchWaterLevelData();
  console.log(
    "HTTP server is running on https://hrl4vkc2-5555.asse.devtunnels.ms/"
  );
});
