import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import "package:f1analysis/getData.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class LoadTyreStrategy extends StatefulWidget {
  const LoadTyreStrategy({super.key});

  @override
  State<LoadTyreStrategy> createState() => _LoadTyreStrategyState();
}

class _LoadTyreStrategyState extends State<LoadTyreStrategy> {
  Future<void> loadData(String year, String round, String session) async
  {
    print("start");
    await copyScriptFromAssets(year, round, session, false);
    print("done");
    final tempDir = (await getApplicationDocumentsDirectory()).path;
    File jsonFile = File('${tempDir}\\f1dataanalysisappdata\\names.json');
    String jsonString = await jsonFile.readAsString();
    Map<String, dynamic> jsonMap = await json.decode(jsonString);
    String data = jsonMap["name"];
    jsonFile = File(data);
    jsonString = await jsonFile.readAsString();
    jsonMap = await json.decode(jsonString);
    Navigator.of(context).pop();
    Navigator.pushNamed(
      context,
      '/tyrestratview',
      arguments: jsonMap
    );
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> mapData =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    if (mapData != null)
    {
      loadData(mapData["year"], mapData["round"], mapData["session"]);
      
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Start Menu'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Column(
            children: [
              SpinKitPouringHourGlass(
                color: Colors.white,
                size: 100,
                strokeWidth: 6,
              ),
              Text("Loading")
            ],
          )
        )
      )
    );
  }
}