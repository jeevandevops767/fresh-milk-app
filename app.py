from flask import Flask, render_template, request, redirect

app = Flask(__name__)

# Temporary storage
orders = []

@app.route('/')
def login():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def handle_login():
    role = request.form['role']
    if role == 'user':
        return redirect('/user')
    else:
        return redirect('/admin')

@app.route('/user', methods=['GET', 'POST'])
def user():
    if request.method == 'POST':
        quantity = request.form['quantity']
        orders.append({"quantity": quantity, "status": "Pending"})
    return render_template('user.html', orders=orders)

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        index = int(request.form['index'])
        orders[index]['status'] = 'Delivered'
    return render_template('admin.html', orders=orders)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)