const WebSocket = require("ws");
const express = require("express");
const http = require("http");
const admin = require("firebase-admin");
const fs = require("fs");

var serviceAccount = JSON.parse(
  fs.readFileSync(
    __dirname +
      "/services/fire-warning-system-2d9c2-firebase-adminsdk-v2fuj-887ee7c21a.json",
    "utf8"
  )
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL:
    "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
});

// Thiết lập express và HTTP server
const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Biến lưu trữ dữ liệu hình ảnh gần nhất
let lastImage;

// Xử lý khi có WebSocket connection
wss.on("connection", function (ws, req) {
  const pathname = new URL(req.url, `http://${req.headers.host}`).pathname;

  if (pathname === "/image") {
    console.log("New ESP32CAM connected");
    ws.on("message", function (data) {
      // Giả sử dữ liệu nhận được là hình ảnh binary
      lastImage = data;
      console.log("Received image data");
      // Phát dữ liệu này đến tất cả viewer đang kết nối
      broadcastImageData(data);
    });
  } else if (pathname === "/display") {
    console.log("New viewer connected");
    if (lastImage) {
      ws.send(lastImage);
    }
  }

  ws.on("error", function (error) {
    console.log("WebSocket error: " + error);
  });

  ws.on("close", function () {
    console.log("WebSocket connection closed");
  });
});

function broadcastImageData(data) {
  wss.clients.forEach(function (client) {
    if (
      client.readyState === WebSocket.OPEN &&
      new URL(client.url, `http://${client.headers.host}`).pathname ===
        "/display"
    ) {
      client.send(data);
    }
  });
}

// Định tuyến cho Express để hiển thị hình ảnh
app.get("/client/image", (req, res) => {
  if (lastImage) {
    res.writeHead(200, {
      "Content-Type": "image/jpeg",
      "Content-Length": lastImage.length,
    });
    res.end(lastImage);
  } else {
    res.status(404).send("No image available");
  }
});

app.get("/client/videos", (req, res) => {
  res.sendFile(__dirname + "/client/videos.html");
});

// Endpoint để gửi lệnh bật và tắt đèn LED
app.get("/client/openLed", (req, res) => sendLEDCommand("TURN ON LED", res));
app.get("/client/closeLed", (req, res) => sendLEDCommand("TURN OFF LED", res));

function sendLEDCommand(command, res) {
  if (wss.clients.size === 0) {
    res.status(500).send("No ESP32CAM connected");
    return;
  }

  let messageSent = false;
  wss.clients.forEach(function (client) {
    if (
      client.readyState === WebSocket.OPEN &&
      new URL(client.url, `http://${client.headers.host}`).pathname === "/image"
    ) {
      client.send(command);
      messageSent = true;
    }
  });

  if (messageSent) {
    res.send(command + " command sent");
  } else {
    res.status(500).send("Failed to send " + command);
  }
}

// Lấy tham chiếu đến cơ sở dữ liệu
const db = admin.database();
const statusRef = db.ref("Fire/Status");
statusRef.on(
  "value",
  function (snapshot) {
    const status = snapshot.val();
    console.log("Updated status:", status);
    broadcastImageData(status);
  },
  function (errorObject) {
    console.log("The read failed: " + errorObject.code);
  }
);

// Khởi động server
server.listen(process.env.PORT || 80, () => {
  console.log(
    "HTTP server is running on http://localhost:" + (process.env.PORT || 80)
  );
});
