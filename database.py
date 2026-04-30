import mysql.connector
import os
from dotenv import load_dotenv, dotenv_values

load_dotenv()

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password=f"{os.getenv("DATABASE_PASSWORD")}"
)

mycursor = mydb.cursor()

mycursor.execute("SHOW DATABASES")

for x in mycursor:
  print(x)