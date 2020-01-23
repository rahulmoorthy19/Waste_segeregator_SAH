import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/CustomShapeClipper.dart';
import 'package:http/http.dart' as http;



class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key key}) : super(key: key);  

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = new FlutterSecureStorage();
  String _displayName;
  String _email;
  String _photoUrl;
  bool _isloading=true;
  String _credit;
  
  @override
  void initState() {
    super.initState();
    _isloading = true;
    _loadUserData();
  }

  _loadUserData() async{
    String tempDisplayName = await storage.read(key:"displayName");
    String tempEmail = await storage.read(key:"email");
    String tempPhotoUrl = await storage.read(key:"photoUrl");
    String uid = await storage.read(key:"providerId");

    const url="http://192.168.43.111:8658/credit";
    Map<String,String> headers= {"Content-type":"application/json"};
    String json = '{"user_id":"'+uid.substring(0,8)+'"}';
    
    String tempCredit;
    await http.post(url,headers:headers,body:json).then((response){
     tempCredit=response.body;
    });
   

    setState(() {
      _displayName=tempDisplayName;
      _email = tempEmail;
      _photoUrl = tempPhotoUrl;
      _isloading = false;
      _credit = tempCredit;
    });
  }

  final GoogleSignIn _gSignIn =  GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    
    if(_isloading) return  Scaffold(body:Center(child: CircularProgressIndicator()));
    
    return  Scaffold(
        body:Column(
          children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
            ClipPath(
              clipper: CustomShapeClipper() ,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.7,
                    ],
                    colors: [
                      Color(0xFF0BA360),
                      Color(0xFF3CBA92),
                    ],
                  ),
                ),
                height: 300.0,

              ),
            ),
            Card(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                backgroundImage:NetworkImage(_photoUrl),
                radius: 50.0,
              ),
               SizedBox(height:20.0),
               Text(
                _displayName,
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),
              SizedBox(height:20.0),
               Text(
                _email,
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),
              
                  ],
                ),
              ),
            ),
            

          ],),
          SizedBox(height:60.0),
            Card(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                child: Icon(Icons.account_balance_wallet,size: 50.0,),
                radius: 50.0,
              ),
               SizedBox(height:20.0),
               Text(
                "Credits",
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),  
              SizedBox(height:20.0),
               Text(
                _credit,
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),        
                  ],
                ),
              ),
            )
        ],),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.exit_to_app),
            onPressed: (){
               _gSignIn.signOut();
              print('Signed out');
               Navigator.pushReplacementNamed(context,'/board_screen');
             
            },
            
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
  }
}

/*
Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage:NetworkImage(_photoUrl),
                radius: 50.0,
              ),
              SizedBox(height:10.0),
               Text(
                "Name : " + _displayName,
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),
              SizedBox(height:10.0),
               Text(
                "Email : " + _email,
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
              ),
              SizedBox(height:10.0),
            ],
          ),)

*/