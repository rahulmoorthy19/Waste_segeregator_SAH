import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:newsai/screens/SplashScreen.dart';
import './screens/home_screen.dart';
import './screens/OnBoardingScreen.dart';
import './screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
        title: 'JustBin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
       home: SplashScreen(),
       routes: {
         '/board_screen': (context) => OnBoardingScreen(),
         '/home_screen':(context) => MyHomePage(title: 'JustBin',camera: firstCamera,),
       },
       ),
  );
}
