const WebSocket = require("ws");
const express = require("express");
const http = require("http");
const fs = require("fs");

const app = express();
const server = http.createServer(app);
const port = 8999;
const ESPWebSocket = new WebSocket.Server({ noServer: true });

let devicesESP32CAM = {}; // Lưu trữ danh sách các ESP32CAM kết nối và hình ảnh của nó
let flagAudio = 0; // Đếm số lượng

function handleBinaryData(ws, data) {
  if (ws.dataType === "IMAGE") {
    const imgBase64 = Buffer.from(data).toString("base64");
    devicesESP32CAM[ws.esp32camID].imgBase64 = imgBase64;
    devicesESP32CAM[ws.esp32camID].image = data;
    console.log(`Image received from ${ws.esp32camID}`);
    broadcastImage(ws.esp32camID, imgBase64, data);
  } else if (ws.dataType === "AUDIO") {
    // Khởi tạo mảng lưu trữ dữ liệu âm thanh nếu chưa có
    if (!ws.audioDataBuffer) {
      ws.audioDataBuffer = [];
    }

    // Nếu nhận được dữ liệu âm thanh, lưu trữ vào mảng thay
    ws.audioDataBuffer.push(data);

    // Hiển thị trạng thái để theo dõi
    process.stdout.write(".");
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
  } else if (pathname === "/display") {
    ESPWebSocket.handleUpgrade(request, socket, head, (ws) => {
      ESPWebSocket.emit("connection", ws, request, "/display");
    });
  } else {
    socket.destroy();
  }
});

// Xử lý kết nối cho đường dẫn /display
ESPWebSocket.on("connection", (ws, request, path) => {
  ws.path = path; // Lưu trữ đường dẫn của client
  ws.dataType = ""; // Khởi tạo kiểu dữ liệu

  console.log(`Client connected to ${path}`);
  if (path === "/sendImage") {
    ws.on("message", function (data) {
      try {
        if (typeof data === "string") {
          // Xử lý metadata để phân biệt giữa hình ảnh và âm thanh
          if (data === "IMAGE") {
            ws.dataType = "IMAGE"; // Thiết lập kiểu dữ liệu là hình ảnh
            console.log("Result: " + data);
          } else if (data === "AUDIO") {
            ws.dataType = "AUDIO"; // Thiết lập kiểu dữ liệu là âm thanh
            console.log("Result: " + data);
          } else if (data.startsWith("Pbl")) {
            ws.esp32camID = data;
            devicesESP32CAM[data] = { socket: ws, image: null };
            console.log("ESP32CAM ID registered: " + data);
          } else if (data === "END AUDIO") {
            // Kết thúc ghi âm
            console.log("\nAUDIO RECEIVED");
            const filePathAudio = `audio_${ws.esp32camID}.wav`;
            // Kết hợp toàn bộ các phần dữ liệu trong mảng lại thành một buffer duy nhất
            const fullAudioData = Buffer.concat(ws.audioDataBuffer);
            // Ghi toàn bộ dữ liệu vào file một lần
            fs.writeFileSync(filePathAudio, fullAudioData);
            console.log(`\nAudio file saved for ESP32CAM: ${ws.esp32camID}`);
            ws.dataType = ""; // Reset data type
            // Xóa bộ nhớ tạm lưu dữ liệu sau khi đã ghi file
            ws.audioDataBuffer = [];
            ws.send("AUDIO RECEIVED");
          } else if (data === "END IMAGE") {
            // Kết thúc ghi âm
            console.log("IMAGE RECEIVED");
            ws.dataType = ""; // Reset data type
            ws.send("IMAGE RECEIVED");
          }
        } else {
          // Nhận dữ liệu nhị phân và xử lý
          handleBinaryData(ws, data);
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
  }
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
