import pickle
from flask import Flask, render_template, request
import os
from random import random
import cv2
import requests
import json
import base64
from PIL import Image
import io

# Initialize Flask
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = "static"

# Function to handle requests
@app.route("/", methods=['GET', 'POST'])
def home_page():
    # If it's a POST (file upload)
    if request.method == "POST":
        try:
            # Get the uploaded file    
            image = request.files['file']
            if image:
                # Save the file
                path_to_save = os.path.join(app.config['UPLOAD_FOLDER'], image.filename)
                print("Save = ", path_to_save)
                image.save(path_to_save)

                # URL of the API
                url = "http://172.20.10.2:6868"

                # Open the image file in binary mode
                with open(path_to_save, 'rb') as image:
                    image_data = image.read()

                # Encode the image in base64
                encoded_image = base64.b64encode(image_data).decode('ascii')

                # Define the data to send
                data = {'file': encoded_image}

                # Send the POST request with the data
                response = requests.post(url, data=data)

                # Make sure to close the image file
                image.close()

                # Get the result from the API
                result = json.loads(response.text)

                # Ensure 'ndet' is always defined
                ndet = result.get('objects_detected', 0)
                print(ndet)
                
                if ndet != 0:
                    image_data = base64.b64decode(result['frame'])
                    image = Image.open(io.BytesIO(image_data))
                    image.save(path_to_save)

                    relative_path = os.path.relpath(path_to_save, start=app.config['UPLOAD_FOLDER'])
                    print(relative_path)
                    
                    # Return the result
                    return render_template("index.html", user_image=relative_path, rand=str(random()),
                                           msg="File uploaded successfully", ndet= ndet)
                else:
                    return render_template('index.html', msg='No objects detected')
            else:
                # If there's no file, ask for one
                return render_template('index.html', msg='Please select a file to upload')

        except Exception as ex:
            # If there's an error, report it
            print(ex)
            return render_template('index.html', msg='Could not process image')

    else:
        # If it's a GET, display the upload interface
        return render_template('index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)