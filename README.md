# idp_parking_app (SPark)

SPark (Smart Parking) App is the frontend side of our Smart Parking Payment System, which was developed for the Integrated Design Project (IDP). IDP is a 3rd year programme held by the Electrical Engineering Department of Universiti Malaya (UMEE).

Smart Parking Payment System is developed to assist UMEE students to find empty parking spots and help automate the payments through license plate recognition. It also aims to fulfil IDP 2022 theme: United Nations' 11th Sustainable Development Goals (SDG) - To Encourage Urban Living. 

The project consists of 2 main parts:
1. License Plate Recognition System
2. E-wallet App (SPark)

### License Plate Recognition System

The plate recognition system was developed to track incoming and outgoing vehicles, determine parked duration and determine the current number of vacant parking spots. The system also portable to enable it to be installed anywhere near faculty entrances. OpenCV library is used to develop the recognition system and train it to only detect "license-plate-like" optical characters.

- Platform: Raspberry Pi 3B+
- Language: Python (via MicroPython)
- Libraries: OpenCV
- Database: Firebase Realtime Database

### SPark 

SPark is the e-wallet app for our parking system. It supports user authentication. Users can sign up to register their plate number and start using it to automatically pay for parking. However, note that only the actual payment part is a mockup.

- Platform: iOS and Android Devices
- Language: Dart
- Framework: Flutter
- Database: Firebase Realtime Database

Other notable features include:

- Onboarding
- User Authentication
- Parking Statistics
- Auto Reload
- App Persistence
- Asynchronous Actions
- Input Validation
- State & Context Management

## Installation

_Note: The source code is hosted in this repository for code-reviewing purposes. Installation is not recommended without its database and license plate recognition system running._

- Go to desired project directory
- Run git clone command with the copied repository HTTP URL
- ```$ git clone https://github.com/hazimrzk/idp_parking_app.git```
- Or download code .zip file and decompress.
- Open terminal in VS Code or Android Studio
- Go to pubspec.yaml for and run `pub get` to install any dependencies
- Build and run project
