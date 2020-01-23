import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newsai/models/slide.dart';
import 'package:newsai/widgets/Slide_dots.dart';
import 'package:newsai/widgets/slide_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _currentPage = (_currentPage + 1) % 3;
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOutSine);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  final storage = new FlutterSecureStorage();

  Future<FirebaseUser> _signIn(BuildContext context) async {
     

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;
  
    await storage.write(key: "providerId", value: userDetails.uid);
    await storage.write(key:"displayName",value:userDetails.displayName);
    await storage.write(key:"email",value:userDetails.email);
    await storage.write(key:"photoUrl",value: userDetails.photoUrl);

       const url="http://192.168.43.111:8658/insert";
    Map<String,String> headers= {"Content-type":"application/json"};
    String json = '{"uid":"'+userDetails.uid.substring(0,8)+'",'+'"name":"'+userDetails.displayName+'",'+'"credit":0}';
    
    await http.post(url,headers:headers,body:json).then((response){
     print(response.body);
    });
     
    Navigator.pushReplacementNamed(context,'/home_screen');

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
           fit: StackFit.expand,
          children: <Widget>[
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              scrollDirection: Axis.horizontal,
                              itemCount: slideList.length,
                              itemBuilder: (ctx, i) => SlideItem(i),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 35),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (int i = 0; i < slideList.length; i++)
                                        if (i == _currentPage)
                                          SlideDots(true)
                                        else
                                          SlideDots(false)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              _signIn(context)
                                  .then((FirebaseUser user) => {print(user)})
                                  .catchError((e) => print(e));
                            },
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF0BA360),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(15),
                            textColor: Theme.of(context).primaryColor,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
