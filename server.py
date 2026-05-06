import database
import os
from dotenv import load_dotenv
from flask import Flask, render_template, url_for, request, redirect, session

load_dotenv()
app = Flask(__name__)

app.secret_key = f'{os.getenv("SESSION_SECRET_KEY")}'.encode()

### Middlewares ###

# Log 
@app.before_request
def log_request():
    print("\033[34m", f"Method: {request.method}\nURL: {request.url}", "\033[0m")
    print(request.endpoint)

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
@app.route("/test")
def test():
    return render_template("home.html", person="Albin")

# Login route
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # TO DO: Check if they exist in database
        session['email'] = request.form['email'] # Add user to session
        return redirect(url_for("test")) # Send to defualt page for login

    return render_template("login.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # TO DO: Check if they exist in database
        session['email'] = request.form['email'] # Add user to session
        return redirect(url_for("test")) # Send to defualt page for login
    return render_template("register.html")

@app.route("/logout")
def logout():
    session.pop('email', None)
    return redirect(url_for('home_page')) # Send back to home page