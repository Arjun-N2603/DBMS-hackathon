from flask import Flask, render_template, request, jsonify
import mysql.connector
from mysql.connector import Error

from config import DATABASE_HOST, DATABASE_USER, DATABASE_PASSWORD, DATABASE_NAME

app = Flask(__name__)

# Database connection configuration
try:
    mydb = mysql.connector.connect(
        host=DATABASE_HOST,
        user=DATABASE_USER,
        password=DATABASE_PASSWORD,
        database=DATABASE_NAME
    )
    cursor = mydb.cursor()

    print("Database connection successful!")

    # Test the connection (optional):
    cursor.execute("SELECT VERSION()")
    data = cursor.fetchone()
    print("Database version:", data)

except mysql.connector.Error as err:
    print(f"Database connection failed: {err}")


if __name__ == '__main__':
    app.run(debug=True)