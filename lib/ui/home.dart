import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:super_hero_interaction/models/apiresponse.dart';
import 'package:super_hero_interaction/models/character.dart';
import 'package:super_hero_interaction/utilities/hex_color.dart';
import 'package:super_hero_interaction/utilities/settings.dart';

import 'hero_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<Apiresponse> apiresponse;
  List<Character> characters;

  int currentIndex;
  AnimationController controller;
  AnimationController scaleController;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<Offset> _moveAnim;
  Animation<double> _scaleAnim;
  Animation<double> _scaleCharacterAnim;
  Animation<double> _borderCharacterAnim;
  Animation<double> _rotationAnim;
  Animation<Color> _characterColorTween;

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

    currentIndex = 0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);

    _translationAnim = Tween(begin: Offset(0.0, 0.0), end: Offset(-100.0, 0.0))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });
    _rotationAnim = Tween(begin: 0.0, end: 2.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _scaleAnim = Tween(begin: 0.9, end: 1.0).animate(curvedAnimation);
    _scaleCharacterAnim = Tween(begin: 0.2, end: 1.0).animate(curvedAnimation);
    _borderCharacterAnim = Tween(begin: 1.0, end: 0.0).animate(curvedAnimation);
    _moveAnim = Tween(begin: Offset(0.0, -0.06), end: Offset(0.0, 0.0))
        .animate(curvedAnimation);
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
              ? Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: snapshot.data.data.characters.reversed
                      .map((Character character) {
                    if (characters.indexOf(character) <= 2) {
                      return GestureDetector(
                        onHorizontalDragEnd: _horizontalDragEnd,
                        child: Transform.translate(
                          offset: _getFlickTransformOffset(
                              characters.indexOf(character)),
                          child: Transform.rotate(
                            angle: _getFlickRotateOffset(
                                characters.indexOf(character)),
                            origin:
                                Offset(0, MediaQuery.of(context).size.height),
                            child: FractionalTranslation(
                              translation: _getStackedCardOffset(
                                  characters.indexOf(character)),
                              child: Transform.scale(
                                scale: _getStackedCardScale(
                                    characters.indexOf(character)),
                                child: Align(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  child: HeroCard(
                                    border: _getCharacterBorder(
                                        characters.indexOf(character)),
                                    ccColor: _getCharacterColor(
                                        characters.indexOf(character)),
                                    characterScaleFactor: _getCharacterScale(
                                        characters.indexOf(character)),
                                    character: character,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList())
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Offset _getStackedCardOffset(int cardIndex) {
    int diff = cardIndex - currentIndex;
    if (cardIndex == currentIndex + 1) {
      print('animation');
      return _moveAnim.value;
    } else if (diff > 0 && diff <= 2) {
      print('move 0.5');
      return Offset(0.0, -0.06 * diff);
    } else {
      print('move 0');
      return Offset(0.0, 0.0);
    }
  }

  double _getStackedCardScale(int cardIndex) {
    int diff = cardIndex - currentIndex;
    if (cardIndex == currentIndex) {
      return 1.0;
    } else if (cardIndex == currentIndex + 1) {
      return _scaleAnim.value;
    } else {
      return (1 - (0.123 * diff.abs()));
    }
  }

  double _getCharacterScale(int cardIndex) {
    if (cardIndex == currentIndex) {
      return 1.0;
    } else if (cardIndex == currentIndex + 1) {
      return _scaleCharacterAnim.value;
    } else {
      return 0.2;
    }
  }

  Color _getCharacterColor(int cardIndex) {
    String colorString =
        "0xff${characters.elementAt(cardIndex).background}".replaceAll("#", "");
    int colorInt = int.parse(colorString);
    _characterColorTween =
        ColorTween(begin: Colors.grey[200], end: Color(colorInt))
            .animate(curvedAnimation);
    if (cardIndex == currentIndex) {
      return HexColor(characters.elementAt(cardIndex).background);
    } else if (cardIndex == currentIndex + 1) {
      return _characterColorTween.value;
    } else {
      return Colors.grey[200];
    }
  }

  double _getCharacterBorder(int cardIndex) {
    if (cardIndex == currentIndex) {
      return 0.0;
    } else if (cardIndex == currentIndex + 1) {
      return _borderCharacterAnim.value;
    } else {
      return 35.0;
    }
  }

  Offset _getFlickTransformOffset(int cardIndex) {
    if (cardIndex == currentIndex) {
      return _translationAnim.value;
    }
    return Offset(0.0, 0.0);
  }

  double _getFlickRotateOffset(int cardIndex) {
    if (cardIndex == currentIndex) {
      return -math.pi / 2 * _rotationAnim.value;
    }
    return 0.0;
  }

  void _horizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      // Swiped Right to Left
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          Character character = characters.removeAt(0);
          characters.add(character);
        });
      });
    }
  }
}
