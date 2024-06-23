import cv2
import urllib.request
import numpy as np
import torch
from my_yolov6 import my_yolov6

yolov6_model = my_yolov6("weights/best_ckpt.pt", "0", "data/data_test.yaml", 640, False)

# Replace the URL with the IP camera's stream URL
url = 'https://hrl4vkc2-8999.asse.devtunnels.ms/client/image/Pbl50001'
cv2.namedWindow("live Cam Testing", cv2.WINDOW_AUTOSIZE)

# Create a VideoCapture object
cap = cv2.VideoCapture(url)
    
# Check if the IP camera stream is opened successfully
if not cap.isOpened():
    print("Failed to open the IP camera stream")
    exit()

# Read and display video frames
while True:
    # Read a frame from the video stream
    img_resp=urllib.request.urlopen(url)
    imgnp=np.array(bytearray(img_resp.read()),dtype=np.uint8)
    # ret, frame = cap.read()
    im = cv2.imdecode(imgnp,-1)

    im = cv2.resize(im, (640, 640))

    #run model on the image
    with torch.no_grad():
        im, ndet, classes = yolov6_model.infer(im, conf_thres=0.7, iou_thres=0.5)
    
    if 'fire' in classes:
        print('Fire detected')

    cv2.imshow('live Cam Testing',im)
    key=cv2.waitKey(5)

    if key==ord('q'):
        break

cap.release()
cv2.destroyAllWindows()