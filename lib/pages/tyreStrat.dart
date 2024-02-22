import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
List numbers = [];
List<String> driverNames = [];
List<String> names = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
List<String> numbersNames = ["1", "11", "4", "81", "16", "55", "44", "63", "14", "18", "10", "31", "3", "22", "40", "77", "24", "27", "20", "23", "2", "21", "7", "99", "5"];
List drivers = [];
List teams = [];
double minY = 0;
double maxY = 130;
bool repeat = true;
List<List<double>> lapTimes = [];
List<List<String>> dataShown = [];
List<Widget> childrenCol = [];
List<Color> colourPallete = [Color.fromARGB(255, 255, 0, 0), Color.fromARGB(255, 219, 255, 18), Color.fromARGB(255, 0, 255, 17)];
List<List<Color>> coloursDrivers = [];
List<List<bool>> drsOpen = [];

class TyreStratView extends StatefulWidget {
  @override
  State<TyreStratView> createState() => _TyreStratViewState();
}

class _TyreStratViewState extends State<TyreStratView> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    
    if (repeat)
    {
      print("1");
      Map<String, dynamic> mapData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      numbers = mapData["results"];
      teams = mapData["teams"];
      drivers = mapData["driver3"];
      
      print(numbers);

      List<List<int>> tyres = [];
      List<List<int>> stintLength = [];
      
      for (int i = 0; i < numbers.length; i++)
      {
        print(i);
        print(mapData![numbers[i].toString()][14].length);
        print(mapData![numbers[i].toString()][14]);
        int stintNum = 0;
        for (int j = 0; j < mapData![numbers[i].toString()][14].length; j++)
        {
          print(j);
          stintNum = mapData![numbers[i].toString()][14][j][4];
          print(stintNum);
        }
      }
    }
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Plot Race Pace'),
        actions: [
          IconButton(
            icon: Icon(Icons.screenshot_monitor),
            tooltip: 'Take Screenshot',
            onPressed: () {
              print('Screenshot');
              screenshotController
                  .capture(delay: Duration(milliseconds: 10))
                  .then((capturedImage) async {
                try {
                  // Get the path to the device's Downloads directory
                  final directory = await getDownloadsDirectory() as Directory;
                  final filePath = '${directory.path}/screenshot304032.png';

                  // Create a File object and write the captured image to it
                  File file = File(filePath);
                  await file.writeAsBytes(Uint8List.fromList(capturedImage!));
                  
                  // Print a success message
                  print('Screenshot saved to: $filePath');
                } catch (e) {
                  // Handle any errors that occur during the process
                  print('Error saving screenshot: $e');
                }
              }).catchError((onError) {
                // Handle any errors that occur during the screenshot capture
                print('Error capturing screenshot: $onError');
              });

            },
          ),
        ]
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "TITLE2",
                //style: TextStyle
              ),
            ],
          ),
        ),
      ),
    );
  }
}
