import 'package:flutter/material.dart';
import 'package:newsai/models/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          slideList[index].title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          slideList[index].description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
