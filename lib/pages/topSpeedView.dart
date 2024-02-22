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

class TopSpeedView extends StatefulWidget {
  @override
  State<TopSpeedView> createState() => _TopSpeedViewState();
}

class _TopSpeedViewState extends State<TopSpeedView> {
  ScreenshotController screenshotController = ScreenshotController();

  

  @override
  Widget build(BuildContext context) {
    
    if (repeat)
    {
      Map<String, dynamic> mapData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      numbers = mapData["results"];
      teams = mapData["teams"];
      drivers = mapData["driver3"];
      
      

      List<List<dynamic>> topSpeeds = [];
      List<List<dynamic>> drsUsed = [];
      for (int i = 0; i < numbers.length; i++)
      {
        List<dynamic> topSpeeds2 = [];
        List<dynamic> drsUsed2 = [];
        for (int j = 0; j < mapData![numbers[i].toString()][1].length; j++)
        {
          dynamic maxSpeed = 0;
          bool drs = false;
          for (int k = 0; k < mapData![numbers[i].toString()][1][j].length; k++)
          {
            if (maxSpeed < mapData![numbers[i].toString()][1][j][k])
            {
              maxSpeed = mapData![numbers[i].toString()][1][j][k];
              if (mapData![numbers[i].toString()][6][j][k] == 0)
              {
                drs = false;
              }
              else
              {
                drs = true;
              }
            }
          }
          topSpeeds2.add(maxSpeed);
          drsUsed2.add(drs);
        }
        topSpeeds.add(topSpeeds2);
        drsUsed.add(drsUsed2);
      }

      print(topSpeeds);
      print(drsUsed);

      for (int i = 0; i < topSpeeds.length; i++)
      {
        bool flag = true;
        while (flag)
        {
          flag = false;
          for (int j = 0; j < topSpeeds[i].length - 1; j++)
          {
            if (topSpeeds[i][j] < topSpeeds[i][j + 1])
            {
              dynamic temp = topSpeeds[i][j + 1];
              topSpeeds[i][j + 1] = topSpeeds[i][j];
              topSpeeds[i][j] = temp;
              temp = drsUsed[i][j + 1];
              drsUsed[i][j + 1] = drsUsed[i][j];
              drsUsed[i][j] = temp;

              flag = true;
            }
          }
        }
      }

      print(drivers);

      int sub = 0;
      for (int i = 0; i < topSpeeds.length; i++)
      {

        if (topSpeeds[i - sub].length <= 10)
        {
          topSpeeds.removeAt(i - sub);
          drsUsed.removeAt(i - sub);
          sub += 1;
        }
      }

      int findMaxLength()
      {
        List<int> list = [topSpeeds.length, drivers.length];
        return list.reduce((curr, next) => curr < next? curr: next);
      }

      bool flag = true;
      while (flag)
      {
        flag = false;
        //for (int i = 0; i < topSpeeds.length - 1; i++)
        for (int i = 0; i < findMaxLength() - 1; i++)
        {
          if (topSpeeds[i + 1].length != 0 && topSpeeds[i].length != 0)
          {
            if (topSpeeds[i][0] < topSpeeds[i + 1][0])
            {
              List<dynamic> temp = topSpeeds[i + 1];
              topSpeeds[i + 1] = topSpeeds[i];
              topSpeeds[i] = temp;
              temp = drsUsed[i + 1];
              drsUsed[i + 1] = drsUsed[i];
              drsUsed[i] = temp;
              dynamic temp2 = drivers[i + 1];
              drivers[i + 1] = drivers[i];
              drivers[i] = temp2;
              flag = true;
            }
          }
          
        }
      }

      print(topSpeeds);
      print(drsUsed);
      print(drivers);

      dataShown = [];

      double maxSpeedEver = 0;
      double minSpeedEver = 500;

      List<List<dynamic>> allSpeeds = [];

      drsOpen = [];

      for (int i = 0; i < findMaxLength(); i++)
      {
        List<String> dataShown2 = [];
        
        if (topSpeeds[i].length > 10)
        {
          dataShown2.add(names[drivers[i]]);
          List<dynamic> averageCheck = [];
          List<dynamic> allSpeeds2 = [];
          List<bool> drsOpen2 = [];
          for (int j = 0; j < 10; j++)
          {
            allSpeeds2.add(topSpeeds[i][j]);
            averageCheck.add(topSpeeds[i][j]);
            dataShown2.add(topSpeeds[i][j].toString());
            drsOpen2.add(drsUsed[i][j]);
            if (maxSpeedEver < topSpeeds[i][j])
            {
              maxSpeedEver = topSpeeds[i][j];
            }
            if (minSpeedEver > topSpeeds[i][j])
            {
              minSpeedEver = topSpeeds[i][j];
            }
          }
          double average = averageCheck.reduce((value, element) => value + element)/averageCheck.length;
          allSpeeds2.add(average);
          dataShown2.add(average.toString());
          dataShown.add(dataShown2);
          allSpeeds.add(allSpeeds2);
          drsOpen2.add(false);
          drsOpen.add(drsOpen2);
        }

      }
      
      print(dataShown);
      print(maxSpeedEver);
      print(minSpeedEver);
      print(allSpeeds);
      for (int i = 0; i < allSpeeds.length; i++)
      {
        List<Color> coloursIn = [];
        for (int j = 0; j < allSpeeds[i].length; j++)
        {
          double diff = (allSpeeds[i][j] - minSpeedEver)/(maxSpeedEver-minSpeedEver);
          print(diff);
          print(Color.fromARGB(255, (colourPallete[0].red + (colourPallete[1].red - colourPallete[0].red)*diff).toInt(), (colourPallete[0].green + (colourPallete[1].green - colourPallete[0].green)*diff).toInt(), (colourPallete[0].blue + (colourPallete[1].blue - colourPallete[0].blue)*diff).toInt()));
          if (diff < 0.5)
          {
            coloursIn.add(Color.fromARGB(255, (colourPallete[0].red + (colourPallete[1].red - colourPallete[0].red)*diff*2).toInt(), (colourPallete[0].green + (colourPallete[1].green - colourPallete[0].green)*diff*2).toInt(), (colourPallete[0].blue + (colourPallete[1].blue - colourPallete[0].blue)*diff*2).toInt()));
          }
          else
          {
            coloursIn.add(Color.fromARGB(255, (colourPallete[1].red + (colourPallete[2].red - colourPallete[1].red)*(diff-0.5)*2).toInt(), (colourPallete[1].green + (colourPallete[2].green - colourPallete[1].green)*(diff-0.5)*2).toInt(), (colourPallete[1].blue + (colourPallete[2].blue - colourPallete[1].blue)*(diff-0.5)*2).toInt()));
          }
          // if (diff < 0.5) {
          //   diff = diff * 2;
          //   print(Color.fromARGB(255, (colourPallete[0].red + (colourPallete[1].red - colourPallete[0].red)*diff).toInt(), (colourPallete[0].green + (colourPallete[1].green - colourPallete[0].green)*diff).toInt(), (colourPallete[0].blue + (colourPallete[1].blue - colourPallete[0].blue)*diff).toInt()));
          //   coloursIn.add(Color.fromARGB(255, (colourPallete[0].red + (colourPallete[1].red - colourPallete[0].red)*diff).toInt(), (colourPallete[0].green + (colourPallete[1].green - colourPallete[0].green)*diff).toInt(), (colourPallete[0].blue + (colourPallete[1].blue - colourPallete[0].blue)*diff).toInt()));
          // }
          // else
          // {
          //   diff = (diff - 0.5) * 2;
          //   print(Color.fromARGB(255, (colourPallete[1].red + (colourPallete[2].red - colourPallete[1].red)*diff).toInt(), (colourPallete[1].green + (colourPallete[2].green - colourPallete[1].green)*diff).toInt(), (colourPallete[1].blue + (colourPallete[2].blue - colourPallete[1].blue)*diff).toInt()));
          //   coloursIn.add(Color.fromARGB(255, (colourPallete[1].red + (colourPallete[2].red - colourPallete[1].red)*diff).toInt(), (colourPallete[1].green + (colourPallete[2].green - colourPallete[1].green)*diff).toInt(), (colourPallete[1].blue + (colourPallete[2].blue - colourPallete[1].blue)*diff).toInt()));
          // }
        }
        coloursDrivers.add(coloursIn);
      }
      print(coloursDrivers);

      // childrenCol = [];

      // for (int i = 0; i < dataShown.length; i++)
      // {
      //   childrenCol.add(
      //     Row(
      //       children: [
      //         Container(
      //           height: 30,
      //           width: 140,
      //           child: Center(child: Text(dataShown[i][0], textAlign: TextAlign.center,)),
      //         ),
      //         for (int j = 1; j < dataShown[i].length; j++) 
      //         Container(
      //           color: Colors.black,
      //           height: 30,
      //           width: 100,
      //           child: Center(
      //             child: Text(
      //               dataShown[i][j],
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 color: Colors.white
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     )
      //   );
      // }
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
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                for (int i = 0; i < dataShown.length; i++)
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 50,
                        child: Text(dataShown[i][0]),
                      ),
                      for (int j = 1; j < dataShown[i].length; j++)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey), // Add a grey border
                              color: coloursDrivers[i][j - 1],
                            ),
                            height: 30,
                            child: Center(
                              child: Text(
                                dataShown[i][j],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: (drsOpen[i][j - 1]) ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
