import database
from flask import Flask, render_template, url_for, request, redirect


# print(database.badRecipe())
# print(database.calculateNutrients())
# print(database.unavailableRecipes())


app = Flask(__name__)

#url_for("static", filename = "style.css")

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/test")
def hello_Albin():
    return render_template("home.html", person="Albin")

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return redirect(url_for("test"))

    return render_template("login.html")



