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

  let statusCO_1, statusCO_2, statusCO_3, statusCO_4;
  const ids = [];

  const refESP8266_1 = db.ref("ESP8266_1/Outputs/Status_CO");
  ids[1] = refESP8266_1.parent.parent.key;
  refESP8266_1.on("value", (snapshot) => {
    statusCO_1 = snapshot.val();
  });

  const refESP8266_2 = db.ref("ESP8266_2/Outputs/Status_CO");
  ids[2] = refESP8266_2.parent.parent.key;
  refESP8266_2.on("value", (snapshot) => {
    statusCO_2 = snapshot.val();
  });

  const refESP8266_3 = db.ref("ESP8266_3/Outputs/Status_CO");
  ids[3] = refESP8266_3.parent.parent.key;
  refESP8266_3.on("value", (snapshot) => {
    statusCO_3 = snapshot.val();
  });

  const refESP8266_4 = db.ref("ESP8266_4/Outputs/Status_CO");
  ids[4] = refESP8266_4.parent.parent.key;
  refESP8266_4.on("value", (snapshot) => {
    statusCO_4 = snapshot.val();
  });

  const intervalId = setInterval(() => {
    [statusCO_1, statusCO_2, statusCO_3, statusCO_4].forEach(
      (status, index) => {
        if (status === "WARNING!!!") {
          if (ws.readyState === WebSocket.OPEN) {
            console.log("Sending warning message to client");
            ws.send(`${ids[index + 1]}`);
          }
        }
      }
    );
  }, 1000); // Adjusted interval to 1000 milliseconds

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

server.listen(8888, () => {
  console.log("Server is running on http://localhost:8888");
});
