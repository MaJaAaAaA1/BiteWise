import database
from flask import Flask, render_template, url_for, request, redirect, session

app = Flask(__name__)

# Login route
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if database.doesUserExist(request.form['email']):
            # Check password
            session['email'] = request.form['email'] # Add user to session
            return redirect(url_for("test")) # Send to defualt page for login
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
                return redirect(url_for("test")) # Send to defualt page for login
        
    return render_template("register.html")

@app.route("/logout")
def logout():
    session.pop('email', None)
    return redirect(url_for('home_page')) # Send back to home page