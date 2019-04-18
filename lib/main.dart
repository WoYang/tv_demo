import 'package:flutter/material.dart';
import 'page.dart';

void main() => runApp(new MaterialApp(
      home: new TvAppWidget(),
    ));

class TvAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new TVPage(screenSize: screenSize);
  }
}
