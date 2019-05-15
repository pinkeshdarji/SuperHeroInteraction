import 'package:flutter/material.dart';

class TouristCard extends StatelessWidget {
  final int index;
  final String imageUrl;
  TouristCard({this.index, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    TextStyle cardTitleStyle =
        Theme.of(context).textTheme.title.copyWith(fontSize: 24.0);
    TextStyle cardSubtitleStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(fontSize: 20.0, color: Colors.grey);
    TextStyle cardButtonStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(fontSize: 16.0, color: Colors.white);

    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset("assets/images/$imageUrl"),
          FractionalTranslation(
            translation: Offset(1.7, -0.5),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.yellow,
              child: Icon(Icons.star),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Tourist Spot",
              style: cardTitleStyle,
            ),
          ),
        ]),
      ),
    );
  }
}
