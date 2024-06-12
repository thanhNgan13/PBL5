const WebSocket = require("ws");
const express = require("express");
const http = require("http");
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
const imageServer = new WebSocket.Server({ port: 8888 });
const displayServer = new WebSocket.Server({ server, path: "/display" });

let devicesESP32CAM = {}; // Lưu trữ danh sách các ESP32CAM kết nối và hình ảnh của nó

imageServer.on("connection", function (ws) {
  ws.on("message", function (data) {
    try {
      if (typeof data === "string") {
        ws.esp32camID = data;
        devicesESP32CAM[data] = { socket: ws, image: null };
        console.log("ESP32CAM ID registered: " + data);
      } else {
        handleImageData(ws, data);
      }
    } catch (error) {
      console.error("Error handling message from ESP32CAM: ", error);
    }
  });

  ws.on("error", function (error) {
    console.error("Error in ESP32CAM connection: ", error);
  });

  ws.on("close", function () {
    console.log(`Client ${ws.esp32camID} disconnected`);
    delete devicesESP32CAM[ws.esp32camID];
  });
});

function handleImageData(ws, data) {
  if (ws.esp32camID && devicesESP32CAM[ws.esp32camID]) {
    const imgBase64 = Buffer.from(data).toString("base64");
    devicesESP32CAM[ws.esp32camID].imgBase64 = imgBase64;
    devicesESP32CAM[ws.esp32camID].image = data;
    console.log(`Image received from ${ws.esp32camID}`);
    broadcastImage(ws.esp32camID, imgBase64, data);
  }
}

function broadcastImage(id, imgBase64, image) {
  displayServer.clients.forEach(function (client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify({ id, imgBase64, image }));
    }
  });
}

displayServer.on("connection", function (ws) {
  console.log("New viewer connected");
  // Gửi tất cả hình ảnh hiện tại khi một viewer mới kết nối
  Object.keys(devicesESP32CAM).forEach((esp32camID) => {
    if (devicesESP32CAM[esp32camID].image) {
      ws.send(
        JSON.stringify({
          id: esp32camID,
          image: devicesESP32CAM[esp32camID].image,
          imgBase64: devicesESP32CAM[esp32camID].imgBase64,
        })
      );
    }
  });
});

// Định tuyến cho Express để hiển thị hình ảnh từ một client cụ thể
app.get("/client/image/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  if (devicesESP32CAM[esp32camID] && devicesESP32CAM[esp32camID].image) {
    const imgData = devicesESP32CAM[esp32camID].image;
    res.writeHead(200, {
      "Content-Type": "image/jpeg",
      "Content-Length": imgData.length,
    });
    res.end(imgData);
  } else {
    res.status(404).send("No image available for this ID");
  }
});

app.get("/client/videos/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  // Lấy hostname từ request
  const host = req.hostname;
  console.log("Host: ", host);

  // Kiểm tra xem thiết bị có tồn tại và có hình ảnh không
  if (devicesESP32CAM[esp32camID] && devicesESP32CAM[esp32camID].image) {
    // Phục vụ một trang HTML với JavaScript để hiển thị luồng video từ ESP32CAM cụ thể
    res.send(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>ESP32 Stream - ${esp32camID}</title>
          <style>
            img {
              width: 100%;
              height: auto; /* Adjust height to maintain aspect ratio */
            }
          </style>
        </head>
        <body>
          <img id="videoStream" src="" alt="Video stream not available" />
          <script>
            const img = document.getElementById("videoStream");
            // Tạo kết nối WebSocket đến máy chủ hiện tại
            const ws = new WebSocket("ws://" + window.location.hostname + ":8999/display");
            const targetID = "${esp32camID}"; // Sử dụng ID từ URL

            ws.onmessage = function (event) {
              const data = JSON.parse(event.data);
              if (data.id === targetID) {
                img.src = "data:image/jpeg;base64," + data.imgBase64;
              }
            };

            ws.onerror = function (error) {
              console.error("WebSocket Error: ", error);
            };

            ws.onclose = function () {
              console.log("WebSocket connection closed");
            };
          </script>
        </body>
      </html>
    `);
  } else {
    res.status(404).send("No image available for this ID");
  }
});

app.get("/client/openLed/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  if (devicesESP32CAM[esp32camID]) {
    devicesESP32CAM[esp32camID].socket.send("TURN ON LED");
    res.send("LED turned on");
  } else {
    res.status(404).send("No ESP32CAM available for this ID");
  }
});

app.get("/client/closeLed/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  if (devicesESP32CAM[esp32camID]) {
    devicesESP32CAM[esp32camID].socket.send("TURN OFF LED");
    res.send("LED turned off");
  } else {
    res.status(404).send("No ESP32CAM available for this ID");
  }
});

app.get("/client/servo/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  const pos = req.query.pos;
  if (devicesESP32CAM[esp32camID]) {
    devicesESP32CAM[esp32camID].socket.send(`servo: ${pos}`);
    res.send(`Servo moved ${pos} post`);
  } else {
    res.status(404).send("No ESP32CAM available for this ID");
  }
});

app.get("/client/turnOffBuzzer/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  if (devicesESP32CAM[esp32camID]) {
    devicesESP32CAM[esp32camID].socket.send("TURN OFF BUZZER");
    res.send("Buzzer turned off");
  } else {
    res.status(404).send("No ESP32CAM available for this ID");
  }
});

app.get("/client/turnOnBuzzer/:esp32camID", (req, res) => {
  const esp32camID = req.params.esp32camID;
  if (devicesESP32CAM[esp32camID]) {
    devicesESP32CAM[esp32camID].socket.send("TURN ON BUZZER");
    res.send("Buzzer turned on");
  } else {
    res.status(404).send("No ESP32CAM available for this ID");
  }
});

app.get("/client/test", (req, res) => {
  res.send("Test");
});

// Hàm để lắng nghe thay đổi trạng thái của tất cả tài khoản
function listenToAllUserStatusChanges() {
  const accountsRef = db.ref("Accounts");

  // Lắng nghe các tài khoản mới được thêm vào
  accountsRef.on("child_added", (snapshot) => {
    const userId = snapshot.key;
    listenToStatusChange(userId);
  });

  // Lắng nghe các thay đổi trên các tài khoản hiện có
  accountsRef.on("child_changed", (snapshot) => {
    const userId = snapshot.key;
    listenToStatusChange(userId);
  });
}

const userStatus = {}; // Lưu trạng thái cũ của mỗi user

function listenToStatusChange(userId) {
  const refAccount = db.ref(`Accounts/${userId}`);
  refAccount.on("value", (snapshot) => {
    const data = snapshot.val();
    const isAlertedNow = data.isAlerted === "true";

    if (userStatus[userId] === undefined) {
      if (isAlertedNow) {
        const esp32camID = data.code;
        console.log("Sending alert to ESP32CAM" + esp32camID);
        devicesESP32CAM[esp32camID].socket.send("TURN ON BUZZER");
      }
    } else if (!userStatus[userId].alerted && isAlertedNow) {
      const esp32camID = data.code;
      console.log("Sending alert to ESP32CAM" + esp32camID);
      devicesESP32CAM[esp32camID].socket.send("TURN ON BUZZER");
    }
    // Cập nhật trạng thái mới
    userStatus[userId] = { alerted: isAlertedNow };
  });
}

server.listen(8999, () => {
  // listenToAllUserStatusChanges();
  console.log("HTTP server is running on 8999");
});
