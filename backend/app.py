import gspread
from flask import Flask, request, jsonify
from oauth2client.service_account import ServiceAccountCredentials
import random
import string

# Google Sheets API setup
USER_SHEET_ID = "1loGQ_HK_peXlTTdj5KJUX3PmQdUNn-KFLZHjIxgsDhI"
PRODUCT_SHEET_ID = "1oSid63yOUo5arZg5u8zA8eerx2UU3xR3KWxYPrrBE5I"  # Replace with your actual Product Sheet ID

SCOPES = ["https://www.googleapis.com/auth/spreadsheets.readonly", "https://www.googleapis.com/auth/spreadsheets"]
creds = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', SCOPES)
client = gspread.authorize(creds)

# Access the sheet
user_sheet = client.open_by_key(USER_SHEET_ID).sheet1
product_sheet = client.open_by_key(PRODUCT_SHEET_ID).sheet1  # Access the first sheet in the Product Sheet

app = Flask(__name__)

# Helper function to check if a username exists
def username_exists(username):
    usernames = user_sheet.col_values(1)  # Get all usernames from column 1
    return username in usernames

# Helper function to get the password and user ID for a username
def get_user_data(username):
    usernames = user_sheet.col_values(1)
    index = usernames.index(username) + 1  # Google Sheets is 1-indexed
    password = user_sheet.cell(index, 3).value  # Column 3 has passwords
    user_id = user_sheet.cell(index, 2).value  # Column 2 has UserID
    return password, user_id

# Helper function to add a new user
def create_user(username, password):
    # Create a unique UserID
    user_id = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    
    # Add user details to the Google Sheet (Username, UserID, Password)
    user_sheet.append_row([username, user_id, password])
    return user_id

# API Endpoint for login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if username_exists(username):
        stored_password, user_id = get_user_data(username)
        if password == stored_password:
            return jsonify({"message": "Login successful", "username": username, "user_id": user_id}), 200
        else:
            return jsonify({"message": "Incorrect password"}), 400
    else:
        return jsonify({"message": "Username not found"}), 404

# API Endpoint for creating an account
@app.route('/create_account', methods=['POST'])
def create_account():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    if username_exists(username):
        return jsonify({"message": "Account can't be created, Username exists"}), 400

    if password == confirm_password:
        user_id = create_user(username, password)
        return jsonify({"message": "Account created successfully", "user_id": user_id}), 201
    else:
        return jsonify({"message": "Passwords do not match"}), 400
    #home
    # Route to fetch all users
@app.route('/users', methods=['GET'])
def get_users():
    users = user_sheet.get_all_records()
    return jsonify(users)

@app.route('/products', methods=['GET'])
def get_products():
    # Get the status filter from the query parameters (defaults to "Active")
    status_filter = request.args.get('status', 'All')  # Default to 'All' for no filtering

    # Fetch all products
    products = product_sheet.get_all_records()

    # Function to convert Google Drive URL to a direct image URL
    def get_direct_image_url(drive_url):
        file_id = drive_url.split('/d/')[1].split('/')[0]
        return f"https://drive.google.com/uc?id={file_id}"

    # Format the data to match the structure expected by the frontend
    formatted_products = [
        {
            'product_id': product['Product ID'],
            'product_name': product['Product Name'],
            'product_image': get_direct_image_url(product['Product Image URL']),  # Convert the URL
            'status': product['Status'],
            'bid_amount': product['Bid Amount']
        }
        for product in products if status_filter == 'All' or product['Status'] == status_filter

    ]
    
    return jsonify(formatted_products)


if __name__ == '__main__':
    app.run(debug=True)
