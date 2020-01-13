import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:camera_app/components/rounded_button.dart';


class CapturedRecognitionScreen extends StatefulWidget {
  final String imagePath;

  const CapturedRecognitionScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _CapturedRecognitionScreenState createState() =>
      _CapturedRecognitionScreenState();
}

class _CapturedRecognitionScreenState extends State<CapturedRecognitionScreen> {
  String res = "";
  bool isVisible = true;
  String classificationResult = '';
  var recognitions;

  @override
  void initState() {
    super.initState();
    print(widget.imagePath);
    loadModelAndLabels();
  }

  Future loadModelAndLabels() async {
    res = await Tflite.loadModel(
        model: "assets/waste_classifier.tflite",
        labels: "assets/labels.txt",
        numThreads: 1);
    print(res);
  }

  Future getRecognitions() async {


    try {
      recognitions = await Tflite.runModelOnImage(
          path: widget.imagePath,
          imageMean: 60,
          imageStd: 60,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      print(recognitions);
    } catch (e) {
      print(e);
    }
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
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.file(File(widget.imagePath)),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Expanded(
              flex: 1,
              child: RoundedButton(
                buttonText: 'Detect On This',
                onPressed: () async {
                  await getRecognitions();
                  setState(()  {
                    classificationResult =  (recognitions[0])['label'].toString();
                    isVisible = true;
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                classificationResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future dispose() async {
    await Tflite.close();
    super.dispose();
  }
}
