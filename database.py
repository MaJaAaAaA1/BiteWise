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

# Compares fridgeinventory with recipe to make shoppinglist --
def generateShoppingList(user_id, recipe_id):
    sql = """SELECT i.ingredient_type, (ri.required_amount - COALESCE(fi.amount, 0)) AS amount_to_buy, i.standard_unit 
    FROM recipe_ingredients ri
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    LEFT JOIN fridge_inventories fi 
    ON ri.ingredient_ID = fi.ingredient_ID 
    AND fi.user_ID = %s
    WHERE ri.recipe_ID = %s
    AND (fi.amount IS NULL OR fi.amount < ri.required_amount);"""
    mycursor.execute(sql, (user_id, recipe_id))
    return mycursor.fetchall()

# recipes users can make that match what they have in their fridge inventory
def getCookableRecipes(user_id):
    sql = """SELECT r.recipe_ID, r.title, r.prep_time FROM Recipes r
    WHERE NOT EXISTS(SELECT * FROM recipe_ingredients ri LEFT JOIN fridge_inventories fi
    ON ri.ingredient_ID = fi.ingredient_ID AND fi.user_ID = %s
    WHERE ri.recipe_ID = r.recipe_ID
    AND (fi.amount IS NULL OR fi.amount < ri.required_amount));"""
    mycursor.execute(sql, (user_id))
    return mycursor.fetchall()


# daily check for makro goal
def checkDailyMacros(user_id, planned_date):
    sql = """SELECT mpr.planned_date, mp.target_calories,
    SUM(i.kcal_per_100g * ri.required_amount / 100) AS planned_calories, mp.target_protein,
    SUM(i.protein_per_100g * ri.required_amount / 100) AS planned_proteins
    FROM meal_plan_recipe mpr
    INNER JOIN meal_plans mp ON mpr.meal_plan_ID = mp.meal_plan_ID
    INNER JOIN recipes r ON mpr.recipe_ID = r.recipe_ID
    INNER JOIN recipe_ingredients ri ON r.recipe_ID = ri.recipe_ID
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    WHERE mp.user_ID = %s AND MPR.planned_date = %s
    GROUP BY mpr.planned_date, mp.target_calories, mp.target_protein;"""
    mycursor.execute(sql, (user_id, planned_date))

# filter vegan recipes
def getVeganRecipes():
    sql = """SELECT r.recipe_ID, r.title
    FROM recipes r
    WHERE NOT EXISTS(SELECT* FROM recipe_ingredients ri
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    WHERE ri.recipe_ID = r.recipe_ID AND i.is_vegan = FALSE);"""
    mycursor.execute(sql)
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

def addIngredientToFridge(user_id, ingredient_id, amount, best_before_date):
    sql = """INSERT INTO fridge_inventories (user_ID, ingredient_ID, amount, best_before_date)
        VALUES (%s, %s, %s, %s)"""
    values = (user_id, ingredient_id, amount, best_before_date)
    mycursor.execute(sql, values)
    mydb.commit()