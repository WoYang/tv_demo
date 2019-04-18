import 'package:flutter/material.dart';
import 'dart:ui' show window;
import 'focus_cell.dart';
import 'poster_item.dart';

import 'mock_data.dart';

class TVPage extends StatefulWidget {
  const TVPage({
    Key key,
    this.screenSize,
  }) : super(key: key);

  final Size screenSize;
  @override
  State<StatefulWidget> createState() => new PageWidgetState();
}

class PageWidgetState extends State<TVPage> {
  FocusNode focusNode0;
  GlobalKey globalKey0 = new GlobalKey();

  FocusNode focusNode1;
  GlobalKey globalKey1 = new GlobalKey();

  FocusNode focusNode2;
  GlobalKey globalKey2 = new GlobalKey();

  FocusNode focusNode3;
  GlobalKey globalKey3 = new GlobalKey();

  FocusNode focusNode4;
  GlobalKey globalKey4 = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode0 = new FocusNode();
    focusNode1 = new FocusNode();
    focusNode2 = new FocusNode();
    focusNode3 = new FocusNode();
    focusNode4 = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FocusScope.of(context).requestFocus(focusNode0);
    double size_width = widget.screenSize.width;
    double size_height = widget.screenSize.height;
    return new Container(
        padding: EdgeInsets.only(top: 20),
        decoration: new BoxDecoration(
            image: const DecorationImage(
                fit: BoxFit.fill,
                image: const AssetImage('poster/bg.jpg'))),
        child: new Column(
          children: <Widget>[
            new Expanded(
                child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FocusCell(
                      key: globalKey0,
                      focusNode: focusNode0,
                      nextFocusNodeDown: focusNode2,
                      nextFocusNodeRight: focusNode1,
                      child: buildPost(
                          kPosters[0],
                          new Size(size_width / 2 - 20.0,
                              size_height * 3 / 5 - 15.0))),
                ),
                new Expanded(
                  child: new FocusCell(
                      key: globalKey1,
                      focusNode: focusNode1,
                      nextFocusNodeDown: focusNode4,
                      nextFocusNodeLeft: focusNode0,
                      child: buildPost(
                          kPosters[1],
                          new Size(size_width / 2 - 20.0,
                              size_height * 3 / 5 - 15.0))),
                )
              ],
            )),
            new Expanded(
                child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FocusCell(
                      key: globalKey2,
                      focusNode: focusNode2,
                      nextFocusNodeUp: focusNode0,
                      nextFocusNodeRight: focusNode3,
                      child: buildPost(
                          kPosters[2],
                          new Size(size_width / 3 - 15.0,
                              size_height * 2 / 5 - 15.0))),
                ),
                new Expanded(
                  child: new FocusCell(
                      key: globalKey3,
                      focusNode: focusNode3,
                      nextFocusNodeUp: focusNode1,
                      nextFocusNodeLeft: focusNode2,
                      nextFocusNodeRight: focusNode4,
                      child: buildPost(
                          kPosters[3],
                          new Size(size_width / 3 - 15.0,
                              size_height * 2 / 5 - 15.0))),
                ),
                new Expanded(
                  child: new FocusCell(
                      key: globalKey4,
                      focusNode: focusNode4,
                      nextFocusNodeUp: focusNode1,
                      nextFocusNodeLeft: focusNode3,
                      child: buildPost(
                          kPosters[4],
                          new Size(size_width / 3 - 15.0,
                              size_height * 2 / 5 - 15.0))),
                )
              ],
            ))
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode0.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }
}
