import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class MaxSpeed extends StatefulWidget {
  const MaxSpeed({super.key});

  @override
  State<MaxSpeed> createState() => _MaxSpeedState();
}

List<String> driverList = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
List<String> teamList = ["Red Bull Racing", "McLaren", "Ferrari", "Mercedes", "Aston Martin", "Alpine", "AlphaTauri", "Alfa Romeo", "Haas F1 Team", "Williams", "RB", "Kick Sauber"];
List<Color> colours = [
  Color.fromRGBO(0, 8, 255, 1),
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

List<Color> colours2 = [
  Color.fromRGBO(0, 5, 157, 1),
  Color.fromRGBO(148, 57, 0, 1),
  Color.fromRGBO(128, 0, 0, 1),
  Color.fromRGBO(0, 123, 70, 1),
  Color.fromRGBO(2, 47, 45, 1),
  Color.fromRGBO(113, 29, 78, 1),
  Color.fromRGBO(1, 9, 16, 1),
  Color.fromRGBO(88, 18, 28, 1),
  Color.fromRGBO(54, 54, 54, 1),
  Color.fromRGBO(0, 74, 104, 1),
  Color.fromRGBO(10, 38, 113, 1),
  Color.fromRGBO(0, 96, 8, 1)
];

class _MaxSpeedState extends State<MaxSpeed> {
  Map<String, dynamic> mapData = {};

  int delay = 750;

  bool load = false;
  bool load2 = false;

  bool shown = false;

  Color backgroundColor = Colors.white;
  Color textColour = Colors.black;
  Color sliderActive = Color.fromARGB(255, 92, 92, 92);
  Color sliderInactive = Color.fromARGB(255, 141, 141, 141);

  List<dynamic> maxSpeeds = [];
  List<List<dynamic>> currentMaxSpeeds = [];
  List<String> teams = [];
  List<Color> teamColours = [];

  double sliderValue = 1;

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
    List<BarChartGroupData> barDataOg = [
      
    ];

    List<BarChartGroupData> currentData = [];

    bool swap = false;

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

    void getMaxSpeeds(bool drs, bool fastestLap, List<dynamic> drivers, List<dynamic> teamsIn)
    {
      List<dynamic> maximumSpeeds = [];
      print(drivers);
      print(teams);
      if (fastestLap)
      {
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
            maximum = mapData[drivers[i].toString()][1][choose].reduce((current, next) => current > next ? current : next) as double;
            print(maximum.toString() + " " + i.toString());
            maximumSpeeds.add(maximum.toInt());
          }
          catch (e)
          {
            maximumSpeeds.add(-1);
          }
          
        }
      }
      else
      {
        for (int i = 0; i < drivers.length; i++)
        {
          double maximum = 0;
          for (int j = 0; j < mapData[drivers[i].toString()][10].length; j++)
          {
            if (mapData[drivers[i].toString()][1][j].reduce((current, next) => current > next ? current : next) > maximum)
            {
              maximum = mapData[drivers[i].toString()][1][j].reduce((current, next) => current > next ? current : next) as double;
            }
          }
          print(maximum.toString() + " " + i.toString());
          maximumSpeeds.add(maximum.toInt());
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
        List<Color> teamColours2 = [];
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          teamColours.add(colours[teamNames.indexOf(teams[i])]);
          teamColours2.add(colours2[teamNames.indexOf(teams[i])]);
        }

        barDataOg = [];
        double multiple = sliderValue;
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          barDataOg.add(
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: 318,
                width: 75,
                //color: teamColours[i],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [
                    teamColours[i],
                    darkMode ? Color.fromRGBO((teamColours[i].red + (255 - teamColours[i].red) * (1 - multiple)).toInt(), (teamColours[i].green + (255 - teamColours[i].green) * (1 - multiple)).toInt(), (teamColours[i].blue + (255 - teamColours[i].blue) * (1 - multiple)).toInt(), 1) : Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                    
                    //teamColours[i],
                    //Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              )],
              showingTooltipIndicators: [0],
            ),
          );
        }

        barData = [];
        multiple = sliderValue;
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          barData.add(
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: maxSpeeds[i].toDouble(),
                width: 75,
                //color: teamColours[i],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [
                    teamColours[i],
                    darkMode ? Color.fromRGBO((teamColours[i].red + (255 - teamColours[i].red) * (1 - multiple)).toInt(), (teamColours[i].green + (255 - teamColours[i].green) * (1 - multiple)).toInt(), (teamColours[i].blue + (255 - teamColours[i].blue) * (1 - multiple)).toInt(), 1) : Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                    
                    //teamColours[i],
                    //Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              )],
              showingTooltipIndicators: [0],
            ),
          );
        }
        barData = barDataOg;
      });
    }

    void doBars()
    {
      setState(() {
        barData = [];
        double multiple = sliderValue;
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          barData.add(
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: maxSpeeds[i].toDouble(),
                width: 75,
                //color: teamColours[i],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [
                    teamColours[i],
                    darkMode ? Color.fromRGBO((teamColours[i].red + (255 - teamColours[i].red) * (1 - multiple)).toInt(), (teamColours[i].green + (255 - teamColours[i].green) * (1 - multiple)).toInt(), (teamColours[i].blue + (255 - teamColours[i].blue) * (1 - multiple)).toInt(), 1) : Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                    
                    //teamColours[i],
                    //Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              )],
              showingTooltipIndicators: [0],
            ),
          );
        }
      });
    }

    List<List<dynamic>> toMap(List<dynamic> speeds, List<Color> colours)
    {
      List<List<dynamic>> willBe = [];
      for (int i = 0; i < speeds.length; i++)
      {
        willBe.add([speeds[i], colours[i]]);
      }
      return willBe;
    }
    
    if (load == false)
    {
      load = true;
      if (!load2)
      {
        mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      }
      
      
      print("fu");
      
      getMaxSpeeds(true, true, mapData["results"], mapData["teams"]);
      currentData = barDataOg;
      if (load2)
      {
        currentMaxSpeeds = toMap(maxSpeeds, teamColours);
      }
      else
      {
        shown = false;
        
        double setSpeed = getMin(maxSpeeds) - 1.5;
        List<dynamic> maxSpeedInput = [];
        for (int i = 0; i < maxSpeeds.length; i++)
        {
          maxSpeedInput.add(setSpeed);
        }
        currentMaxSpeeds = toMap(maxSpeedInput, teamColours);
      }
      
      
      
      Future.delayed(Duration(milliseconds: 250), () {
        setState(() {
          swap = true;
          currentData = barData;
          currentMaxSpeeds = toMap(maxSpeeds, teamColours);
          
        });

        Future.delayed(Duration(milliseconds: delay), () {
          setState(() {
            shown = true;
          });
        });
        
      });

      print(barData);
      print(barDataOg);
      print(barData.length);
      print(barDataOg.length);

      load2 = true;
      

    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Max Speeds Graph'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
        actions: [
          Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.blueGrey,
            value: sliderValue,
            onChanged: (newValue) {
              setState(() {
                sliderValue = newValue;
                load = false;
                print(sliderValue);
              });
            },
            min: 0,
            max: 1,
            //divisions: 250, // Optional: Set the number of discrete intervals
            //label: '$sliderValue', // Optional: Show a label while dragging
          ),
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
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              setState(() {
                load2 = false;
              });
              
            }
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
                      swapAnimationDuration: Duration(milliseconds: shown ? 150 : delay),
                      swapAnimationCurve: Curves.easeInOut,
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
                        barGroups: currentMaxSpeeds.map((data) {
                          return BarChartGroupData(
                            x: currentMaxSpeeds.indexOf(data), // Use index as x value (you can customize this)
                            barRods: [
                              BarChartRodData(
                                toY: data[0].toDouble(), // Use the custom toY value
                                color: data[1],
                                width: 75,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                
                                gradient: LinearGradient(
                                  colors: [
                                    data[1],
                                    darkMode ? Color.fromRGBO((data[1].red + (255 - data[1].red) * (1 - sliderValue)).toInt(), (data[1].green + (255 - data[1].green) * (1 - sliderValue)).toInt(), (data[1].blue + (255 - data[1].blue) * (1 - sliderValue)).toInt(), 1) : Color.fromRGBO((data[1].red * sliderValue).toInt(), (data[1].green * sliderValue).toInt(), (data[1].blue * sliderValue).toInt(), 1),
                                    
                                    //teamColours[i],
                                    //Color.fromRGBO((teamColours[i].red * multiple).toInt(), (teamColours[i].green * multiple).toInt(), (teamColours[i].blue * multiple).toInt(), 1),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ],
                            showingTooltipIndicators: shown ? [0] : []
                          );
                        }).toList(),
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