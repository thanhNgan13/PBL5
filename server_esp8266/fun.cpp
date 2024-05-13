#include <string>
#include <iostream>
using namespace std;

int getServoValue(string str) {
    size_t servoPos = str.find("servo:");
    if (servoPos != std::string::npos) {
        size_t startPos = str.find(" ", servoPos) + 1;
        size_t endPos = str.find(",", servoPos);
        std::string servoValueStr = str.substr(startPos, endPos - startPos);
        return std::stoi(servoValueStr);
    }
    return -1;
}

int getStepperValue(string str) {
    size_t stepperPos = str.find("stepper:");
    if (stepperPos != std::string::npos) {
        size_t startPos = str.find(" ", stepperPos) + 1;
        size_t endPos = str.find(",", stepperPos);
        std::string stepperValueStr = str.substr(startPos, endPos - startPos);
        return std::stoi(stepperValueStr);
    }
    return -1;
}

int main() {
    string message = "stepper: 90";
    if (message.find("servo:") != std::string::npos) {
        cout << "Servo value: " << getServoValue(message) << endl;
    }
    else if (message.find("stepper:") != std::string::npos) {
        cout << "Stepper value: " << getStepperValue(message) << endl;
    }
    else {
        cout << "Invalid message" << endl;
    }

    return 0;
}