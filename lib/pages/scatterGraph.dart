import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import "dart:io";

class ScatterGraph extends StatefulWidget {
  const ScatterGraph({super.key});

  @override
  State<ScatterGraph> createState() => _ScatterGraphState();
}

Map<String, dynamic> mapData = {};

String title = "";
List<List<double>> xAxis = [];
List<List<double>> yAxis = [];
ScatterChartData data = ScatterChartData();
List<ScatterSpot> coordinates = [];
List<Color> lineColour = [Colors.transparent];
String xAxisTitle = "";
String yAxisTitle = "";
bool toMins = false;

class _ScatterGraphState extends State<ScatterGraph> {
  List<int> selectedSpots = [];
  bool load = false;
  ScreenshotController screenshotController = ScreenshotController();

  double findLowestValue(List<List<double>> data) {
    double minValue = double.infinity; // Start with a very large value
    for (List<double> sublist in data) {
      for (double value in sublist) {
        if (value < minValue) {
          minValue = value;
        }
      }
    }
    return minValue;
  }

  double findHighestValue(List<List<double>> data) {
    double minValue = 0; // Start with a very large value
    for (List<double> sublist in data) {
      for (double value in sublist) {
        if (value > minValue) {
          minValue = value;
        }
      }
    }
    return minValue;
  }

  String formatSeconds2(double seconds) {
    int minutes = (seconds % 3600) ~/ 60;
    double remainingSeconds = seconds % 60;
    remainingSeconds = double.parse(remainingSeconds.toStringAsFixed(3));
    String minutesStr = (minutes < 10) ? '$minutes' : '$minutes';
    String secondsStr = (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

    return '$minutesStr:$secondsStr';
  }

  void NewTitle(BuildContext context) async {
    String newTitle = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter League Info'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      newTitle = value; // Update the input value when the user types.
                    },
                    decoration: InputDecoration(labelText: 'Enter New Title'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 0, 31, 236))),
            ),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 31, 100), // Set your desired color here
              ),
              child: const Text('Custom'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  title = newTitle;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 31, 236), // Set your desired color here
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    load = false;
  }

  @override
  Widget build(BuildContext context) {

    void resetData()
    {
      setState(() {
        coordinates = [];
        int count = 0;
        for (int i = 0; i < xAxis.length; i++)
        {
          for (int j = 0; j < xAxis[i].length; j++)
          {
            Color colour = lineColour[i];
            if (selectedSpots.contains(count))
            {
              colour = Colors.purple;
            }
            coordinates.add(ScatterSpot(
              xAxis[i][j], yAxis[i][j],
              radius: 5,
              color: colour,
              show: true,
            ));
            count++;
          }
        }
      });
    }


    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      setState(() {      
        xAxis = mapData["xAxis"];
        yAxis = mapData["yAxis"];
        title = mapData["title"];
        lineColour = mapData["colour"];
        xAxisTitle = mapData["xAxisTitle"];
        yAxisTitle = mapData["yAxisTitle"];
        toMins = mapData["toMins"];
        coordinates = [];
        title = mapData["title"];
        for (int i = 0; i < xAxis.length; i++)
        {
          for (int j = 0; j < xAxis[i].length; j++)
          {
            coordinates.add(ScatterSpot(
              xAxis[i][j], yAxis[i][j],
              radius: 5,
              color: lineColour[i],
              show: true,
            ));
          }
        }
      });
      
      print(xAxis.toString() + "xAxis");
      print(yAxis.toString() + "yAxis");
      load = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.screenshot_monitor),
            onPressed: () {
              print('Screenshot');
              screenshotController
                  .capture(delay: Duration(milliseconds: 30), pixelRatio: 15.0)
                  .then((capturedImage) async {
                try {
                  // Get the path to the device's Downloads directory
                  final directory = await getDownloadsDirectory() as Directory;
                  final filePath = '${directory.path}/${title}f1analaysis.png';

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
          IconButton(
            onPressed: ()
            {
              NewTitle(context);
            },
            icon: Icon(Icons.edit)
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: SingleChildScrollView(
        
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Color.fromARGB(255, 20, 20, 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 800,
                    child: ScatterChart(
                      ScatterChartData(
                        scatterSpots: coordinates,
                        minX: findLowestValue(xAxis).round() - 1,
                        maxX: findHighestValue(xAxis).round() + 1,
                        minY: findLowestValue(yAxis).round() - 1,
                        maxY: findHighestValue(yAxis).round() + 1,
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            )
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            )
                          ),
                          bottomTitles: AxisTitles(
                            axisNameSize: 25,
                            axisNameWidget: Text(
                              xAxisTitle,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            sideTitles: SideTitles(
                              getTitlesWidget: (value, meta) => Text(value.round().toString(), style: TextStyle(color: Color.fromARGB(255, 150, 150, 150)),),
                              showTitles: true,
                              reservedSize: 15,
                            )
                          ),
                          leftTitles: AxisTitles(
                            axisNameSize: 25,
                            axisNameWidget: Text(
                              yAxisTitle,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            sideTitles: SideTitles(
                              getTitlesWidget: (value, meta) => Text(value.round().toString(), style: TextStyle(color: Color.fromARGB(255, 150, 150, 150)),),
                              showTitles: true,
                              reservedSize: 25,
                            )
                          ),
                        ),
                        showingTooltipIndicators: selectedSpots,
                        scatterTouchData: ScatterTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          mouseCursorResolver:
                              (FlTouchEvent touchEvent, ScatterTouchResponse? response) {
                            return response == null || response.touchedSpot == null
                                ? MouseCursor.defer
                                : SystemMouseCursors.click;
                          },
                          touchTooltipData: ScatterTouchTooltipData(
                            tooltipBgColor: Colors.black,
                            getTooltipItems: (ScatterSpot touchedBarSpot) {
                              if (toMins)
                              {
                                return ScatterTooltipItem(
                                  '$xAxisTitle: ',
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    height: 1.2,
                                    color: touchedBarSpot.color,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  bottomMargin: -70,
                                  children: [
                                    TextSpan(
                                      text: '${touchedBarSpot.x.toStringAsFixed(1)} \n',
                                      style: TextStyle(
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '$yAxisTitle: ',
                                      style: TextStyle(
                                        height: 1.2,
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: formatSeconds2(touchedBarSpot.y),
                                      style: TextStyle(
                                        height: 1.2,
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else
                              {
                                return ScatterTooltipItem(
                                  'X: ',
                                  textStyle: TextStyle(
                                    height: 1.2,
                                    color: touchedBarSpot.color,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  bottomMargin: -65,
                                  children: [
                                    TextSpan(
                                      text: '${touchedBarSpot.x.toInt()} \n',
                                      style: TextStyle(
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Y: ',
                                      style: TextStyle(
                                        height: 1.2,
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: touchedBarSpot.y.toString(),
                                      style: TextStyle(
                                        color: touchedBarSpot.color,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          touchCallback:
                              (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                            if (touchResponse == null ||
                                touchResponse.touchedSpot == null) {
                              return;
                            }
                            if (event is FlTapUpEvent) {
                              final sectionIndex = touchResponse.touchedSpot!.spotIndex;
                              setState(() {
                                if (selectedSpots.contains(sectionIndex)) {
                                  selectedSpots.remove(sectionIndex);
                                } else {
                                  selectedSpots.add(sectionIndex);
                                }
                                resetData();
                              });
                            }
                          },
                        ),
                      ),
                      
                    )
                  ),
                ]
              )
            ),
          ),
        )
      )
    );
  }
}