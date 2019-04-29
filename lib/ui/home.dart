import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:super_hero_interaction/models/apiresponse.dart';
import 'package:super_hero_interaction/utilities/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Apiresponse> apiresponse;

  @override
  void initState() {

    super.initState();
    apiresponse = loadCharacters();
  }


  Future<Apiresponse> loadCharacters() async {
    String jsonString;

    if(Settings.isMock){
      //Load from local
      jsonString = await rootBundle.loadString('assets/json/characters.json');
    }else{
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
      appBar: AppBar(title: Text('spider man'),),
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
                  child: Image.asset(snapshot.data.data.characters[index].url),
                ),
              );
            },
          )
              : Center(child: CircularProgressIndicator());
        },
      )
      ,
    );
  }




}
