const WebSocket = require("ws");
const express = require("express");
const http = require("http");
const admin = require("firebase-admin");
var axios = require("axios");

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
const port = 8999;
const ESPWebSocket = new WebSocket.Server({ noServer: true });

let devicesESP32CAM = {}; // Lưu trữ danh sách các ESP32CAM kết nối và hình ảnh của nó
let devicesESP8266 = {}; // Lưu trữ danh sách các ESP8266 kết nối
let devicesESP8266_buzzer = {}; // Lưu trữ danh sách các ESP8266 kết nối

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
  ESPWebSocket.clients.forEach(function (client) {
    if (client.readyState === WebSocket.OPEN && client.path === "/display") {
      client.send(JSON.stringify({ id, imgBase64, image }));
    }
  });
}

// Manually handle upgrade requests
server.on("upgrade", (request, socket, head) => {
  const pathname = new URL(request.url, `http://${request.headers.host}`)
    .pathname;
  if (pathname === "/sendImage") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/sendImage");
    });
  } else if (pathname === "/control") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/control");
    });
  } else if (pathname === "/display") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/display");
    });
  } else if (pathname === "/esp8266") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/esp8266");
    });
  } else if (pathname === "/esp8266_buzzer") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/esp8266_buzzer");
    });
  } else {
    socket.destroy();
  }
});

// Xử lý kết nối cho đường dẫn /display
ESPWebSocket.on("connection", (ws, request, path) => {
  ws.path = path; // Lưu trữ đường dẫn của client
  console.log(`Client connected to ${path}`);
  if (path === "/sendImage") {
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
      console.log(`Client ESP32CAM ${ws.esp32camID} disconnected`);
      delete devicesESP32CAM[ws.esp32camID];
    });
  } else if (path === "/display") {
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
  } else if (path === "/control") {
    ws.on("message", function (data) {
      try {
        const message = JSON.parse(data);
        console.log("Control message received: ", message);
        const esp32camID = message.id;
        if (devicesESP32CAM[esp32camID]) {
          switch (message.type) {
            case "buzzer":
              handleBuzzerCommand(
                message.data,
                devicesESP8266_buzzer[esp32camID].socket
              );
              break;
            case "servo":
              handleServoCommand(
                message.data,
                devicesESP32CAM[esp32camID].socket
              );
              break;
            case "Stepper":
              handleStepperCommand(
                message.data,
                devicesESP8266[esp32camID].socket
              );
            case "light":
              handleLightCommand(
                message.data,
                devicesESP32CAM[esp32camID].socket
              );
              break;
            default:
              console.log("Unknown command type:", message.type);
          }
        }
      } catch (error) {
        console.error("Error handling control message: ", error);
      }
    });

    ws.on("error", function (error) {
      console.error("Error in control connection: ", error);
    });
  } else if (path === "/esp8266") {
    // Hàm để gửi thông điệp từ hàng đợi
    function sendNextMessage(device) {
      if (!device.sending && device.messageQueue.length > 0) {
        device.sending = true;
        const message = device.messageQueue.shift();
        device.socket.send(message.toString(), () => {
          device.sending = false;
          // Gọi lại hàm để gửi thông điệp tiếp theo trong hàng đợi
          // Gọi đến đường dẫn sau khi gửi thông điệp
          const url = `https://hrl4vkc2-6868.asse.devtunnels.ms/detect_fire?id=${device.socket.esp8266ID}`;
          axios
            .get(url)
            .then(function (response) {
              console.log(
                `Axios call response for ${device.socket.esp8266ID}: `,
                response.data
              );
            })
            .catch(function (error) {
              console.error(
                `Axios call error for ${device.socket.esp8266ID}: `,
                error
              );
            });

          // Gọi lại hàm để gửi thông điệp tiếp theo trong hàng đợi
          sendNextMessage(device);
        });
      }
    }

    ws.on("message", function (data) {
      try {
        if (typeof data === "string" && !devicesESP8266[ws.esp8266ID]) {
          ws.esp8266ID = data;
          devicesESP8266[data] = {
            socket: ws,
            messageQueue: [],
            sending: false,
          };
          console.log("ESP8266 ID registered: " + data);
          const ids = ["ESP8266_1", "ESP8266_2", "ESP8266_3", "ESP8266_4"];
          const statuses = {};
          let activeTrueIds = []; // Mảng lưu giữ các ID có trạng thái true
          let messageCounter = 0; // Biến đếm để theo dõi số lần đã gửi thông điệp

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
              const isAlertedNow = data.isAlerted === true;
              const code = data.code;

              if (userStatus[userId] === undefined) {
                if (isAlertedNow) {
                  if (devicesESP32CAM[code]) {
                    devicesESP8266_buzzer[code].socket.send("TURN ON BUZZER");
                  } else {
                    console.log("Device not found for code: ", code);
                  }
                }
              } else if (!userStatus[userId].alerted && isAlertedNow) {
                if (devicesESP32CAM[code]) {
                  devicesESP8266_buzzer[code].socket.send("TURN ON BUZZER");
                } else {
                  console.log("Device not found for code: ", code);
                }
              }
              // Cập nhật trạng thái mới
              userStatus[userId] = { alerted: isAlertedNow };
            });
          }

          listenToAllUserStatusChanges();

          function updateAndSendActiveTrueIds(id) {
            if (statuses[id] === "true" && !activeTrueIds.includes(id)) {
              // Thêm vào mảng nếu trạng thái là true và chưa có trong mảng
              activeTrueIds.push(id);
            } else if (statuses[id] === "false" && activeTrueIds.includes(id)) {
              // Loại bỏ khỏi mảng nếu trạng thái chuyển thành false
              activeTrueIds = activeTrueIds.filter((item) => item !== id);
            }

            // Kiểm tra nếu bất kỳ cảm biến nào trong ids chuyển qua true
            const anyTrue = ids.some(
              (sensorId) => statuses[sensorId] === "true"
            );
            if (anyTrue) {
              const url = `https://hrl4vkc2-6868.asse.devtunnels.ms/detect_fire?id=${ws.esp8266ID}`;
              axios
                .get(url)
                .then(function (response) {
                  console.log(
                    `Axios call response for ${ws.esp8266ID}: `,
                    response.data
                  );
                })
                .catch(function (error) {
                  console.error(
                    `Axios call error for ${ws.esp8266ID}: `,
                    error
                  );
                });
            }
            // Gửi mảng cập nhật qua WebSocket cho tất cả các thiết bị ESP8266
            if (devicesESP8266[ws.esp8266ID]) {
              devicesESP8266[ws.esp8266ID].socket.send(
                JSON.stringify(activeTrueIds)
              );
            } else {
              console.log("Device not found for code: ", ws.esp8266ID);
            }
          }
          ids.forEach((id, index) => {
            const ref = db.ref(`Sensor/${ws.esp8266ID}/${id}/Status`);
            ref.on("value", (snapshot) => {
              const previousStatus = statuses[id];
              statuses[id] = snapshot.val();
              // Chỉ gửi cập nhật nếu có sự thay đổi trạng thái
              if (statuses[id] !== previousStatus) {
                console.log("ID: ", id, " Status: ", statuses[id]);
                updateAndSendActiveTrueIds(id);
              }
            });
          });

          // // Schedule a message to be sent to the ESP8266 every 2 minutes
          // const intervalId = setInterval(() => {
          //   if (devicesESP8266[ws.esp8266ID]) {
          //     // Ensure the device still exists
          //     messageCounter++; // Tăng biến đếm mỗi khi interval xảy ra
          //     let message;
          //     if (messageCounter % 2 === 1) {
          //       message = "turnstp: 4095";
          //       console.log("Queueing message: ", message);
          //     } else {
          //       message = "turnstp: -4095";
          //       console.log("Queueing message: ", message);
          //     }

          //     // Đẩy thông điệp vào hàng đợi và gọi hàm để gửi thông điệp
          //     devicesESP8266[ws.esp8266ID].messageQueue.push(message);
          //     sendNextMessage(devicesESP8266[ws.esp8266ID]);
          //   } else {
          //     console.log("Device not found for code: ", ws.esp8266ID);
          //   }
          // }, 20000); // 120,000 milliseconds = 2 minutes

          // Store the intervalId to clear it if the connection closes
          // ws.intervalId = intervalId;
        }
        // else if (typeof data === "string" && !isNaN(parseInt(data))) {
        //   // Xử lý các thông điệp điều khiển khác
        //   const controlMessage = parseInt(data);
        //   console.log("Received control message: ", controlMessage);
        //   if (devicesESP8266[ws.esp8266ID]) {
        //     devicesESP8266[ws.esp8266ID].messageQueue.push(controlMessage);
        //     sendNextMessage(devicesESP8266[ws.esp8266ID]);
        //   } else {
        //     console.log("Device not found for code: ", ws.esp8266ID);
        //   }
        // }
      } catch (error) {
        console.error("Error handling message from ESP8266: ", error);
      }
    });

    ws.on("error", function (error) {
      console.error("Error in ESP8266 connection: ", error);
    });

    ws.on("close", function () {
      console.log(`Client ESP8266 ${ws.esp8266ID} disconnected`);
      // if (ws.intervalId) {
      //   clearInterval(ws.intervalId);
      // }
      delete devicesESP8266[ws.esp8266ID];
    });
  } else if (path === "/esp8266_buzzer") {
    ws.on("message", function (data) {
      try {
        if (
          typeof data === "string" &&
          !devicesESP8266_buzzer[ws.esp8266ID_buzzer]
        ) {
          ws.esp8266ID_buzzer = data;
          devicesESP8266_buzzer[data] = { socket: ws };
          console.log("ESP8266 Buzzer ID registered: " + data);
        }
      } catch (error) {
        console.error("Error handling message from ESP8266 Buzzer: ", error);
      }
    });

    ws.on("error", function (error) {
      console.error("Error in ESP8266 Buzzer connection: ", error);
    });

    ws.on("close", function () {
      console.log(`Client ESP8266 Buzzer ${ws.esp8266ID_buzzer} disconnected`);
      delete devicesESP8266_buzzer[ws.esp8266ID_buzzer];
    });
  }
});

function handleBuzzerCommand(data, socket) {
  if (data.action === "on") {
    console.log("Turning on buzzer");
    socket.send("TURN ON BUZZER");
  } else if (data.action === "off") {
    console.log("Turning off buzzer");
    socket.send("TURN OFF BUZZER");
  }
}

function handleServoCommand(data, socket) {
  if (data.position !== undefined) {
    console.log(`Setting servo position to: ${data.position}`);
    socket.send(`servo: ${data.position}`);
  }
}

function handleStepperCommand(data, socket) {
  if (data.step !== undefined) {
    console.log(`Setting stepper step to: ${data.step}`);
    socket.send(`stepper: ${data.step}`);
  }
}

function handleLightCommand(data, socket) {
  if (data.state === "on") {
    console.log("Turning on light");
    socket.send("TURN ON LED");
  } else if (data.state === "off") {
    console.log("Turning off light");
    socket.send("TURN OFF LED");
  }
}

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

app.get("/local/videos/:esp32camID", (req, res) => {
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

app.get("/network/videos/:esp32camID", (req, res) => {
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
              const ws = new WebSocket("wss://hrl4vkc2-8999.asse.devtunnels.ms/display");
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

// Start the HTTP server
server.listen(port, () => {
  console.log("Server is start https://hrl4vkc2-8999.asse.devtunnels.ms/");
});
