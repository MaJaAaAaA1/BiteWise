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
    sql = """SELECT DISTINCT ri.recipe_ID,
        r.title
    FROM fridge_inventories fi
        INNER JOIN recipe_ingredients ri ON ri.ingredient_ID = fi.ingredient_ID
        INNER JOIN recipes r ON r.recipe_ID = ri.recipe_ID
    WHERE fi.best_before_date BETWEEN CURRENT_DATE() AND CURRENT_DATE() + 2
        AND fi.user_ID = %s;"""
    mycursor.execute(sql, (user,))
    return mycursor.fetchall()

def calculateNutrients(recipeID):
    sql = ("""SELECT SUM(i.kcal_per_100g / 100 * ri.required_amount),
        SUM(i.protein_per_100g / 100 * ri.required_amount)
    FROM recipe_ingredients ri
        INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    WHERE recipe_ID = %s;""")
    values = (recipeID,)
    mycursor.execute(sql, values)
    return mycursor.fetchall()

def unavailableRecipes(user):
    sql = """SELECT DISTINCT *
FROM recipe_ingredients ri
    LEFT JOIN fridge_inventories fi ON ri.ingredient_ID = fi.ingredient_ID
WHERE fi.ingredient_ID IS NULL
    AND fi.user_ID = %s;"""
    mycursor.execute(sql, (user,))
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
    sql = """SELECT r.title, r.recipe_creator, r.prep_time, r.recipe_ID FROM Recipes r
    WHERE NOT EXISTS(SELECT * FROM recipe_ingredients ri LEFT JOIN fridge_inventories fi
    ON ri.ingredient_ID = fi.ingredient_ID AND fi.user_ID = %s
    WHERE ri.recipe_ID = r.recipe_ID
    AND (fi.amount IS NULL OR fi.amount < ri.required_amount));"""
    mycursor.execute(sql, (user_id))
    return mycursor.fetchall()

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

def getAllRecipes():
    sql = """SELECT title,
    recipe_creator,
    prep_time,
    recipe_ID
    FROM recipes;"""
    mycursor.execute(sql)
    return mycursor.fetchall()

def getRecipeById(recipeID):
    sql = """SELECT r.title,
    r.recipe_creator,
    r.prep_time,
    r.instructions,
    GROUP_CONCAT(ai.ingredient_type) AS ingredients,
    GROUP_CONCAT(ai.standard_unit) AS unit,
    GROUP_CONCAT(ai.required_amount) AS amount
    FROM recipes r
    JOIN (
    SELECT i.ingredient_type,
    ri.recipe_ID,
    ri.required_amount,
    i.standard_unit
    FROM ingredients i
    INNER JOIN recipe_ingredients ri ON ri.ingredient_ID = i.ingredient_ID
    WHERE i.ingredient_ID = ri.ingredient_ID
    ) ai ON ai.recipe_ID = %s
    WHERE r.recipe_ID = %s;"""
    value  =(str(recipeID), str(recipeID))
    mycursor.execute(sql, value)
    return mycursor.fetchall()

# filter vegan recipes
def getVeganRecipes():
    sql = """SELECT r.title, r.recipe_creator, r.prep_time, r.recipe_ID
    FROM recipes r
    WHERE NOT EXISTS(SELECT* FROM recipe_ingredients ri
    INNER JOIN ingredients i ON ri.ingredient_ID = i.ingredient_ID
    WHERE ri.recipe_ID = r.recipe_ID AND i.is_vegan = FALSE);"""
    mycursor.execute(sql)
    return mycursor.fetchall()

# Shows users mealplans
def getAllMealPlans(user_id):
    sql = """SELECT target_calories, target_protein, meal_plan_ID
    FROM meal_plans
    WHERE user_ID = %s;"""
    value = (user_id,)
    mycursor.execute(sql, value)
    return mycursor.fetchall()

# Checks if user has an account
def doesUserExist(email):
    sql = """SELECT EXISTS(
        SELECT 1
        FROM Users
        WHERE Users.email = %s
    )"""
    mycursor.execute(sql, (email,))
    return mycursor.fetchall()[0][0]

# Adds a user
def addUser(email, fname, lname):
    sql = """INSERT INTO Users (email, first_name, last_name)
                        VALUES (%s, %s, %s);"""
    mycursor.execute(sql, (email, fname, lname))
    mydb.commit()

# adds ingredient to user's fridge inventory
def addIngredientToFridge(user_id, ingredient_id, amount, best_before_date):
    sql = """INSERT INTO fridge_inventories (user_ID, ingredient_ID, amount, best_before_date)
        VALUES (%s, %s, %s, %s)"""
    values = (user_id, ingredient_id, amount, best_before_date)
    try:
        mycursor.execute(sql, values)
        mydb.commit()
        return [0, "Completed successfully!"]
    except Exception as e:
        return [1, e]
    
# Gets users fridge inventory
def getFridgeInventoryById(user_id):
    sql = """SELECT i.ingredient_type,
    i.standard_unit,
    fi.amount,
    fi.best_before_date
    FROM fridge_inventories fi
    INNER JOIN ingredients i ON fi.ingredient_ID = i.ingredient_ID
    WHERE fi.user_ID = %s;"""
    value = (user_id,)
    mycursor.execute(sql, value)
    return mycursor.fetchall()

# Shows all ingredients
def getAllIngredients():
    sql = """SELECT ingredient_ID,
    ingredient_type
    FROM ingredients"""
    mycursor.execute(sql)
    return mycursor.fetchall()

# gets the user id by users email address
def getUserIdByEmail(email):
    sql = """SELECT user_ID
    FROM users
    WHERE email = %s;"""
    value = (email,)
    mycursor.execute(sql, value)
    return mycursor.fetchall()

# adds a mealplan with prefered macros
def addMealPlan(user_id, targetCalories, targetProteins):
    sql = """INSERT INTO meal_plans (user_ID, target_calories, target_protein)
VALUES (%s, %s, %s);"""
    values = (user_id, targetCalories, targetProteins)
    try:
        mycursor.execute(sql, values)
        mydb.commit()
        return "Completed successfully!"
    except Exception as e:
        return e

# Calls procedure add recipe to mealplan
def addRecipeToMealPlan(mealPlanId, recipeId, day):
    sql = """CALL add_recipe_to_mealplan(%s, %s, %s);"""
    value = (mealPlanId, recipeId, day)
    try:
        mycursor.execute(sql, value)
        mydb.commit()
    except Exception as e:
        return e

# Gets all recipes in a mealplan
def GetAllRecipesInMealPlan(mealPlanID):
    sql = """SELECT mpr.recipe_ID, mpr.weekDay, r.title, mp.target_calories, mp.target_protein
            FROM meal_plan_recipe mpr
            INNER JOIN recipes r ON mpr.recipe_ID = r.recipe_ID
            INNER JOIN meal_plans mp ON mpr.meal_plan_ID = mp.meal_plan_ID
            WHERE mpr.meal_plan_ID = %s
            ORDER BY FIELD(mpr.weekDay, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');"""
    value = (mealPlanID,)
    try:
        mycursor.execute(sql, value)
        return mycursor.fetchall()
    except Exception as e:
        return e
