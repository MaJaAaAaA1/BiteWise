import database
import os
from dotenv import load_dotenv
from flask import Flask, render_template, url_for, request, redirect, session, jsonify

load_dotenv()
app = Flask(__name__)

app.secret_key = f'{os.getenv("SESSION_SECRET_KEY")}'.encode()

### Middlewares ###

# Log 
@app.before_request
def log_request():
    print("\033[34m", f"Method: {request.method}\nURL: {request.url}", "\033[0m")

# Session
@app.before_request
def check_session():
    if request.endpoint not in ["static", "login", "register", "home_page"]: # List of places where you don't need to be logged in
        if 'email' not in session:
            return redirect(url_for("login")) # Send to login

### Routes ###

# Base route
@app.route("/")
def home_page():
    return "<p>Hello, World!</p>"

# Test route
@app.route("/home")
def home():

    return render_template("home.html")

# Recipes route
@app.route("/recipes")
def recipes():
    return render_template("recipes.html")

# Recipe route
@app.route("/recipes/recipe")
def recipe():
    if int(request.args.get("recipeid")):
        data = database.getRecipeById(int(request.args.get("recipeid")))
        return render_template("recipe.html", title=data[0][0], creator=data[0][1], time=data[0][2], instructions=data[0][3], ingredients=data[0][4], units=data[0][5], amounts=data[0][6])
    return redirect(url_for("recipes"))

# MyPage route
@app.route("/mypage")
def mypage():
    if not request.args.get('userid'):
        return redirect(f"/mypage?userid={session['userid'][0][0]}")
    return render_template("mypage.html")

# Login route
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if database.doesUserExist(request.form['email']):
            # Check password
            session['email'] = request.form['email'] # Add user to session
            session['userid'] = database.getUserIdByEmail(request.form['email'])
            return redirect(url_for("home", userid=session['userid'][0])) # Send to defualt page for login
        else:
            return render_template("login.html", error="User does not exist!")
    
    return render_template("login.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':

        if database.doesUserExist(request.form['email']):
            # Could also tell them it already exists
            return render_template("register.html", error="User already exist with that email!")
        else:
            if request.form['email'] and request.form['fname'] and request.form['lname']:
                database.addUser(request.form['email'], request.form['fname'], request.form['lname'])
                session['email'] = request.form['email'] # Add user to session
                return redirect(url_for("home")) # Send to defualt page for login
        
    return render_template("register.html")

@app.route("/logout")
def logout():
    session.pop('email', None)
    return redirect(url_for('home_page')) # Send back to home page

@app.route("/clear")
def clear():
    [session.pop(key) for key in list(session.keys())]
    return redirect(url_for("home_page")) # Send to defualt page for login

### Data Routes ###

@app.route("/getRecipes")
def getRecipes():
    data = database.getAllRecipes()
    for i in range(0, len(data)):
        data[i] = list(data[i])
        data[i][2] = str(data[i][2])
    print(data[0][2])
    return jsonify(data)

@app.route("/getRecipesDoable")
def getRecipesDoable():
    data = database.getCookableRecipes(session['userid'][0])
    for i in range(0, len(data)):
        data[i] = list(data[i])
        data[i][2] = str(data[i][2])
    print(data[0][2])
    return jsonify(data)

@app.route("/getRecipesVegan")
def getRecipesVegan():
    data = database.getVeganRecipes()
    for i in range(0, len(data)):
        data[i] = list(data[i])
        data[i][2] = str(data[i][2])
    print(data[0][2])
    return jsonify(data)

@app.route("/getFrigdeInventory")
def getFrigdeInventory():
    data = database.getFridgeInventoryById(int(request.args.get("userid")))
    return jsonify(data)

@app.route("/getAllIngredients")
def getAllIngredients():
    data = database.getAllIngredients()
    return jsonify(data)

@app.route("/addIngredient", methods=["POST"])
def addIngredient():
    try:
        userId = request.form["userid"]
        ingredientId = request.form["ingredientId"]
        amount = request.form["amount"]
        bestBeforeDate = request.form["bestBeforeDate"]
    except:
        return jsonify("Not enough data!")
    message = database.addIngredientToFridge(userId, ingredientId, amount, bestBeforeDate)
    return redirect(url_for("mypage", userid=session['userid'][0]))

@app.route("/getMealPlans")
def getMealPlans():
    data = database.getAllMealPlans(session['userid'][0][0])
    return jsonify(data)

@app.route("/addMealPlan", methods=["POST"])
def addMealPlan():
    try:
        userId = session['userid'][0][0]
        targetCalories = request.form["targetCalories"]
        targetProteins = request.form["targetProtein"]
    except:
        return jsonify("Not enough data!")
    message = database.addMealPlan(userId, targetCalories, targetProteins)
    return redirect(url_for("mypage", userid=session['userid'][0]))