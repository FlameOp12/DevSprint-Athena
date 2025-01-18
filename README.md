# Timeless Treasures

Timeless Treasures is a vintage product bidding platform that allows users to explore and bid on rare and nostalgic items. This project includes a Flutter-based front-end and a Flask-based back-end, integrated with Google Sheets for user and product management.

---

## Features

- *User Authentication:* Create accounts, log in, and manage users via Google Sheets.
- *Product Listings:* Browse vintage products with details like images, status, and bid amounts.
- *Real-Time API:* Flask-based backend APIs for user and product operations.
- *Integration with Google Sheets:* Easy management of user and product data.

---
Install Flutter On Linux Ubuntu(Recommended). Run these commands:
1) sudo apt update
2) sudo apt install snapd
3) sudo snap install flutter --classic
4) flutter --version
5) flutter doctor
6) install flutter and dart extension
refer flutter intsallion youtube video link: https://youtu.be/32uMbzEt49s?si=uV2njZHTZuvrhVO1

In another terminal, navigate to frontend folder. Run these commands:
1) cd frontend
2) flutter pub get

 
Open the code in VS code editor. 
Open /frontend/lib/main.dart file. 
Click on the Run button above then Run without Debugging.
The App will open now.
## Installation
(refer to requirements.txt for any mismatches in versions)

### Step 1: Clone the Repository
Clone the project repository to your local machine.


git clone <repository_url>
cd DevSprint-Athena

### Step 2: Backend
Python shall be installed. Run these commands:
1) cd backend
2) pip install flask gspread oauth2client flask-cors
3) python app.py

### track backend changes from below google sheets used:
https://docs.google.com/spreadsheets/d/1oSid63yOUo5arZg5u8zA8eerx2UU3xR3KWxYPrrBE5I/edit?usp=sharing
https://docs.google.com/spreadsheets/d/1loGQ_HK_peXlTTdj5KJUX3PmQdUNn-KFLZHjIxgsDhI/edit?usp=sharing

