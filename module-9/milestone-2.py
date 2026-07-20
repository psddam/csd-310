import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values

secrets = dotenv_values(".env")
 
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True #not in .env file
}

def show_tables(cursor, sql, title):
    cursor.execute(sql)
    records = cursor.fetchall()
    print("\n{}".format(title))

    if cursor.column_names:
        print(", ".join(cursor.column_names))
            
    for row in records:
        row_strings = [str(item) if item is not None else "NULL" for item in row]
        print(", ".join(row_strings))

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()
    
    show_tables(cursor, 'SELECT * FROM supplier', "-- DISPLAYING SUPPLIERS --")
    show_tables(cursor, 'SELECT * FROM delivery', "-- DISPLAYING DELIVERIES --")
    show_tables(cursor, 'SELECT * FROM delivery_item', "-- DISPLAYING DELIVERY ITEMS --")
    show_tables(cursor, 'SELECT * FROM inventory_item', "-- DISPLAYING INVENTORY ITEMS --")
    show_tables(cursor, 'SELECT * FROM distributor', "-- DISPLAYING DISTRIBUTORS --")
    show_tables(cursor, 'SELECT * FROM shipment', "-- DISPLAYING SHIPMENTS --")
    show_tables(cursor, 'SELECT * FROM shipment_wine', "-- DISPLAYING WINE SHIPMENTS --")
    show_tables(cursor, 'SELECT * FROM wine', "-- DISPLAYING WINES --")
    show_tables(cursor, 'SELECT * FROM department', "-- DISPLAYING DEPARTMENTS --")
    show_tables(cursor, 'SELECT * FROM employee', "-- DISPLAYING EMPLOYEES --")
    show_tables(cursor, 'SELECT * FROM timesheet', "-- DISPLAYING TIMESHEETS --")

except mysql.connector.Error as err:
    """ on error code """
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist")
    else:
        print(err)
 
finally:
    """ close the connection to MySQL """
    db.close()
