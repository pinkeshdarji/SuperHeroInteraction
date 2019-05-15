import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:super_hero_interaction/models/apiresponse.dart';
import 'package:super_hero_interaction/utilities/settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Apiresponse> apiresponse;

  @override
  void initState() {
    super.initState();
    apiresponse = loadCharacters();
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
          margin: EdgeInsets.only(left: 30, top: 20),
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {}),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'movies',
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.normal,
                fontSize: 23),
          ),
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
              ? ListView.builder(
                  itemCount: snapshot.data.data.characters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data.data.characters[index].name),
                      leading: CircleAvatar(
                        child: Image.asset(
                            snapshot.data.data.characters[index].url),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
