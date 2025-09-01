from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc
import bcrypt

app = Flask(__name__)
CORS(app)

server_name = 'asset-management-server-with-aba.database.windows.net'
database_name = 'AssetManagementSystemDB'
username = 'talram'
password = '561240Tal?'
driver = '{ODBC Driver 17 for SQL Server}'

connection_string = f"DRIVER={driver}; SERVER={server_name}; DATABASE={database_name}; UID={username}; PWD={password}"

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password").encode('utf-8')

    try:
        connection = pyodbc.connect(connection_string)
        cursor = connection.cursor()

        cursor.execute("SELECT password_hash, first_name FROM landlord WHERE email=?", email)
        result = cursor.fetchone()

        if result and bcrypt.checkpw(password, result[0].encode('utf-8')):
            return jsonify({"success": True, "userName": result[1], "message": "Login successful."}), 200
        else:
            return jsonify({"success": False, "message": "Invalid credentials."}), 401
    
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
    
    finally:
        if 'connection' in locals() and connection:
            connection.close()

if __name__ == "__main__":
    app.run(debug=True)
