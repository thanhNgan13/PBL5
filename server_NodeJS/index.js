const WebSocket = require("ws");
const express = require("express");
const http = require("http");
const admin = require("firebase-admin");

var serviceAccount = require(__dirname +
  "/services/fire-warning-system-2d9c2-firebase-adminsdk-v2fuj-887ee7c21a.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL:
    "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
});

// Thiết lập express và HTTP server
const app = express();
const server = http.createServer(app);
// Thiết lập WebSocket server để nhận dữ liệu hình ảnh
const imageServer = new WebSocket.Server({ port: 8888 });
// Thiết lập WebSocket server trên cùng server HTTP để hiển thị hình ảnh
const displayServer = new WebSocket.Server({ server, path: "/display" });

// Biến lưu trữ dữ liệu hình ảnh gần nhất
let lastImage;

// Xử lý khi có WebSocket connection
imageServer.on("connection", function (ws) {
  console.log("New ESP32CAM connected");
  ws.on("message", function (data) {
    // Giả sử dữ liệu nhận được là hình ảnh binary
    lastImage = data;
    console.log("Received image data");
    // Phát dữ liệu này đến tất cả viewer đang kết nối
    displayServer.clients.forEach(function (client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(data);
      }
    });
  });

  ws.on("error", function (error) {
    console.log("WebSocket error: " + error);
  });

  ws.on("close", function () {
    console.log("WebSocket connection closed");
  });
});

// Khách hàng kết nối để xem hình ảnh
displayServer.on("connection", function (ws) {
  console.log("New viewer connected");
  if (lastImage) {
    ws.send(lastImage);
  }
});

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

// Endpoint để gửi lệnh bật đèn LED
app.get("/client/openLed", (req, res) => {
  if (imageServer.clients.size === 0) {
    res.status(500).send("No ESP32CAM connected");
    return;
  }

  let messageSent = false;

  // Gửi thông điệp tới tất cả ESP32CAM đang kết nối
  imageServer.clients.forEach(function (client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send("TURN ON LED"); // Gửi lệnh bật đèn LED
      messageSent = true;
    }
  });

  if (messageSent) {
    res.send("LED turning on command sent");
  } else {
    res.status(500).send("Failed to send LED command");
  }
});

// Endpoint để gửi lệnh tắt đèn LED
app.get("/clients/closeLed", (req, res) => {
  if (imageServer.clients.size === 0) {
    res.status(500).send("No ESP32CAM connected");
    return;
  }

  let messageSent = false;

  // Gửi thông điệp tới tất cả ESP32CAM đang kết nối
  imageServer.clients.forEach(function (client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send("TURN OFF LED"); // Gửi lệnh tắt đèn LED
      messageSent = true;
    }
  });

  if (messageSent) {
    res.send("LED turning off command sent");
  } else {
    res.status(500).send("Failed to send LED command");
  }
});

// Lấy tham chiếu đến cơ sở dữ liệu
const db = admin.database();
const statusRef = db.ref("Fire/Status"); // Thay đổi đường dẫn theo đường dẫn của bạn
statusRef.on(
  "value",
  function (snapshot) {
    const status = snapshot.val();
    console.log("Updated status:", status);
    // Gửi thông điệp tới tất cả ESP32CAM đang kết nối
    imageServer.clients.forEach(function (client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(status);
        messageSent = true;
      }
    });
  },
  function (errorObject) {
    console.log("The read failed: " + errorObject.code);
  }
);

// Khởi động server
server.listen(8999, () => {
  console.log("HTTP server is running on http://localhost:8999");
});
