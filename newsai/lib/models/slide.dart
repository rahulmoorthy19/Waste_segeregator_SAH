
import 'package:flutter/foundation.dart';

class Slide{
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });

}

final slideList = [
  Slide(
    imageUrl: 'assets/images/image1.jpg',
    title: 'Overview',
    description: "Segregation is key for effective waste disposal. The use of any proper treatment requires seperated waste. Our App bring awareness to people and workers to handle waste properly.",
  ),
  Slide(
    imageUrl: 'assets/images/image2.jpg',
    title: 'Reward System',
    description: "People who doesn't care about waste can be engagged with app as there are rewards for using the app. Wallet given to every user. ",
  ),
  Slide(
    imageUrl: 'assets/images/image1.jpg',
    title: 'Classification',
    description: "User can easily find the ways to segregate the data through our application. It can be categorized into various types like organic, recyclable waste ,e-waste.",
  ),
  Slide(
    imageUrl: 'assets/images/image2.jpg',
    title: 'Analytics',
    description: "Analytics of number of users and waste generated is given to admin. Analytics shown in the form of graphs. Admin can use this analytics for better waste management.",
  )
];