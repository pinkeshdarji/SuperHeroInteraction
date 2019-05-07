import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:super_hero_interaction/models/apiresponse.dart';
import 'package:super_hero_interaction/models/character.dart';
import 'package:super_hero_interaction/utilities/settings.dart';

import 'activeCard.dart';
import 'dummyCard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<Apiresponse> apiresponse;

  double initialBottom;
  int dataLength;
  double backCardPosition;
  double backCardWidth = -10.0;
  List<Character> characters;
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  @override
  void initState() {
    super.initState();
    apiresponse = loadCharacters();
    apiresponse.then((Apiresponse apiresponse) {
      setState(() {
        characters = apiresponse.data.characters;
        print(jsonEncode(characters));
      });
    });

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {
          if (rotate.isCompleted) {
            var i = characters.removeLast();
            characters.insert(0, i);
            _buttonController.reset();
          }
        });
      });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  Future<Apiresponse> loadCharacters() async {
    String jsonString;

    if (Settings.isMock) {
      //Load from local
      jsonString = await rootBundle.loadString('assets/json/characters.json');
    } else {
      //Load from api
      var res = await http.get('url');
      jsonString = res.body;
    }

    Map apiresponseMap = jsonDecode(jsonString);
    return Apiresponse.fromJson(apiresponseMap);
  }

  @override
  Widget build(BuildContext context) {
    initialBottom = 15.0;
    dataLength = characters.length;
    backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    backCardWidth = -10.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 30),
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {}),
        ),
        title: Text(
          'movies',
          style: TextStyle(
              color: Colors.black,
              letterSpacing: 1.0,
              fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<Apiresponse>(
        future: apiresponse,
        builder: (context, snapshot) {
          print("snapshot is $snapshot");
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: snapshot.data.data.characters.map((item) {
                    if (snapshot.data.data.characters.indexOf(item) ==
                        dataLength - 1) {
                      return cardDemo(
                          item,
                          bottom.value,
                          right.value,
                          0.0,
                          backCardWidth + 10,
                          rotate.value,
                          rotate.value < -10 ? 0.1 : 0.0,
                          context,
                          dismissImg,
                          flag,
                          addImg,
                          swipeRight,
                          swipeLeft);
                    } else {
                      backCardPosition = backCardPosition - 10;
                      backCardWidth = backCardWidth + 10;

                      return cardDemoDummy(item, backCardPosition, 0.0, 0.0,
                          backCardWidth, 0.0, 0.0, context);
                    }
                  }).toList())
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(DecorationImage img) {
    setState(() {
      characters.remove(img);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      characters.remove(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }
}
