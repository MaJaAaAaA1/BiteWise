import mysql.connector
import os
from dotenv import load_dotenv, dotenv_values

load_dotenv()

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password=f"{os.getenv("DATABASE_PASSWORD")}",
    database="BiteWise"
)

mycursor = mydb.cursor()

def badRecipe(user):
    mycursor.execute(f"""SELECT DISTINCT ri.recipe_ID,
        r.title
    FROM fridge_inventories fi
        INNER JOIN recipe_ingredients ri ON ri.ingredient_ID = fi.ingredient_ID
        INNER JOIN recipes r ON r.recipe_ID = ri.recipe_ID
    WHERE fi.best_before_date BETWEEN CURRENT_DATE() AND CURRENT_DATE() + 2
        AND fi.user_ID = {user};""")
    return mycursor.fetchall()

def calculateNutrients():
    mycursor.execute("""SELECT ri.recipe_ID,
        SUM(i.kcal_per_100g / 100 * ri.required_amount),
        SUM(i.protein_per_100g / 100 * ri.required_amount)
    FROM recipe_ingredients ri
        INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    GROUP BY ri.recipe_ID;""")
    return mycursor.fetchall()

def unavailableRecipes(user):
    mycursor.execute(f"""SELECT DISTINCT *
FROM recipe_ingredients ri
    LEFT JOIN fridge_inventories fi ON ri.ingredient_ID = fi.ingredient_ID
WHERE fi.ingredient_ID IS NULL
    AND fi.user_ID = {user};""")
    return mycursor.fetchall()

def doesUserExist(email):
    mycursor.execute(f"""SELECT EXISTS(
        SELECT 1
        FROM Users
        WHERE Users.email = '{email}'
    )""")
    return mycursor.fetchall()[0][0]

def addUser(email, fname, lname):
    mycursor.execute(f"""INSERT INTO Users (email, first_name, last_name)
                        VALUES ("{email}", "{fname}", "{lname}");""")
    mydb.commit()
