import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './sample_camera.dart';
import './Profile.dart';
import './analytics_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.camera}) : super(key: key);

  final String title;
  final CameraDescription camera;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomSelectedIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  String _title = "JustBin->Camera";

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        TakePictureScreen(
          camera: widget.camera,
        ),
        AnimatedChart(),
        ProfileScreen()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    String _temptitle = "";
    switch (index) {
      case 0:
        _temptitle = "JustBin->Camera";
        break;
      case 1:
        _temptitle = "JustBin->Analytics";
        break;
      case 2:
        _temptitle = "JustBin->Profile";
        break;
    }
    setState(() {
      bottomSelectedIndex = index;
      _title = _temptitle;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease); 
    });
  }

  void bottomTapped(int index) {
    String _temptitle = "";
    switch (index) {
      case 0:
        _temptitle = "JustBin->Camera";
        break;
      case 1:
        _temptitle = "JustBin->Analytics";
        break;
      case 2:
        _temptitle = "JustBin->Profile";
        break;
    }
    setState(() {
      bottomSelectedIndex = index;
      _title = _temptitle;
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: buildPageView(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: bottomSelectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.camera, size: 30),
          Icon(Icons.timeline, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.green,
        
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        
      ),
    );
  }
}


