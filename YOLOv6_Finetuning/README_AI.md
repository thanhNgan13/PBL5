1. Tree folder
    - configs: This directory contains configuration files for the YOLOv6 model. These files specify parameters for the model, the training process, and other settings.

    - data: This directory contain scripts for loading and augmenting data, as well as possibly the data itself. The scripts used to prepare the data for training the model.
        + images: include a set images of training, validation, testing dataset.
        + labels: include a set labels of training, validation, testing dataset.
        + link dataset: https://universe.roboflow.com/detection-e83li/smokeandfire/dataset/2/download

    - deploy: This directory contains scripts and instructions for deploying the trained model. This include scripts for running the model on different platforms or devices, converting the model to different formats, and so on.

    - docs: This directory contains documentation for the project. This include instructions for training the model, explanations of the model architecture, and so on.

    - runs: This directory contain outputs from training runs, such as trained models, logs, and visualizations.

    - tools: This directory contains utility scripts that are used in various parts of the project. This include scripts for evalution, inference, training and so on.
        + eval.py
        + infer.py
        + train.py
    - svr_call_API.py: Test server for calling API in order to use model for detection
    - svr_model.py: Server for detection
    - webcam_object_detection.py: Detect fire by laptop's webcam
    - cam_esp8266.py: Detect fire by esp8266
    - firebase_tool: Send and Get data from the server firebase

2. Requiments:
    - All requirments for the system are listed in the requirements file
    
3. Training Instruction:
    - Yolov6_train.ipynb: This file is designed to be used on Google Colab for training a YOLOv6 model with a custom dataset. Click "Run All" ton begin the    training process