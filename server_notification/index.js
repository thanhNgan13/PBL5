import { initializeApp, applicationDefault } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";
import express, { json } from "express";
import cors from "cors";
import { getDatabase } from "firebase-admin/database";

process.env.GOOGLE_APPLICATION_CREDENTIALS;

initializeApp({
  credential: applicationDefault(),
  projectId: "fire-warning-system-2d9c2",
  databaseURL:
    "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
});

const db = getDatabase();
const ref = db.ref("Accounts");

const app = express();
app.use(express.json());

app.use(
  cors({
    origin: "*",
  })
);

app.use(
  cors({
    methods: ["GET", "POST", "DELETE", "UPDATE", "PUT", "PATCH"],
  })
);

app.use(function (req, res, next) {
  res.setHeader("Content-Type", "application/json");
  next();
});

app.get("/send", function (req, res) {
  const message = {
    notification: {
      title: "Notification Title",
      body: "This is a Test Notification",
    },
    token:
      "cRkZab3kSsOQpF9J7B5jjz:APA91bEccVeUD0vZPMmKbDOd3f1SKd16poe6GjYGiK-qq3fWT890nKKIIu9LJXql2Ki3P_tJ--oH1W6xA2CKmugu_XIJDnJ4zNUgpQ7azKt7n8T3ZcOk4RQ2m5f0M3qBv_ZM8_4-EafT",
  };

  getMessaging()
    .send(message)
    .then((response) => {
      res.status(200).json({
        message: "Successfully sent message",
        token:
          "cRkZab3kSsOQpF9J7B5jjz:APA91bEccVeUD0vZPMmKbDOd3f1SKd16poe6GjYGiK-qq3fWT890nKKIIu9LJXql2Ki3P_tJ--oH1W6xA2CKmugu_XIJDnJ4zNUgpQ7azKt7n8T3ZcOk4RQ2m5f0M3qBv_ZM8_4-EafT",
      });
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      res.status(400);
      res.send(error);
      console.log("Error sending message:", error);
    });
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
const checkInterval = 20 * 1000; // 20 giây

function listenToStatusChange(userId) {
  const refAccount = db.ref(`Accounts/${userId}`);
  refAccount.on("value", (snapshot) => {
    const data = snapshot.val();
    const isAlertedNow = data.isAlerted === true;

    // Kiểm tra nếu đây là lần lắng nghe đầu tiên hoặc trạng thái thay đổi từ "false" sang "true"
    if (userStatus[userId] === undefined) {
      // Lần đầu tiên nghe thay đổi này
      if (isAlertedNow) {
        // Gửi thông báo nếu trạng thái ban đầu là "true"
        sendAlert(userId, data.token);
      }
    } else if (!userStatus[userId].alerted && isAlertedNow) {
      // Trạng thái thay đổi từ "false" sang "true"
      sendAlert(userId, data.token);
    }

    // Cập nhật trạng thái mới
    userStatus[userId] = { alerted: isAlertedNow };
  });
}

function periodicallyCheckAndAlert() {
  const accountsRef = db.ref("Accounts");
  accountsRef.once("value", (snapshot) => {
    snapshot.forEach((childSnapshot) => {
      const userId = childSnapshot.key;
      const userData = childSnapshot.val();
      const isAlertedNow = userData.isAlerted === true;
      const timeSinceLastAlert =
        Date.now() - (userStatus[userId]?.lastAlerted || 0);

      if (
        isAlertedNow &&
        (timeSinceLastAlert > checkInterval || !userStatus[userId]?.lastAlerted)
      ) {
        sendAlert(userId, userData.token);
        userStatus[userId] = { alerted: true, lastAlerted: Date.now() };
      }
    });
  });
}

// Đặt hàm kiểm tra định kỳ mỗi 10 phút
setInterval(periodicallyCheckAndAlert, 10 * 60 * 1000);

function sendAlert(userId, token) {
  console.log(`token: ${token}`);
  const message = {
    data: {
      title: "Fire Alert",
      body: "There is a fire near your location",
    },

    android: {
      notification: {
        icon: "stock_ticker_update",
        color: "#7e55c3",
        sound: "notification",
      },
    },
    token: token,
  };

  getMessaging()
    .send(message)
    .then((response) => {
      console.log(`Successfully sent message to ${userId}`);
    })
    .catch((error) => {
      console.log("Error sending message:", error);
    });
}

app.listen(7777, function () {
  setInterval(periodicallyCheckAndAlert, 20 * 1000); // 10 phút
  console.log("Server started on port 7777");
});
