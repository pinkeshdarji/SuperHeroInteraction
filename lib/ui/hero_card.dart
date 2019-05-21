import 'package:flutter/material.dart';
import 'package:super_hero_interaction/models/character.dart';

class HeroCard extends StatelessWidget {
  final Character character;
  final double characterScaleFactor;
  final Color ccColor;
  final double border;

  HeroCard(
      {this.character, this.characterScaleFactor, this.ccColor, this.border});

  @override
  Widget build(BuildContext context) {
    TextStyle textKnowMore = Theme.of(context)
        .textTheme
        .subhead
        .copyWith(color: Colors.yellow, letterSpacing: 2);

    return Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: ccColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),)),
        ),
        Positioned(
          top: -150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Transform.scale(
                scale: characterScaleFactor,
                child: Image.asset(
                  character.url,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        '${character.name.toLowerCase()}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 100,
                    ),
                    Text(
                      character.actor.toLowerCase(),
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                      width: 100,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Know more ",
                          style: textKnowMore,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.amber,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

//TODO change name
//TODO Color perfaction
