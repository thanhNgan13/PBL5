from flask import Flask, jsonify
from flask_cors import CORS, cross_origin
from flask import request
import os
from my_yolov6 import my_yolov6
import cv2
import numpy as np
from PIL import Image
import base64
import io

# Khởi tạo Flask Server Backend
app = Flask(__name__)

# Apply Flask CORS
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'
# app.config['UPLOAD_FOLDER'] = "static"

yolov6_model = my_yolov6("weights/best_ckpt.pt", "0", "data/data_test.yaml", 640, False)

@app.route('/', methods=['POST'] )
def predict_yolov6():
    image_base64 = request.form['file']
    image_data = base64.b64decode(image_base64)
    image = Image.open(io.BytesIO(image_data))
    image_array = np.array(image)
    image_array = cv2.cvtColor(image_array, cv2.COLOR_RGB2BGR)
    # cv2.imshow('image', image_array)
    
    if image_array is not None:
        # Nhận diên qua model Yolov6
        image_array, ndet, classes = yolov6_model.infer(image_array, conf_thres=0.618, iou_thres=0.5)

        # Convert the image array back to RGB
        image_array = cv2.cvtColor(image_array, cv2.COLOR_BGR2RGB)

        # Convert the image array back to a PIL image
        pil_image = Image.fromarray(image_array.astype('uint8'))

        # Convert the PIL image to a string
        byte_arr = io.BytesIO()
        pil_image.save(byte_arr, format='JPEG')
        endcoded_image = base64.encodebytes(byte_arr.getvalue()).decode('ascii')

        print(classes)

        # Trả về đường dẫn tới file ảnh đã bounding box
        return jsonify({'frame': endcoded_image,'objects_detected': ndet})

    return 'Upload file to detect'

# Start Backend
if __name__ == '__main__':
    app.run(host='172.20.10.2', port='6868')sadasdasdas