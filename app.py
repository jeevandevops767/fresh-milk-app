from flask import Flask, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)



import os
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'default-secret')
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DB_URL', 'sqlite:///milk.db')

db = SQLAlchemy(app)

# ------------------ MODELS ------------------

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(100))

class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    quantity = db.Column(db.Integer)
    status = db.Column(db.String(50), default="Pending")

# ------------------ ROUTES ------------------

@app.route('/')
def home():
    return "Fresh Milk App Running"

# Signup
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    user = User(email=data['email'], password=data['password'])
    db.session.add(user)
    db.session.commit()
    return {"message": "User created"}

# Login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email'], password=data['password']).first()

    if user:
        session['user_id'] = user.id
        return {"message": "Login success"}
    return {"message": "Invalid credentials"}

# Place Order
@app.route('/order', methods=['POST'])
def order():
    if 'user_id' not in session:
        return {"message": "Login required"}

    data = request.json
    new_order = Order(user_id=session['user_id'], quantity=data['quantity'])
    db.session.add(new_order)
    db.session.commit()

    return {"message": "Order placed"}

# View Orders (User)
@app.route('/my-orders')
def my_orders():
    if 'user_id' not in session:
        return {"message": "Login required"}

    orders = Order.query.filter_by(user_id=session['user_id']).all()
    return jsonify([{"id": o.id, "qty": o.quantity, "status": o.status} for o in orders])

# Admin: View All Orders
@app.route('/admin/orders')
def admin_orders():
    orders = Order.query.all()
    return jsonify([{"id": o.id, "qty": o.quantity, "status": o.status} for o in orders])

# Admin: Accept Order
@app.route('/admin/accept/<int:id>', methods=['POST'])
def accept_order(id):
    order = Order.query.get(id)
    order.status = "Accepted"
    db.session.commit()
    return {"message": "Order accepted"}

# ------------------

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000)