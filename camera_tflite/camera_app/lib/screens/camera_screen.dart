import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:camera_app/components/rounded_button.dart';
import 'package:camera_app/screens/captured_recognition_screen.dart';

class CameraScreen extends StatefulWidget {

  final CameraDescription camera;

  const CameraScreen({Key key, @required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Classifier'),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CameraPreview(_controller),
                  );
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: RoundedButton(
              buttonText: 'Identify this Garbage',
              onPressed: () async {
                try{
                  await _initializeControllerFuture;

                  final path = p.join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png'
                  );

                  await _controller.takePicture(path);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CapturedRecognitionScreen(imagePath: path,)
                      ));

                }catch(e){
                  print(e);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



