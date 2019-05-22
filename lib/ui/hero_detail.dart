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
  Animation<Offset> titleAnimation;
  Animation<Offset> detailAnimation;
  AnimationController backgroundAnimationController;
  AnimationController titleAnimationController;
  AnimationController detailAnimationController;
  CurvedAnimation curvedAnimation;
  Color textColor = Colors.white;

  @override
  void initState() {
    super.initState();
// TODO: put animation code here

    String colorString =
        "0xff${widget.character.background}".replaceAll("#", "");
    _bgColor = int.parse(colorString);

    backgroundAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.0))
        .animate(backgroundAnimationController);

    //title animation
    titleAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    curvedAnimation = CurvedAnimation(
        parent: titleAnimationController, curve: Curves.easeOutBack);
    titleAnimation = Tween<Offset>(begin: Offset(0, 0.7), end: Offset(0, 0.0))
        .animate(curvedAnimation);

    //Detail animation
    detailAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    curvedAnimation = CurvedAnimation(
        parent: detailAnimationController, curve: Curves.easeOutBack);
    detailAnimation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0, 0.0))
        .animate(curvedAnimation);

    titleAnimationController.forward().whenComplete(() {
      setState(() {
        textColor = Colors.black;
      });
      backgroundAnimationController.forward().whenComplete(() {
        detailAnimationController.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle display3 =
        Theme.of(context).textTheme.display3.copyWith(color: textColor);
    TextStyle title =
        Theme.of(context).textTheme.title.copyWith(color: textColor);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                          stops: [0.7, 1.0],
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
                              _reverseAllAnimationAndPop();
                            })
                      ],
                    ),
                    SlideTransition(
                      position: titleAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SlideTransition(
                        position: detailAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
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
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<bool> _onWillPop() {
    _reverseAllAnimationAndPop();
  }

  void _reverseAllAnimationAndPop() {
    detailAnimationController.reverse().whenComplete(() {
      backgroundAnimationController.reverse().whenComplete(() {
        titleAnimationController.reverse().whenComplete(() {
          Navigator.of(context).pop(true);
        });
      });
    });
  }
}
