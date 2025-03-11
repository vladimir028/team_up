import 'package:flutter/cupertino.dart';

class Sport {
  final String name;
  final IconData iconData;
  final Color iconColor;
  final String imgUrl;
  int rating;

  Sport(this.name, this.iconData, this.iconColor, this.imgUrl, this.rating);
}