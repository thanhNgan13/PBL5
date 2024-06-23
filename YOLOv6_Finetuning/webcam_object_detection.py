import cv2
import torch
from my_yolov6 import my_yolov6
from firebase_tool import Firebase

# Khởi tạo mô hình phát hiện đối tượng
yolov6_model = my_yolov6("weights/best_ckpt.pt", "0", "data/data_test.yaml", 640, False)
# Mở webcam
cap = cv2.VideoCapture(0)

isFire = False

while True:
    # Đọc khung hình từ webcam esp32-cam
    ret, frame = cap.read()
    # frame = cv2.imread

    if not ret:
        print("Error: Unable to read frame from video capture")
        break

    # Áp dụng mô hình phát hiện đối tượng
    with torch.no_grad():
        frame, ndet, classes = yolov6_model.infer(frame, conf_thres=0.6, iou_thres=0.45)

    cv2.imshow('frame', frame)

    torch.cuda.empty_cache()

    # if 'fire' in classes:
    #     isFire = True
    #     Firebase().push('fire', 'Fire detected')
    # else:
    #     isFire = False

    # Nhấn 'q' để thoát
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()