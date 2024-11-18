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

@app.route('/')
def index():
    return render_template('booking.html')

@app.route('/get_flights')
def get_flights():
    try:
        cursor.execute("SELECT flight_id, flight_number, source, destination FROM Flights")
        flights = cursor.fetchall()
        return jsonify([{
            'flight_id': flight[0],
            'flight_number': flight[1],
            'source': flight[2],
            'destination': flight[3]
        } for flight in flights])
    except Error as e:
        return jsonify({'error': str(e)}), 500

@app.route('/get_available_seats/<int:flight_id>')
def get_available_seats(flight_id):
    try:
        cursor.execute("""
            SELECT seat_number 
            FROM Seat_Allocation 
            WHERE flight_id = %s AND status = 'Available'
        """, (flight_id,))
        seats = cursor.fetchall()
        return jsonify([{'seat_number': seat[0]} for seat in seats])
    except Error as e:
        return jsonify({'error': str(e)}), 500

@app.route('/book_flight', methods=['POST'])
def book_flight():
    try:
        data = request.json
        
        # Insert new passenger
        cursor.execute("""
            INSERT INTO Passengers (passenger_id, first_name, last_name, seat_preference, class)
            VALUES (NULL, %s, %s, %s, %s)
        """, (data['first_name'], data['last_name'], data['seat_preference'], data['class']))
        
        passenger_id = cursor.lastrowid
        
        # Create booking
        cursor.execute("""
            INSERT INTO Booking (booking_id, flight_id, passenger_id, seat_number)
            VALUES (NULL, %s, %s, %s)
        """, (data['flight_id'], passenger_id, data['seat_number']))
        
        mydb.commit()
        
        return jsonify({
            'status': 'success',
            'message': 'Booking successful!'
        })
    except Error as e:
        mydb.rollback()
        return jsonify({
            'status': 'error',
            'message': f'Booking failed: {str(e)}'
        }), 500

if __name__ == '__main__':
    app.run(debug=True)