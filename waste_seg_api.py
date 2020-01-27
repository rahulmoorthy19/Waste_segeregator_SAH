import json
import mysql.connector
from flask import Flask
from flask_cors import CORS, cross_origin
from flask import *
import base64
from model import *

app = Flask(__name__)
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  passwd="root",
  database="waste_seg"
)
@app.route("/credit",methods=['POST'])
def get_credit():
    user_data = request.json
    mycursor =mydb.cursor()
    cred = "SELECT credit FROM user WHERE id ='"+str(user_data["user_id"]+"'")
    mycursor.execute(cred)
    myresult = mycursor.fetchall()
    for x in myresult:
        cred=x[0]
    print("Credit of user is:"+str(cred))
    return jsonify(cred)

@app.route("/predict",methods=['POST'])
def predict_waste():
    image=request.json["file"]
    user_id=request.json["user_id"]
    image_name=request.json["name"]
    imgdata =  base64.b64decode(image)
    file_name=user_id+image_name
    file_name=file_name[0:12]+".jpg"
    with open(file_name, "wb") as fh:
        fh.write(imgdata)
    predictions=use_model("/home/sirzechlucifer/Work/SAH/"+file_name)
    print(predictions)
    if predictions[0]==1:
        print("Recyclable")
        st="recyclable"
        val=incre_cred([st,user_id])
        payload={"cat":"Recyclable",
                 "credit":val}
        return jsonify(payload)
    if predictions[0]==0:
        print("Organic")
        st="organic"
        val=incre_cred([st,user_id])
        payload={"cat":"Organic",
                 "credit":val}
        return jsonify(payload)


def incre_cred(type):
    mycursor=mydb.cursor()
    curr_cnt="SELECT "+ type[0]+" FROM credit"
    mycursor.execute(curr_cnt)
    value = mycursor.fetchall()
    for x in value:
        curr_cnt=x[0]
    val=int(curr_cnt) + 1
        #print(val)
        #mycursor.execute ()
    cred_add="UPDATE  credit SET "+ type[0] +"="+str(val)
    mycursor.execute(cred_add)
    mydb.commit()
    cred_curr="SELECT credit FROM user WHERE id='"+str(type[1])+"'"
    mycursor.execute(cred_curr)
    val2 = mycursor.fetchall()
    for x in val2:
        cred_curr=x[0]
    val3=int(cred_curr)+1
    user_cred="UPDATE user SET credit ="+str(val3)+" WHERE id='"+str(type[1])+"'"
    mycursor.execute(user_cred)
    mydb.commit()

    user_get="SELECT * from waste"
    mycursor.execute(user_get)
    values=mycursor.fetchall()
    prev_values={"organic":0,"recyclable":0,"hazardous":0,"solid":0}
    for x in values:
        prev_values["organic"]=prev_values["organic"]+int(x[0])
        prev_values["recyclable"]=prev_values["recyclable"]+int(x[1])
        prev_values["hazardous"]=prev_values["hazardous"]+int(x[2])
        prev_values["solid"]=prev_values["solid"]+int(x[3])
    new_val=prev_values[type[0]]+1
    user_waste="UPDATE waste SET "+type[0]+"="+str(new_val)+" WHERE id ='"+str(type[1]+"'")
    mycursor.execute(user_waste)
    mydb.commit()
    return 1


@app.route("/insert",methods=['POST'])
def insert_user():
    user_data=request.json
    mycursor = mydb.cursor()
    check_user = "SELECT * FROM user WHERE id ='"+user_data["uid"]+"'"
    mycursor.execute(check_user)
    myresult=mycursor.fetchall()
    for x in myresult:
        temp=x[0]

    if not myresult:
        user_add = "INSERT INTO user (id,name,credit) VALUES (%s,%s,%s)"
        waste_add = "INSERT INTO waste (organic,solid,recyclable,hazardous) VALUES (0,0,0,0)"
        val = (user_data["uid"],user_data["name"],user_data["credit"])
    #val_1 = (user_data["uid"])
        mycursor.execute(user_add, val)
        mycursor.execute(waste_add)
        mydb.commit()
        print(mycursor.rowcount, "record inserted.")
        return jsonify("true")
    elif myresult:
        return jsonify("true")

@app.route('/get_user',methods=['POST'])
def get_waste_data_of_user():
    user=dict()
    user_data=request.json
    mycursor = mydb.cursor()
    waste_get="SELECT * FROM waste WHERE id ="+str(user_data["uid"])
    val_1 = (int(user_data["uid"]))
    mycursor.execute(waste_get,val_1)
    myresult = mycursor.fetchall()
    print(myresult)
    for x in myresult:
        user["organic"]=int(x[1])
        user["recyclable"]=int(x[2])
        user["hazardous"]=int(x[3])
        user["solid"]=int(x[4])
    return jsonify(user)

@app.route('/get_all',methods=['GET'])
def get_waste_data_of_all():
    user=dict()
    user["count"]=0
    user["organic"]=0
    user["recyclable"]=0
    user["hazardous"]=0
    user["solid"]=0
    user_data=request.json
    mycursor = mydb.cursor()
    get_all="SELECT * FROM waste"
    mycursor.execute(get_all)
    myresult = mycursor.fetchall()
    for x in myresult:
        user["count"]=user["count"]+1
        user["organic"]=user["organic"]+int(x[0])
        user["recyclable"]=user["recyclable"]+int(x[2])
        user["hazardous"]=user["hazardous"]+int(x[3])
        user["solid"]=user["solid"]+int(x[1])
    return jsonify(user)

if __name__== '__main__':
    app.run(host='0.0.0.0', port=8658, debug=True)
