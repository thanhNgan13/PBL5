const WebSocket = require("ws");
const http = require("http");
const url = require("url");
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

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true); // true để phân tích cú pháp query thành object

  if (parsedUrl.pathname === "/servo") {
    // Lấy giá trị của 'pos' từ query string
    const pos = parsedUrl.query.pos;
    if (pos) {
      broadcastMessage(`servo: ${pos}`);
      res.statusCode = 200;
      res.end(`servo: ${pos}\n`);
    } else {
      res.statusCode = 400;
      res.end("Missing position parameter\n");
    }
  } else if (parsedUrl.pathname === "/stepper") {
    const step = parsedUrl.query.step;
    if (step) {
      broadcastMessage(`stepper: ${step}`);
      res.statusCode = 200;
      res.end(`stepper: ${step}\n`);
    } else {
      res.statusCode = 400;
      res.end("Missing step parameter\n");
    }
  } else {
    res.statusCode = 404;
    res.end("Not Found\n");
  }
});

const wss = new WebSocket.Server({ server });

function broadcastMessage(message) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

wss.on("connection", function connection(ws) {
  console.log("A new client connected.");

  const ids = ["ESP8266_1", "ESP8266_2", "ESP8266_3", "ESP8266_4"];
  const statuses = {};
  let activeTrueIds = []; // Mảng lưu giữ các ID có trạng thái true

  // Hàm gửi các ID mà có trạng thái true, chỉ khi có thay đổi
  function updateAndSendActiveTrueIds(id) {
    if (statuses[id] === "true" && !activeTrueIds.includes(id)) {
      // Thêm vào mảng nếu trạng thái là true và chưa có trong mảng
      activeTrueIds.push(id);
    } else if (statuses[id] === "false" && activeTrueIds.includes(id)) {
      // Loại bỏ khỏi mảng nếu trạng thái chuyển thành false
      activeTrueIds = activeTrueIds.filter((item) => item !== id);
    }
    ws.send(JSON.stringify(activeTrueIds)); // Gửi mảng cập nhật qua WebSocket
  }

  ids.forEach((id, index) => {
    const ref = db.ref(`${id}/Outputs/Status_CO`);
    ref.on("value", (snapshot) => {
      const previousStatus = statuses[id];
      statuses[id] = snapshot.val();
      // Chỉ gửi cập nhật nếu có sự thay đổi trạng thái
      if (statuses[id] !== previousStatus) {
        updateAndSendActiveTrueIds(id);
      }
    });
  });

  ws.on("message", function incoming(message) {
    console.log("Received: %s", message);
  });
  ws.on("close", function close() {
    console.log("Connection closed");
  });
  ws.on("error", function error(err) {
    console.error("WebSocket encountered error: ", err);
  });
});

server.listen(8989, () => {
  console.log("Server is running on http://localhost:8989");
});
