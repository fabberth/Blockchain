from flask import Flask, app, render_template, jsonify, request, session
from flask_session import Session
import json
import callContract
import funciones

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                             PAGINAS HTML

#--------------------------------------------------------------------------------------------------------------------------------------------------

@app.route('/')
def event():
    
    #request.values['correo']
    #session["name"] = request.values['userName']
    userName = request.values['userName']
    
    html = render_template('event.html')
    html = html.replace('%%USER%%', userName)
    return html

@app.route('/record')
def record():
    
    try:

        if session['name'] != request.values['userName']:
            return render_template('autenticacion.html')

    except Exception as err:

        return render_template('autenticacion.html')

    return render_template('record.html')

@app.route('/stateAccount')
def stateAccount():
    return render_template('stateAccount.html')


#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                             account

#--------------------------------------------------------------------------------------------------------------------------------------------------

@app.route('/getAccount',methods=['POST','GET'])
def account():
    
    userName = funciones.getAccount(request.json['userName'])
    
    if(userName != ""):
        json = jsonify({"error":"","accounts":userName['accounts']})
    else:
        json = jsonify({"error":"Usuario no registrado","accounts":['xxxxxxxxx']})
    return json


#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                          searchEventByName

#--------------------------------------------------------------------------------------------------------------------------------------------------

@app.route('/searchName',methods=['POST','GET'])
def searchEventByName():

    cuenta = request.json['account']
    userName = request.json['userName']
    searchUserName = request.json['searchUserName']
    key = funciones.getKey(userName,cuenta)

    result = callContract.busquedaUserName(cuenta,key,searchUserName)
    
    return jsonify({"result":result})



#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                          searchEventByID

#--------------------------------------------------------------------------------------------------------------------------------------------------

@app.route('/searchId',methods=['POST','GET'])
def searchEventById():

    cuenta = request.json['account']
    userName = request.json['userName']
    iD = request.json['id']

    key = funciones.getKey(userName,cuenta)

    result = callContract.busquedaId(cuenta,key,iD)
    
    return jsonify({"result":result})

#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                          stateAccount

#--------------------------------------------------------------------------------------------------------------------------------------------------


@app.route('/activeAccount')
def activeAccount():

    cuenta = request.json['account']
    key = "91a8809e332537cfaa435c093c972f9aea185181e3442d369b502239ecb884e9"

    if cuenta == "0x7e2a7b5630f28c0c2A79732881Fe5ae0b1191498":
        key = "2a8e48d0a7b9620d9ea08ee1d1a52ad0cd6f63a470b711c5cbbeddd1d98e4821"

    user = request.json['user']
    read = request.json['read']

    return jsonify({"result":"Bien"})




#--------------------------------------------------------------------------------------------------------------------------------------------------

#                                          SERVIDOR

#--------------------------------------------------------------------------------------------------------------------------------------------------

if __name__ == '__main__':
    app.run(debug=True)