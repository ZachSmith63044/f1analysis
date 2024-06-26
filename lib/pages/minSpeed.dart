import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class MinimumSpeed extends StatefulWidget {
  const MinimumSpeed({super.key});

  @override
  State<MinimumSpeed> createState() => _MinimumSpeedState();
}

List<String> driverList = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
List<String> teamList = ["Red Bull Racing", "McLaren", "Ferrari", "Mercedes", "Aston Martin", "Alpine", "AlphaTauri", "Alfa Romeo", "Haas F1 Team", "Williams", "RB", "Kick Sauber"];
List<Color> colours = [
  Color.fromRGBO(0, 9, 255, 1),
  Color.fromRGBO(255, 111, 0, 1),
  Color.fromRGBO(255, 0, 0, 1),
  Color.fromRGBO(0, 255, 145, 1),
  Color.fromRGBO(3, 122, 104, 1),
  Color.fromRGBO(253, 75, 199, 1),
  Color.fromRGBO(2, 25, 43, 1),
  Color.fromRGBO(164, 33, 52, 1),
  Color.fromRGBO(109, 109, 109, 1),
  Color.fromRGBO(0, 160, 222, 1),
  Color.fromRGBO(22, 84, 255, 1),
  Color.fromRGBO(0, 222, 18, 1)
];

class _MinimumSpeedState extends State<MinimumSpeed> {
  Map<String, dynamic> mapData = {};

  bool load = false;

  

  Color backgroundColor = Colors.white;
  Color textColour = Colors.black;
  Color sliderActive = Color.fromARGB(255, 92, 92, 92);
  Color sliderInactive = Color.fromARGB(255, 141, 141, 141);

  List<dynamic> maxSpeeds = [];
  List<String> teams = [];
  List<Color> teamColours = [];

  List<String> teamNames = ["Red Bull Racing", "McLaren", "Ferrari", "Mercedes", "Aston Martin", "Alpine", "AlphaTauri", "Alfa Romeo", "Haas F1 Team", "Williams", "RB", "Kick Sauber"];

  bool darkMode = false;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {

    List<BarChartGroupData> barData = [
      
    ];

    double getMin(List<dynamic> list)
    {
      double min = list[0].toDouble();
      for (int i = 1; i < list.length; i++)
      {
        if (list[i] < min)
        {
          min = list[i].toDouble();
        }
      }
      return min;
    }

    double getMax(List<dynamic> list)
    {
      double min = list[0].toDouble();
      for (int i = 1; i < list.length; i++)
      {
        if (list[i] > min)
        {
          min = list[i].toDouble();
        }
      }
      return min;
    }

    void getMinSpeeds(List<dynamic> drivers, List<dynamic> teamsIn)
    {
      List<dynamic> maximumSpeeds = [];
      print(drivers);
      print(teams);
      for (int i = 0; i < drivers.length; i++)
      {
        try
        {
          double maximum = 0;
          double fastest = 10000;
          int choose = 0;
          for (int j = 0; j < mapData[drivers[i].toString()][0].length; j++)
          {
            if (mapData[drivers[i].toString()][0][j][2] < fastest && mapData[drivers[i].toString()][0][j][2] != -1)
            {
              fastest = mapData[drivers[i].toString()][0][j][2];
              choose = j;
            }
          }
          maximum = mapData[drivers[i].toString()][1][choose].reduce((current, next) => current < next ? current : next) as double;
          print(maximum.toString() + " " + i.toString());
          maximumSpeeds.add(maximum.toInt());
        }
        catch (e)
        {
          maximumSpeeds.add(-1);
        }
        
      }
      
      print(maximumSpeeds);

      List<int> teamNums = [];
      List<int> speeds = [];
      for (int i = 0; i < maximumSpeeds.length; i++)
      {
        if (!teamNums.contains(teamsIn[i]) && teamsIn[i] != -1)
        {
          teamNums.add(teamsIn[i]);
          speeds.add(maximumSpeeds[i]);
        }
        else if (teamsIn[i] != -1)
        {
          if (speeds[teamNums.indexOf(teamsIn[i])] == -1 || speeds[teamNums.indexOf(teamsIn[i])] < maximumSpeeds[i])
          {
            speeds[teamNums.indexOf(teamsIn[i])] = maximumSpeeds[i];
          }
        }
      }
      print(teamNums);
      print(speeds);
      print(teamList);
      setState(() {
        maxSpeeds = speeds;
        teams = [];
        for (int i = 0; i < teamNums.length; i++)
        {
          teams.add(teamList[teamNums[i]]);
        }

        bool flag = true;
        while (flag)
        {
          flag = false;
          for (int i = 0; i < maxSpeeds.length - 1; i++)
          {
            if (maxSpeeds[i] < maxSpeeds[i + 1])
            {
              int temp = maxSpeeds[i + 1];
              maxSpeeds[i + 1] = maxSpeeds[i];
              maxSpeeds[i] = temp;
              String temp2 = teams[i + 1];
              teams[i + 1] = teams[i];
              teams[i] = temp2;
              flag = true;
            }
          }
        }

        teamColours = [];
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          teamColours.add(colours[teamNames.indexOf(teams[i])]);
        }

        barData = [];
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          barData.add(
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: maxSpeeds[i].toDouble(),
                width: 75,
                color: teamColours[i],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
              )],
              showingTooltipIndicators: [0],
            ),
          );
        }
      });
    }
    
    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      
      

      maxSpeeds = [313.0, 310.0, 309.0, 313.0, 310.0, 309.0, 313.0, 310.0, 309.0, 314.0];
      teams = ["Mercedes", "Red Bull", "Mercedes", "Mercedes", "Mercedes", "Mercedes", "Mercedes", "Mercedes", "Mercedes", "Mercedes"];
      teamColours = [
        Color.fromARGB(255, 0, 255, 179),
        Colors.blueAccent,
        Colors.orange,
        Colors.red,
        Colors.green,
        Colors.pinkAccent,
        Colors.blue,
        Colors.greenAccent,
        Colors.grey,
        Colors.blueAccent,
      ];

      for (int i = 0; i < maxSpeeds.length; i++)
      {
        barData.add(
          BarChartGroupData(
            x: i,
            barRods: [BarChartRodData(
              toY: maxSpeeds[i] as double,
              width: 75,
              color: teamColours[i],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
            )],
            showingTooltipIndicators: [0],
          ),
        );
      }

      getMinSpeeds(mapData["results"], mapData["teams"]);

    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Max Speeds Graph'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
        actions: [
          
          IconButton(
            icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                load = false;
                if (darkMode)
                {
                  backgroundColor = Colors.white;
                  textColour = Colors.black;
                  sliderActive = Color.fromARGB(255, 92, 92, 92);
                  sliderInactive = Color.fromARGB(255, 141, 141, 141);
                  darkMode = false;
                }
                else
                {
                  textColour = Colors.white;
                  backgroundColor = Colors.black;
                  sliderActive = Color.fromARGB(255, 92, 92, 92);
                  sliderInactive = Color.fromARGB(255, 141, 141, 141);
                  darkMode = true;
                }
                
                
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.screenshot_monitor),
            onPressed: () {
              print('Screenshot');
              screenshotController
                  .capture(delay: Duration(milliseconds: 5000))
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
        ],
      ),
      
      body: 
        Screenshot(
          controller: screenshotController,
          child: Container(
            height: 1000,
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  teams[value.toInt()],
                                  style: TextStyle(
                                    color: textColour
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text(
                              "Top Speed (km/h) during fastest lap by a team's driver",
                              style: TextStyle(
                                color: textColour
                              ),
                            ),
                            axisNameSize: 24,
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: textColour
                                  ),
                                );
                              },
                            )
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              interval: 1,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: textColour
                                  ),
                                );
                              },
                            )
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text(
                              "Team Name",
                              style: TextStyle(
                                color: textColour
                              ),
                            ),
                            axisNameSize: 24,
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  teams[value.toInt()],
                                  style: TextStyle(
                                    color: textColour
                                  ),
                                );
                              },
                            ),
                          )
                        ),
                        maxY: getMax(maxSpeeds) + 1.5,
                        minY: getMin(maxSpeeds) - 1.5,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 8,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                rod.toY.round().toString(),
                                TextStyle(
                                  color: textColour,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        groupsSpace: 10,
                        barGroups: barData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        ),

    );
  }
}