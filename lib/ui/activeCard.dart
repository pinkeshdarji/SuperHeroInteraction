import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_hero_interaction/models/character.dart';

Positioned cardDemo(
    Character charcter,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  // print("Card");
  return new Positioned(
    bottom: bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.3,
      onResize: () {
        //print("here");
        // setState(() {
        //   var i = data.removeLast();

        //   data.insert(0, i);
        // });
      },
      onDismissed: (DismissDirection direction) {
//          _swipeAnimation();
        if (direction == DismissDirection.endToStart)
          dismissImg(charcter);
        else
          addImg(charcter);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        //transform: null,
        transform: new Matrix4.skewX(skew),
        //..rotateX(-math.pi / rotation),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Hero(
            tag: "img",
            child: new GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => new DetailPage(type: img)));
//                Navigator.of(context).push(new PageRouteBuilder(
//                      pageBuilder: (_, __, ___) => new DetailPage(type: img),
//                    ));
              },
              child: new Card(
                color: Colors.transparent,
                elevation: 1.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.05 + cardWidth,
                  height: screenSize.height / 1.7,
                  decoration: new BoxDecoration(
                    color: new Color.fromRGBO(121, 114, 173, 1.0),
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(35.0),
                        topRight: new Radius.circular(35.0)),
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        width: screenSize.width / 1.05 + cardWidth,
                        height: screenSize.height / 2.2,
                        margin: EdgeInsets.only(top: 20),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topLeft: new Radius.circular(35.0),
                              topRight: new Radius.circular(35.0)),
                          image:
                              DecorationImage(image: AssetImage(charcter.url)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
