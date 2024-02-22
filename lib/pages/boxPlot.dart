import 'dart:math';

import 'package:f1analysis/pages/speedTime.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
RangeValues _sliderValues = RangeValues(0, 1);
List<Color> colours = [
  Color.fromRGBO(0, 9, 255, 1),
  Color.fromRGBO(255, 111, 0, 1),
  Color.fromRGBO(255, 0, 0, 1),
  Color.fromRGBO(0, 255, 145, 1),
  Color.fromRGBO(3, 122, 104, 1),
  Color.fromRGBO(253, 75, 199, 1),
  Color.fromRGBO(2, 25, 43, 1),
  Color.fromRGBO(164, 33, 52, 1),
  Color.fromRGBO(220, 220, 220, 1),
  Color.fromRGBO(0, 160, 222, 1)
];
List<List<double>> lapTimes = [];

class BoxPlotChart extends StatefulWidget {
  @override
  State<BoxPlotChart> createState() => _BoxPlotChartState();
}

class _BoxPlotChartState extends State<BoxPlotChart> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    
    if (repeat)
    {
      print("data loaded");
      Map<String, dynamic> mapData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      numbers = mapData["results"];
      teams = mapData["teams"];
      drivers = mapData["driver3"];
      print(teams);
      double minimum = 1000;
      double maximum = 0;
      for (int i = 0; i < numbers.length; i++)
      {
        List<double> lapTimesL = [];
        for (int j = 0; j < mapData[numbers[i].toString()][0].length; j++)
        {
          lapTimesL.add(mapData[numbers[i].toString()][0][j][2].toDouble());
        }
        if (lapTimesL.length > 1)
        {
          lapTimesL.removeWhere((element) => element == -1);
          double min = lapTimesL.reduce((value, element) => value < element ? value : element);
          List<int> indexes = [];
          for (int j = 0; j < lapTimesL.length; j++)
          {
            if (lapTimesL[j] > min + 10)
            {
              indexes.add(j);
            }
          }
          for (int j = 0; j < indexes.length; j++)
          {
            lapTimesL.removeAt(indexes[indexes.length - j - 1]);
          }
        }
        
        lapTimes.add(lapTimesL);
      }

      for (int i = 0; i < lapTimes.length; i++)
      {
        for (int j = 0; j < lapTimes[i].length; j++)
        {
          if (lapTimes[i][j] > maximum - 1 && lapTimes[i][j] != -1)
          {
            maximum = lapTimes[i][j] + 1;
          }
          if (lapTimes[i][j] < minimum + 1 && lapTimes[i][j] != -1)
          {
            minimum = lapTimes[i][j] - 1;
          }
        }
      }

      minY = minimum;
      maxY = maximum;

      repeat = false;
    }
    print("data loaded");
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Plot Race Pace'),
        actions: [
          IconButton(
            icon: Icon(Icons.screenshot_monitor),
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
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "400",
                      style: TextStyle(
                        color: Colors.white
                      )
                    ),
                    Expanded(
                      child: RotatedBox(
                        
                        quarterTurns: 3, // Rotate the slider to make it vertical
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 8.0, // Adjust the track height as needed
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                          ),
                          child: RangeSlider(
                            values: _sliderValues,
                            onChanged: (newValues) {
                              setState(() {
                                _sliderValues = newValues;
                                minY = 40 + (_sliderValues.start * 90);
                                maxY = 40 + (_sliderValues.end * 90);
                              });
                            },
                            min: 0.0,
                            max: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white
                      )
                    ),
                  ],
                ),
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                        text: "Driver (3 letter)",
                      )
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: minY,
                      maximum: maxY,
                      interval: (maxY-minY)/8 - 0.001,
                      decimalPlaces: 1,
                      title: AxisTitle(
                        text: "Lap Time (seconds)"
                      )  
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_ChartData, String>>[
                      BoxAndWhiskerSeries<_ChartData, String>(
                        animationDelay: 4000,
                        animationDuration: 1500,
                        dataSource: _getChartData(),
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        boxPlotMode: BoxPlotMode.exclusive,
                        name: 'Lap Times',
                        pointColorMapper: (_ChartData data, _) => data.colour,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_ChartData> _getChartData() {
    List<_ChartData> chartData = [];
    for (int i = 0; i < drivers.length; i++)
    {
      if (lapTimes[i].length != 0)
      {
        chartData.add(_ChartData(names[drivers[i]], lapTimes[i], colours[teams[i]]));
      }
      else
      {
        print("ERROR NO 1");
      }
      
    }
    print(lapTimes);
    print(chartData);
    return chartData;
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.colour);

  final String x;
  final List<double> y;
  final Color colour;
}
