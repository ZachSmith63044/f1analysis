import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import "package:f1analysis/getDataPoints.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class LoadSeasonPoints extends StatefulWidget {
  const LoadSeasonPoints({super.key});

  @override
  State<LoadSeasonPoints> createState() => _LoadSeasonPointsState();
}

class _LoadSeasonPointsState extends State<LoadSeasonPoints> {
  Future<void> loadData(String year) async
  {
    print("start");
    await copyScriptFromAssets(year);
    print("done");
    final tempDir = (await getApplicationDocumentsDirectory()).path;
    File jsonFile = File("${tempDir}\\f1dataanalysisappdata\\seasondata.json");
    String jsonString = await jsonFile.readAsString();
    Map<String, dynamic> jsonMap = await json.decode(jsonString);
    print(jsonMap);
    Navigator.of(context).pop();
    Navigator.pushNamed(
      context,
      '/seasonpoints', // Specify the route name
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
      loadData(mapData["year"]);
      
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitPouringHourGlass(
                color: Colors.white,
                size: 140,
                strokeWidth: 8,
              ),
              Text(
                "Loading",
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)
              )
            ],
          )
        )
      )
    );
  }
}