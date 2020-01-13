import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final Function onPressed;
  final String buttonText;

  const RoundedButton({Key key, @required this.onPressed, @required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.grey,
        elevation: 10.0,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
        child: Text(buttonText),
        onPressed: onPressed,
      ),
    );
  }
}