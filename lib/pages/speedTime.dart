import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class SpeedTime extends StatefulWidget {
  const SpeedTime({super.key});

  @override
  State<SpeedTime> createState() => _SpeedTimeState();
}

List<String> driverList = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
List<List<FlSpot>> lineData2 = [];
List<List<dynamic>> relativeDistance = [];
List<List<double>> time = [];
Map<String, dynamic> mapData = {};
bool fastestLap = false;
bool load = false;
bool load2 = false;
List<String> driverNumbers = [];
List<String> driverNames = [];
List<Color> driverColours = [];
List<int> laps = [];
List<List> xData = [];
List<List> yData = [];
List<List<FlSpot>> lineData = [];
List<LineChartBarData> listB = [];
List<LineChartBarData> listC = [];
List<LineChartBarData> listD = [];
List<LineChartBarData> listE = [];
List<LineChartBarData> listF = [];
List<double> sector1Times = [];
List<double> sector2Times = [];
List<double> sector3Times = [];
List<double> lapTimes = [];
List<List<dynamic>> throttle = [];
List<List<dynamic>> brake = [];
List<List<dynamic>> gear = [];
List<bool> renderedLabel = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
double minY = 0;
double maxY = 400;
double minY2 = -5;
double maxY2 = 5;
double minX = 0;
double maxX = 1;
double minY3 = 0;
double maxY3 = 100;
double minY4 = 0;
double maxY4 = 1;
double minY5 = 1;
double maxY5 = 8;
RangeValues _sliderValues = RangeValues(0, 1);
RangeValues _sliderValues2 = RangeValues(0, 1);
RangeValues _sliderValues3 = RangeValues(0, 1);
RangeValues _sliderValues4 = RangeValues(0, 1);
RangeValues _sliderValues5 = RangeValues(0, 1);
RangeValues _sliderValues6 = RangeValues(0, 1);
//7,8,9
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);
class _SpeedTimeState extends State<SpeedTime> {

  ScreenshotController screenshotController = ScreenshotController();

  List findPosition(double search, List<dynamic> compare)
  {
    double closest = 1;
    int number = 0;
    for (int i = 0; i < compare.length; i++)
    {
      if (search - compare[i] < closest && search - compare[i] >= 0)
      {
        closest = search - compare[i];
        number = i;
      }
    }
    if (number != compare.length - 1)
    {
      closest = closest / (compare[number + 1] - compare[number]);
    }
    return [number, closest];
  }

  int closestIndex(List<dynamic> vec, double target) {
    double minDistance = (vec[0] - target).abs();
    int minIndex = 0;

    for (int i = 1; i < vec.length; i++) {
      double distance = (vec[i] - target).abs();
      if (distance < minDistance) {
        minDistance = distance;
        minIndex = i;
      }
    }

    return minIndex;
  }

  

  List<List<List<dynamic>>> findDelta(List<List<dynamic>> relativeDistance, List<List<double>> time, int delta)
  {
    print(time);
    List<List<dynamic>> xData = [];
    for (int i = 0; i < relativeDistance.length; i++)
    {
      List<double> adding = [];
      for (int j = 0; j < relativeDistance[i].length; j++)
      {
        adding.add(relativeDistance[i][j]);
      }
      xData.add(adding);
    }
    List<List<double>> yData = [];
    for (int i = 0; i < time.length; i++)
    {
      List<double> adding = [];
      for (int j = 0; j < time[i].length; j++)
      {
        adding.add(time[i][j]);
      }
      yData.add(adding);
    }
    print("$yData yData");
    
    for (int i = 0; i < relativeDistance.length; i++)
    {
      for (int j = 0; j < relativeDistance[i].length; j++)
      {
        int test = closestIndex(relativeDistance[delta], relativeDistance[i][j]);
        double testF = relativeDistance[delta][test] - relativeDistance[i][j];
        double diff;
        double yDiff;
        if (testF < 0)
        {
          diff = relativeDistance[i][j + 1] - relativeDistance[i][j];
          yDiff = time[i][j+1] - time[i][j];
        }
        else
        {
          if (j == 0)
          {
            diff = relativeDistance[i][j] - relativeDistance[i][j];
          }
          else
          {
            diff = relativeDistance[i][j - 1] - relativeDistance[i][j];
          }
          if (j == 0)
          {
            yDiff = time[i][j] - time[i][j];
          }
          else
          {
            yDiff = time[i][j-1] - time[i][j];
          }
          
        }
        double diffPerecent = (-testF)/diff;
        double yDiffF = yDiff * diffPerecent;
        yData[i][j] -= time[0][test] + yDiffF;
      }
    }

    for (int i = 0; i < yData.length; i++)
    {
      for (int j = 0; j < yData[i].length; j++)
      {
        if (yData[i][j].isNaN)
        {
          yData[i][j] = 0;
        }
      }
    }
    print("$yData");
    return [xData, yData
    ];
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void enterNumber(BuildContext context) async{
    String inputValue2 = '';
    pickerColor = Color(0xff443a49);
    currentColor = Color(0xff443a49);
    List driverNumbersAvailable = await mapData["driver3"];
    List newDriversNumbersAvailable = [];
    for (int i = 0; i < driverNumbersAvailable.length; i++)
    {
      print(i);
      print(driverNumbersAvailable[i]);
      print(driverList[driverNumbersAvailable[i]]);
      newDriversNumbersAvailable.add(driverList[driverNumbersAvailable[i]]);
    }
    List driverNumbers_ = mapData["results"];
    newDriversNumbersAvailable.removeLast();
    String dropdownValue = newDriversNumbersAvailable[0];
    print(newDriversNumbersAvailable);
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
                  initialSelection: newDriversNumbersAvailable.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: newDriversNumbersAvailable.map<DropdownMenuEntry<String>>((dynamic value) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Fastest Lap"),
                    CheckboxExample(),
                  ],
                ),
                SizedBox(height: 16,),
                TextFormField(
                  onChanged: (value) {
                    inputValue2 = value; // Update the input value when the user types.
                  },
                  decoration: InputDecoration(labelText: 'Enter Lap Number'),
                ),
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
                    driverNumbers.add(driverNumbers_[newDriversNumbersAvailable.indexOf(dropdownValue)].toString());
                    driverNames.add(dropdownValue);
                    load = false;
                    if (fastestLap)
                    {
                      double fastest = 10000;
                      int choose = 1;
                      for (int i = 0; i < mapData[driverNumbers_[newDriversNumbersAvailable.indexOf(dropdownValue)].toString()][0].length; i++)
                      {
                        if (mapData[driverNumbers_[newDriversNumbersAvailable.indexOf(dropdownValue)].toString()][0][i][2] < fastest && mapData[driverNumbers_[newDriversNumbersAvailable.indexOf(dropdownValue)].toString()][0][i][2] != -1)
                        {
                          fastest = mapData[driverNumbers_[newDriversNumbersAvailable.indexOf(dropdownValue)].toString()][0][i][2];
                          choose = i;
                        }
                      }
                      laps.add(choose);
                    }
                    else
                    {
                      laps.add(int.parse(inputValue2));
                    }
                    driverColours.add(pickerColor);
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
    double roundToNearest0_01(double number) {
      return (number * 100).round() / 100;
    }

    double roundToNearest0_001(double number) {
      return (number * 1000).round() / 1000;
    }
    if (load == false)
    {
      print("loading");
      
      if (load2 == false)
      {
        mapData =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      }
      load2 = true;

      setState(() {
        listB = [];
        lineData = [];
        sector1Times = [];
        sector2Times = [];
        sector3Times = [];
        lapTimes = [];
        List<List<dynamic>> relativeDistance_ = [];
        throttle = [];
        brake = [];
        gear = [];
        for (int i = 0; i < driverNumbers.length; i++)
        {
          sector1Times.add(mapData[driverNumbers[i]][0][laps[i]][7].toDouble());
          sector2Times.add(mapData[driverNumbers[i]][0][laps[i]][8].toDouble());
          sector3Times.add(mapData[driverNumbers[i]][0][laps[i]][9].toDouble());
          lapTimes.add(mapData[driverNumbers[i]][0][laps[i]][2].toDouble());
          List<FlSpot> arr = [];
          for (int j = 0; j < mapData![driverNumbers[i]][10][laps[i]].length; j++)
          {
            arr.add(FlSpot(mapData![driverNumbers[i]][10][laps[i]][j], mapData![driverNumbers[i]][1][laps[i]][j]));
          }
          lineData.add(arr);
          relativeDistance_.add(mapData![driverNumbers[i]][10][laps[i]]);
          throttle.add(mapData![driverNumbers[i]][4][laps[i]]);
          brake.add(mapData![driverNumbers[i]][5][laps[i]]);
          gear.add(mapData![driverNumbers[i]][3][laps[i]]);
                    // List throttle = mapData![driverNumbers[i]][4][laps[i]];
          // List brake = mapData![driverNumbers[i]][5][laps[i]];
          // print(throttle);
          // print(brake);
          // List<int> stage = [];
          // for (int j = 0; j < throttle.length; j++)
          // {
          //   if (throttle[j] > 0)
          //   {
          //     stage.add(0);
          //   }
          //   else if (brake[j] != 0)
          //   {
          //     stage.add(1);
          //   }
          //   else
          //   {
          //     stage.add(2);
          //   }
          // }
          //stages.add(stage);
        }
        for (int i = 0; i < lineData.length; i++)
        {
          listB.add(
            LineChartBarData(
              spots: lineData[i],
              isCurved: true,
              barWidth: 3,
              color: driverColours[i],
              dotData: FlDotData(show: false),
            )
          );
        }

        lineData = [];
        listD = [];
        for (int i = 0; i < relativeDistance_.length; i++)
        {
          List<FlSpot> array = [];
          
          for (int j = 0; j < relativeDistance_[i].length; j++)
          {
            array.add(FlSpot(relativeDistance_[i][j], throttle[i][j]));
          }
          lineData.add(array);
        }
        for (int i = 0; i < lineData.length; i++)
        {
          listD.add(
            LineChartBarData(
              spots: lineData[i],
              isCurved: false,
              barWidth: 2,
              color: driverColours[i],
              dotData: FlDotData(show: false),
            )
          );
        }

        lineData = [];
        listE = [];
        for (int i = 0; i < relativeDistance_.length; i++)
        {
          List<FlSpot> array = [];
          
          for (int j = 0; j < relativeDistance_[i].length; j++)
          {
            array.add(FlSpot(relativeDistance_[i][j], brake[i][j]));
          }
          lineData.add(array);
        }
        for (int i = 0; i < lineData.length; i++)
        {
          listE.add(
            LineChartBarData(
              spots: lineData[i],
              isCurved: false,
              barWidth: 2,
              color: driverColours[i],
              dotData: FlDotData(show: false),
            )
          );
        }

        lineData = [];
        listF = [];
        for (int i = 0; i < relativeDistance_.length; i++)
        {
          List<FlSpot> array = [];
          
          for (int j = 0; j < relativeDistance_[i].length; j++)
          {
            array.add(FlSpot(relativeDistance_[i][j], gear[i][j]));
          }
          lineData.add(array);
        }
        for (int i = 0; i < lineData.length; i++)
        {
          listF.add(
            LineChartBarData(
              spots: lineData[i],
              isCurved: false,
              barWidth: 2,
              color: driverColours[i],
              dotData: FlDotData(show: false),
            )
          );
        }

        if (laps.length != 0)
        {
          
          
          for (int j = laps.length - 1; j < laps.length; j++)
          {
            relativeDistance.add(mapData![driverNumbers[j]][10][laps[j]]);
            print(laps[j]);
            print(mapData[driverNumbers[j]][7][laps[j]]);
            List<double> adding = [];
            for (int i = 0; i < mapData[driverNumbers[j]][7][laps[j]].length; i++)
            {
              adding.add(mapData[driverNumbers[j]][7][laps[j]][i]);
            }
            time.add(adding);
          }

          print(relativeDistance);
          print(time);
          List<List<double>> convert = [];

          for (int i = 0; i < time.length; i++)
          {
            List<double> adding = [];
            for (int j = 0; j < time[i].length; j++)
            {
              adding.add(time[i][j]);
            }
            convert.add(adding);
          }
          print("${convert} convert");
          List<List<List<dynamic>>> variable = findDelta(relativeDistance, convert, 0);
          lineData2 = [];
          for (int i = 0; i < variable[0].length; i++)
          {
            List<FlSpot> array = [];
            for (int j = 0; j < variable[0][i].length; j++)
            {
              array.add(FlSpot(roundToNearest0_001(variable[0][i][j]), roundToNearest0_001(variable[1][i][j])));
            }
            lineData2.add(array);
          }
          print("${time} 2");
          print(lineData2);
          listC = [];
          for (int i = 0; i < lineData2.length; i++)
          {
            listC.add(
              LineChartBarData(
                spots: lineData2[i],
                isCurved: true,
                barWidth: 3,
                color: driverColours[i],
                dotData: FlDotData(show: false),
              )
            );
            
          }

          
        }
        
        


      });
      
      
      renderedLabel = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
      print("loaded");
      load = true;
    }
    renderedLabel = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


    int checkIfClose(double axisText)
    {
      List<double> textList = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1];
      int run = -1;
      for (int i = 0; i < textList.length; i++)
      {
        //print("${axisText < textList[i] + 0.001} + ${axisText > textList[i] - 0.001} + ${renderedLabel[i] == false}");
        if (axisText < textList[i] + 0.001 && axisText > textList[i] - 0.001 && renderedLabel[i] == false)
        {
          renderedLabel[i] = true;
          run = i;
        }
      }

      return run;
    }

    

    

    Widget axisText(double axisText)
    {
      String text = "${roundToNearest0_01(axisText)}";
      return Text(
        text,
        overflow: TextOverflow.clip, // You can also use TextOverflow.clip
        maxLines: 1,
        style: TextStyle(
          color: Colors.grey
        ),
      );
    }
    Widget axisText3(double axisText)
    {
      print(axisText);
      print(roundToNearest0_001(0.021983));
      String text = "${roundToNearest0_001(axisText)}";
      text = axisText.toString();
      print(text);
      return Expanded(
        child: Text(
          text,
          overflow: TextOverflow.clip, // You can also use TextOverflow.clip
          maxLines: 1,
          style: TextStyle(
            color: Colors.grey
          ),
        ),
      );
    }
    Widget axisText2(double axisText)
    {
      String text = "${axisText.toInt()}";
      return Text(
        text,
        overflow: TextOverflow.clip, // You can also use TextOverflow.clip
        maxLines: 1,
        style: TextStyle(
          color: Colors.grey
        ),
      );
    }

    print("$laps laps--");
    print("$driverNumbers laps--");
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
            icon: Icon(Icons.restart_alt),
            onPressed: () {
              print('Search button pressed');
              setState(() {
                driverNumbers = [];
                driverColours = [];
                laps = [];
                xData = [];
                yData = [];
                lineData = [];
                listB = [];
                listC = [];
                sector1Times = [];
                sector2Times = [];
                sector3Times = [];
                lineData2 = [];
                relativeDistance = [];
                time = [];
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
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DataTable(
                      
                      columns: [
                        DataColumn(label: 
                        Text('Driver',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                        DataColumn(label: 
                        Text('Colour',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                        DataColumn(label: 
                        Text('Sector 1',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                        DataColumn(label: 
                        Text('Sector 2',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                        DataColumn(label: 
                        Text('Sector 3',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                        DataColumn(label: 
                        Text('Lap Time',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ))),
                      ],
                      rows: [
                        for (int index = 0; index < driverNumbers.length; index++)
                          DataRow(cells: [
                            DataCell(
                              Text(
                                driverNames[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 20,
                                height: 20,
                                color: driverColours[index],
                              ),
                            ),
                            DataCell(
                              Text(
                                sector1Times[index].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector2Times[index].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector3Times[index].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                lapTimes[index].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "0%",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                        Expanded(
                          child: RotatedBox(
                            
                            quarterTurns: 0, // Rotate the slider to make it vertical
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 8.0, // Adjust the track height as needed
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                              ),
                              child: RangeSlider(
                                values: _sliderValues2,
                                onChanged: (newValues) {
                                  setState(() {
                                    _sliderValues2 = newValues;
                                    minX = (_sliderValues2.start);
                                    maxX = (_sliderValues2.end);
                                  });
                                },
                                min: 0.0,
                                max: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "100%",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                      ],
                    ),
                    Container(
                      height: 600, // Set the desired height here
                      child: Row(
                        children: [
                          Container(
                            height: 600.0, // Set the desired height here
                            child: Column(
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
                                            minY = (_sliderValues.start * 400);
                                            maxY = (_sliderValues.end * 400);
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
                          ),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
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
                                lineBarsData: listB,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Relative Distance",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText(value),
                                      showTitles: true,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Speed (km/h)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText2(value),
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
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 12),
                    // Add other widgets here
                    
                    Container(
                      height: 300, // Set the desired height here
                      child: Row(
                        children: [
                          Container(
                            height: 300.0, // Set the desired height here
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "5",
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
                                        values: _sliderValues3,
                                        onChanged: (newValues) {
                                          setState(() {
                                            _sliderValues3 = newValues;
                                            minY2 = ((_sliderValues3.start - 0.5) * 10);
                                            maxY2 = ((_sliderValues3.end - 0.5) * 10);
                                          });
                                        },
                                        min: 0.0,
                                        max: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "-5",
                                  style: TextStyle(
                                    color: Colors.white
                                  )
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
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
                                minY: minY2,
                                maxY: maxY2,
                                lineBarsData: listC,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText(value),
                                      showTitles: false
                                    )
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Time delta (s)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText3(value),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 130, // Set the desired height here
                      child: Row(
                        children: [
                          Container(
                            height: 130.0, // Set the desired height here
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "100",
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
                                        values: _sliderValues4,
                                        onChanged: (newValues) {
                                          setState(() {
                                            _sliderValues4 = newValues;
                                            minY3 = ((_sliderValues4.start) * 100) - 1;
                                            maxY3 = ((_sliderValues4.end) * 100) + 1;
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
                          ),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
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
                                minY: minY3,
                                maxY: maxY3,
                                lineBarsData: listD,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText(value),
                                      showTitles: false
                                    )
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Throttle (0-100%)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText3(value),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 130, // Set the desired height here
                      child: Row(
                        children: [
                          Container(
                            height: 130.0, // Set the desired height here
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 84, 75, 75)
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
                                        values: _sliderValues5,
                                        onChanged: (newValues) {
                                          setState(() {
                                            _sliderValues5 = newValues;
                                            minY4 = _sliderValues5.start - 0.01;
                                            maxY4 = _sliderValues5.end + 0.01;
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
                          ),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
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
                                minY: minY4,
                                maxY: maxY4,
                                lineBarsData: listE,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText(value),
                                      showTitles: false
                                    )
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Brake (0/off or 1/on)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText3(value),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 130, // Set the desired height here
                      child: Row(
                        children: [
                          Container(
                            height: 130.0, // Set the desired height here
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "8",
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
                                        values: _sliderValues6,
                                        onChanged: (newValues) {
                                          setState(() {
                                            _sliderValues6 = newValues;
                                            minY5 = ((_sliderValues6.start) * 7.1 + 1);
                                            maxY5 = ((_sliderValues6.end) * 7.1 + 1);
                                          });
                                        },
                                        min: 0.0,
                                        max: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white
                                  )
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
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
                                minY: minY5,
                                maxY: maxY5,
                                lineBarsData: listF,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText(value),
                                      showTitles: false
                                    )
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Gear (1-8)",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      getTitlesWidget: (value, meta) => axisText3(value),
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
                        ],
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

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: fastestLap,
      onChanged: (bool? value) {
        setState(() {
          fastestLap = value!;
        });
      },
    );
  }
}
