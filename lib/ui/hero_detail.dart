import 'package:flutter/material.dart';
import 'package:super_hero_interaction/models/character.dart';

class HeroDetail extends StatefulWidget {
  final Character character;

  HeroDetail({Key key, this.character}) : super(key: key);

  @override
  _HeroDetailState createState() => _HeroDetailState();
}

class _HeroDetailState extends State<HeroDetail> with TickerProviderStateMixin {
  int _bgColor;
  Animation<Offset> animation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String colorString =
        "0xff${widget.character.background}".replaceAll("#", "");
    _bgColor = int.parse(colorString);

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.0))
        .animate(animationController);

    Future.delayed(Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle display3 =
        Theme.of(context).textTheme.display3.copyWith(color: Colors.black);
    TextStyle title =
        Theme.of(context).textTheme.title.copyWith(color: Colors.black);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SlideTransition(
              position: animation,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        stops: [0.9, 1.0],
                        colors: [Color(_bgColor), Colors.white70])),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 34, left: 24, right: 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(
                        tag: widget.character.url,
                        child: Image.asset(
                          widget.character.url,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      widget.character.name.toLowerCase(),
                      style: display3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.character.actor.toLowerCase(),
                        style: title,
                      ),
                      Image.asset(
                        'assets/images/marvelLogo.png',
                        width: 60,
                        height: 50,
                      )
                    ],
                  ),
                  Text(
                    widget.character.description,
                    maxLines: 3,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Divider(),
                  Text(
                    "movies",
                    style: title,
                  ),
                  Expanded(
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this would produce 2 rows.
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 10,
                      // Generate 100 Widgets that display their index in the List
                      children: List.generate(2, (index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Colors.redAccent,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/A${index + 1}.jpg'),
                                  fit: BoxFit.cover)),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
