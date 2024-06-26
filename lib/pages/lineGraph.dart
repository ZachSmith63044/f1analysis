import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import "dart:io";

class LineGraph extends StatefulWidget {
  const LineGraph({super.key});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

Map<String, dynamic> mapData = {};

String title = "";
List<List<double>> xAxis = [];
List<List<double>> yAxis = [];
List<LineChartBarData> data = [LineChartBarData()];
List<Color> lineColour = [Colors.transparent];
String xAxisTitle = "";
String yAxisTitle = "";
bool toMins = false;

class _LineGraphState extends State<LineGraph> {
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

  @override
  void initState() {
    super.initState();
    load = false;
  }

  @override
  Widget build(BuildContext context) {
    int touchedValue = -1;

    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      xAxis = mapData["xAxis"];
      yAxis = mapData["yAxis"];
      title = mapData["title"];
      lineColour = mapData["colour"];
      xAxisTitle = mapData["xAxisTitle"];
      yAxisTitle = mapData["yAxisTitle"];
      toMins = mapData["toMins"];
      List<List<FlSpot>> coordinates = [];
      data = [];
      for (int i = 0; i < xAxis.length; i++)
      {
        coordinates.add([]);
        for (int j = 0; j < xAxis[i].length; j++)
        {
          coordinates[i].add(FlSpot(xAxis[i][j], yAxis[i][j]));
        }
        data.add(LineChartBarData(
          spots: coordinates[i],
          isCurved: false,
          barWidth: 3,
          color: lineColour[i],
          dotData: FlDotData(show: false),
        ));
      }
      
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
                  final filePath = '${directory.path}/f1analaysiskvaefhu.png';

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
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: SingleChildScrollView(
        child: Column(

        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Color.fromARGB(255, 20, 20, 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 800,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine:(value) => FlLine(
                          color: Color.fromARGB(255, 70, 70, 70),
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine:(value) => FlLine(
                          color: Color.fromARGB(255, 70, 70, 70),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color.fromARGB(255, 100, 100, 100),
                          width: 1,
                        ),
                      ),
                      clipData: FlClipData(
                        bottom: true,
                        top: true,
                        left: true,
                        right: true,
                      ),
                      titlesData: FlTitlesData(
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
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false
                          )
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false
                          )
                        ),
                      ),
                      minX: findLowestValue(xAxis) - 1,
                      maxX: findHighestValue(xAxis) + 1,
                      minY: findLowestValue(yAxis) - 1,
                      maxY: findHighestValue(yAxis) + 1,
                      lineBarsData: data,
                      lineTouchData: LineTouchData(
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((spotIndex) {
                          final spot = barData.spots[spotIndex];
                          if (spot.x == 0 || spot.x == 6) {
                            return null;
                          }
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: Colors.grey,
                              strokeWidth: 4,
                            ),
                            FlDotData(
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: Colors.green,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black,
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final flSpot = barSpot;
                            if (flSpot.x == 0 || flSpot.x == 6) {
                              return null;
                            }
                      
                            TextAlign textAlign;
                            switch (flSpot.x.toInt()) {
                              case 1:
                                textAlign = TextAlign.left;
                                break;
                              case 5:
                                textAlign = TextAlign.right;
                                break;
                              default:
                                textAlign = TextAlign.center;
                            }
                            if (toMins)
                            {
                              return LineTooltipItem(
                                'Lap Time: ',
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: formatSeconds2(flSpot.y),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                                textAlign: textAlign,
                              );
                            }
                            else
                            {
                              return LineTooltipItem(
                                'Lap Time: ',
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: flSpot.y.toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                                textAlign: textAlign,
                              );
                            }
                          }).toList();
                        },
                      ),
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? lineTouch) {
                        if (!event.isInterestedForInteractions ||
                            lineTouch == null ||
                            lineTouch.lineBarSpots == null) {
                          setState(() {
                            touchedValue = -1;
                          });
                          return;
                        }
                        final value = lineTouch.lineBarSpots![0].x;
                      
                        if (value == 0 || value == 6) {
                          setState(() {
                            touchedValue = -1;
                          });
                          return;
                        }
                      
                        setState(() {
                          touchedValue = value.toInt();
                        });
                      },
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ]
        )
      )
    );
  }

}