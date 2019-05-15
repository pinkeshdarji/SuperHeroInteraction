import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:super_hero_interaction/models/apiresponse.dart';
import 'package:super_hero_interaction/models/character.dart';
import 'package:super_hero_interaction/utilities/settings.dart';

import 'tourist_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<Apiresponse> apiresponse;
  List<Character> characters;

  var cards = [
    TouristCard(index: 0, imageUrl: "image1.jpeg"),
    TouristCard(index: 1, imageUrl: "image2.jpeg"),
    TouristCard(index: 2, imageUrl: "image3.jpeg"),
    TouristCard(index: 3, imageUrl: "image4.jpeg"),
    TouristCard(index: 4, imageUrl: "image1.jpeg"),
    TouristCard(index: 5, imageUrl: "image2.jpeg")
  ];
  int currentIndex;
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<Offset> _moveAnim;
  Animation<double> _scaleAnim;

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
      duration: Duration(milliseconds: 3000),
    );
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);

    _translationAnim = Tween(begin: Offset(0.0, 0.0), end: Offset(-1000.0, 0.0))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    _scaleAnim = Tween(begin: 0.965, end: 1.0).animate(curvedAnimation);
    _moveAnim = Tween(begin: Offset(0.0, -0.05), end: Offset(0.0, 0.0))
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
                  children: cards.reversed.map((card) {
                    if (cards.indexOf(card) <= 2) {
                      return GestureDetector(
                        onHorizontalDragEnd: _horizontalDragEnd,
                        child: Transform.translate(
                          offset: _getFlickTransformOffset(card),
                          child: FractionalTranslation(
                            translation: _getStackedCardOffset(card),
                            child: Transform.scale(
                              scale: _getStackedCardScale(card),
                              child: card,
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

  Offset _getStackedCardOffset(TouristCard card) {
    int diff = card.index - currentIndex;
    if (card.index == currentIndex + 1) {
      print('animation');
      return _moveAnim.value;
    } else if (diff > 0 && diff <= 2) {
      print('move 0.5');
      return Offset(0.0, -0.05 * diff);
    } else {
      print('move 0');
      return Offset(0.0, 0.0);
    }
  }

  double _getStackedCardScale(TouristCard card) {
    int diff = card.index - currentIndex;
    if (card.index == currentIndex) {
      return 1.0;
    } else if (card.index == currentIndex + 1) {
      return _scaleAnim.value;
    } else {
      return (1 - (0.035 * diff.abs()));
    }
  }

  Offset _getFlickTransformOffset(TouristCard card) {
    if (card.index == currentIndex) {
      return _translationAnim.value;
    }
    return Offset(0.0, 0.0);
  }

  void _horizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      // Swiped Right to Left
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          TouristCard removedCard = cards.removeAt(0);
          cards.add(removedCard);
          currentIndex = cards[0].index;
        });
      });
    }
  }
}
