from flask import Flask, render_template, request, jsonify
from flask_socketio import SocketIO
import base64
import io
import numpy as np
from PIL import Image
import cv2
from my_yolov6 import my_yolov6


app = Flask(__name__)
app.config['SECRET_KEY'] = 'thanhNgan13'
socketio = SocketIO(app)
yolov6_model = my_yolov6("weights/best_ckpt.pt", "0", "data/data_test.yaml", 640, False)


@app.route('/esp8266', methods=['POST'])
def esp8266_signal():
    global dataESP8266
    dataESP8266 = request.json
    print("Đã nhận dữ liệu từ ESP8266:", dataESP8266)
    socketio.emit('update_data', {'message': dataESP8266})
    return "Dữ liệu đã được nhận", 200


@app.route('/data-for-esp32cam')
def data_for_esp32cam():
    try:
        return jsonify(dataESP8266)
    except NameError:
        return jsonify({"error": "Dữ liệu chưa sẵn sàng"}), 404


@app.route('/data-from-esp32cam', methods=['POST'])
def data_for_esp32cam_post():
    data = request.json
    image_base64 = data['image']
    image_data = base64.b64decode(image_base64)
    image = Image.open(io.BytesIO(image_data))

    img_io = io.BytesIO()
    image.save(img_io, 'JPEG')
    img_io.seek(0)
    frame = img_io.read()

    print("Đã nhận dữ liệu từ ESP32CAM:")
    return "Dữ liệu đã được nhận", 200


@app.route('/')
def main():
    return render_template('index.html')


if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0')