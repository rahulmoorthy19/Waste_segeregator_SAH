import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scratcher/scratcher.dart';
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  final storage = new FlutterSecureStorage();
  String _providerId;
  static final Random _random = Random.secure();
    static String CreateCryptoRandomString([int length = 16]) {
        var values = List<int>.generate(length, (i) => _random.nextInt(256));

        return base64Url.encode(values);
    }
  String code;
  int credit;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  
  @override
  void initState() {
    super.initState();
     
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _loadUserData();
    
  }
  _loadUserData() async{
   
    String tempProviderId = await storage.read(key:"providerId");
   

    setState(() {
      _providerId=tempProviderId;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Container(
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
                padding: const EdgeInsets.all(8.0),
                
                child: ClipRRect( borderRadius: BorderRadius.circular(16.0), child: CameraPreview(_controller)),
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${CreateCryptoRandomString()}.jpg',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            const url="http://192.168.43.111:8658/predict";
    String base64Image = base64Encode(File(path).readAsBytesSync());
    String file = File(path).path.split("/").last;
    Map<String,String> headers= {"Content-type":"application/json"};
    String json = '{"file":"'+base64Image+'",'+'"name":"'+file+'",'+'"user_id":"'+_providerId.substring(0,8)+'"}';
     print(file);
    await http.post(url,headers:headers,body:json).then((response){
      var output = jsonDecode(response.body);
      code = output["cat"] as String;
      credit = output["credit"] as int;


    });
            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path,code:code,credit:credit),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String code;
  final int credit;

  const DisplayPictureScreen({Key key, this.imagePath, this.code,this.credit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: Column(

          children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                          child: Scratcher(
                    accuracy: ScratchAccuracy.low,
                    threshold: 25,
                    brushSize: 50,
                   image: Image.file(File(imagePath)),

                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 250),
                      opacity: 1,
                      child: Container(
                        height:500.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          "You won\n "+credit.toString()+"\n credits",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.green),
                              textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
             ),
           ),
           Card(
             elevation: 2.0,
             child: Container(
               padding: EdgeInsets.all(20.0),
               child: Text(
                          code,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 50,
                             ),
                              textAlign: TextAlign.center,
                        ),
             ),
           )
          ],
        ),
      ),
    );
  }
}

/*
Image.file(File(imagePath))

 */