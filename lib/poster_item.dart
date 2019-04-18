import 'package:flutter/material.dart';

class Poster {
  const Poster({
    this.id,
    this.name,
    this.imagePath,
  });

  final int id;
  final String name;
  final String imagePath;
}

Container buildPost(Poster poster, Size size) {
  return new Container(
      child: new Stack(children: <Widget>[
        new Container(
            width: size.width,
            height: size.height,
            child: new Image.asset(poster.imagePath, fit: BoxFit.fill)),
      ]));
}


