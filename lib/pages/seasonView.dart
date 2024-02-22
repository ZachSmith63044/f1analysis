import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'dart:async';

class SeasonView extends StatefulWidget {
  const SeasonView({super.key});

  @override
  State<SeasonView> createState() => _SeasonViewState();
}


DateTime? startTime;

List<LineChartBarData> listData = [];
List<List<FlSpot>> lineData = [];

Map<String, dynamic> mapData = {};
bool load = false;
bool load2 = false;
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);
List<String> viewing = [];

double minX = -1;
double maxX = -1;
double minY = 0;
double maxY = 0;

List<Color> colours = [];


class _SeasonViewState extends State<SeasonView> {

  ScreenshotController screenshotController = ScreenshotController();

  Timer? timer;
  int elapsedTime = 0; // Track elapsed time in milliseconds
  int maxDuration = 20000; // Maximum duration of 10 seconds in milliseconds

  // Function to start the timer
  void animate() {
    maxDuration = 20000;
    elapsedTime = 0;
    // Create a repeating timer that calls a function every 50 milliseconds
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      // Increment the elapsed time
      elapsedTime += 20;

      // Call your function here
      animateAction(elapsedTime);

      // Check if the elapsed time has reached the maximum duration
      if (elapsedTime >= maxDuration) {
        stopTimer();
      }
    });
  }

  // Function to stop the timer
  void stopTimer() {
    timer?.cancel();
  }

  // Function to be called by the timer
  void myFunction() {
    // Your logic here
    print("Timer fired!");
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method to avoid memory leaks
    timer?.cancel();
    super.dispose();
  }

  void animateAction(int elapsedTime)
  {
    double proportion = elapsedTime/(maxDuration + 2);
    int index = (proportion * (21)).toInt();
    print(index);
    print(elapsedTime);
    print(proportion);
    print((proportion - (index/(21))) * (21));

    double maxXB = -1;
    double maxXA = -1;
    double maxYA = 0;
    double maxYB = 0;

    for (int i = 0; i < lineData.length; i++)
    {
      if (maxXB < lineData[i][index].x)
      {
        maxXB = lineData[i][index].x;
      }
      if (maxXA < lineData[i][index + 1].x)
      {
        maxXA = lineData[i][index + 1].x;
      }
      if (maxYB < lineData[i][index].y)
      {
        maxYB = lineData[i][index].y;
      }
      if (maxYA < lineData[i][index + 1].y)
      {
        maxYA = lineData[i][index + 1].y;
      }
    }

    print(maxXB);
    print(maxXA);
    print(maxYB);
    print(maxYA);

    double proportionInner = (proportion - (index/(21))) * (21);
    setState(() {
      maxX = maxXB + (maxXA - maxXB) * proportionInner + 0;
      maxY = maxYB + (maxYA - maxYB) * proportionInner + 5;
    });
    
    print("${maxX} maxX");
    print("${maxY} maxY");
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void enterNumber(BuildContext context) async{
    String inputValue2 = '';
    pickerColor = Color(0xff443a49);
    currentColor = Color(0xff443a49);
    
    List<String> driverNames = mapData.keys.toList();
    String dropdownValue = driverNames[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Enter Text'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownMenu<String>(
                  initialSelection: driverNames.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: driverNames.map<DropdownMenuEntry<String>>((dynamic value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text("Pick Display Colour"),
                SizedBox(height: 16),
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
                SizedBox(height: 16,),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text("Cancel")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog.
                  print('Entered Text: $dropdownValue'); // Print the input value.
                  setState(() {
                    print(pickerColor);
                    viewing.add(dropdownValue);
                    colours.add(pickerColor);
                    load2 = false;
                    load = false;
                    print(colours);
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  @override
  void initState() {
    super.initState();
    // driverNumbers = [];
    // driverColours = [];
    // laps = [];
    load2 = false;
  }

  @override
  Widget build(BuildContext context) {
    if (load == false)
    {
      print("loading");
      
      if (load2 == false)
      {
        mapData =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        print(mapData);
      }
      load2 = true;

      listData = [];
      lineData = [];

      setState(() {
        for (int i = 0; i < viewing.length; i++)
        {
          List<FlSpot> lineDataIn = [FlSpot(-1, 0)];
          for (int j = 0; j < mapData[viewing[i]].length; j++)
          {
            lineDataIn.add(FlSpot(j.toDouble(), mapData[viewing[i]][j]));
          }
          lineData.add(lineDataIn);
        }
        print(lineData);
        for (int i = 0; i < lineData.length; i++)
        {
          listData.add(
            LineChartBarData(
              spots: lineData[i],
              isCurved: false,
              barWidth: 3,
              color: colours[i],
              dotData: FlDotData(show: false),
            )
          );
        }
        print(listData);
      });
      
      
      print("loaded");
      load = true;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Speed-Distance Graph'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_document),
            onPressed: () {
              print('Search button pressed');
              enterNumber(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              print('Search button pressed');
              setState(() {
                startTime = DateTime.now();
                minX = -1;
                minY = 0;
                maxX = -1;
                maxY = 0;
                animate();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: () {
              print('Search button pressed');
              setState(() {
                viewing = [];
                load = false;
              });
            },
          ),
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
        ],
      ),
      
      body: 
        SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      height: 850,
                      child: Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: false, // Set to false to hide grid lines
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            clipData: FlClipData(
                              bottom: true,
                              top: true,
                              left: true,
                              right: true,
                            ),
                            maxX: maxX,
                            minX: minX,
                            minY: minY,
                            maxY: maxY,
                            lineBarsData: listData,
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                axisNameWidget: Text(
                                  "Round",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                axisNameWidget: Text(
                                  "Points",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                sideTitles: SideTitles(
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
                            )
                          ),
                          
                          
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),

    );
    
  }
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
}