import 'dart:math';

import 'package:f1analysis/pages/seasonView.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';

class TimesView extends StatefulWidget {
  const TimesView({super.key});

  @override
  State<TimesView> createState() => _TimesViewState();
}

List<String> driverList = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
Map<String, dynamic> mapData = {};
List<List<List<List<dynamic>>>> exportData = [];
List<ScreenshotController> screenshotControllers = [];
bool load = false;

class _TimesViewState extends State<TimesView> {

  ScreenshotController screenshotController = ScreenshotController();
  //void exportToExcel(List<List<List<List<dynamic>>>> sheets2, String filePath) async {#

  int findMaxLength(int a, int b)
  {
    List<int> list = [a, b];
    return list.reduce((curr, next) => curr < next? curr: next);
  }
  
  List<List<List<dynamic>>> getData()
  {
    List<List<List<dynamic>>> data = [];
    for (int i = 0; i < findMaxLength(mapData["results"].length, mapData["driver3"].length); i++)
    {
      List<List<dynamic>> inData = [];
      String name = mapData["results"][i].toString();
      for (int j = 0; j < mapData[name][0].length; j++)
      {
        double maxSpeed = -1;
        try{maxSpeed = mapData[name][1][j].reduce((value, element) => value > element ? value : element);}
        catch(e){}
        double minSpeed = -1;
        try{minSpeed = mapData[name][1][j].reduce((value, element) => value < element ? value : element);}
        catch(e){}
        double sector1 = -1;
        try{sector1 = mapData[name][0][j][7];}
        catch(e){}
        double sector2 = -1;
        try{sector2 = mapData[name][0][j][8];}
        catch(e){}
        double sector3 = -1;
        try{sector3 = mapData[name][0][j][9];}
        catch(e){}
        inData.add([j + 1, mapData[name][0][j][2], sector1, sector2, sector3, minSpeed, maxSpeed, mapData[name][0][j][19], mapData[name][0][j][0], mapData[name][15][j][5], mapData[name][15][j][1], mapData[name][15][j][7], ["SOFTS", "MEDIUMS", "HARDS", "INTERMEDIATES", "WETS"][mapData[name][0][j][18]], driverList[mapData["driver3"][i]]]);
      }
      data.add(inData);
    }
    print(data.toString() + " data");
    return data;
  }

  double findBestLap(List<List<dynamic>> laps)
  {
    double minimum = 999;
    print(laps);
    for (int i = 0; i < laps.length; i++)
    {
      if (laps[i][1] != -1)
      {
        if (minimum > laps[i][1])
        {
          minimum = laps[i][1];
        }
      }
    }
    return minimum;
  }

  void exportToExcel(List<List<List<dynamic>>> sheets2, double multiplier) async {
    var excel = Excel.createExcel();
    print(sheets2);
    for (int i = 0; i < sheets2.length; i++)
    {
      Sheet sheetObject = excel[driverList[mapData["driver3"][i]]];
      int count = 1;
      CellStyle cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Calibri));
      CellStyle cellStyleError = CellStyle(backgroundColorHex: 'FFFF0000', fontFamily :getFontFamily(FontFamily.Calibri));
      double maxLap = findBestLap(sheets2[i]) * multiplier;
      print(maxLap.toString() + " maxLap");
      // headers
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      cell.value = TextCellValue("Lap Number");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
      cell.value = TextCellValue("Lap Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
      cell.value = TextCellValue("Sector 1 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
      cell.value = TextCellValue("Sector 2 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
      cell.value = TextCellValue("Sector 3 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
      cell.value = TextCellValue("Min Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
      cell.value = TextCellValue("Max Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0));
      cell.value = TextCellValue("Tyre Age (laps)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));
      cell.value = TextCellValue("Session Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0));
      cell.value = TextCellValue("Track Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0));
      cell.value = TextCellValue("Air Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0));
      cell.value = TextCellValue("Wind Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0));
      cell.value = TextCellValue("Tyre Compound");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0));
      cell.value = TextCellValue("Driver Abb.");
      cell.cellStyle = cellStyle;



      for (int j = 0; j < sheets2[i].length; j++)
      {
        for (int k = 0; k < sheets2[i][j].length; k++)
        {
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: k, rowIndex: count));
          if (sheets2[i][j][k] is int)
          {
            cell.value = IntCellValue(sheets2[i][j][k]);
          }
          else if (sheets2[i][j][k] is double)
          {
            cell.value = DoubleCellValue(sheets2[i][j][k]);
          }
          else if (sheets2[i][j][k] is String)
          {
            cell.value = TextCellValue(sheets2[i][j][k]);
          }
          else
          {
            cell.value = IntCellValue(-1);
          }
          if (sheets2[i][j][k] == -1)
          {
            cell.cellStyle = cellStyleError;
          }
          else
          {
            cell.cellStyle = cellStyle;
          }
          
          /*var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: count));
          cell.value = TextCellValue(["SOFTS", "MEDIUMS", "HARDS", "INTERMEDIATES", "WETS"][j]);
          cell.cellStyle = cellStyle;
          cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: count));
          cell.value = TextCellValue(driverList[mapData["driver3"][i]]);
          cell.cellStyle = cellStyle;*/
        }
        count++;
      }

      sheetObject = excel[driverList[mapData["driver3"][i]] + " filter"];
      count = 1;
      cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Calibri));

      // headers
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      cell.value = TextCellValue("Lap Number");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
      cell.value = TextCellValue("Lap Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
      cell.value = TextCellValue("Sector 1 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
      cell.value = TextCellValue("Sector 2 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
      cell.value = TextCellValue("Sector 3 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
      cell.value = TextCellValue("Min Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
      cell.value = TextCellValue("Max Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0));
      cell.value = TextCellValue("Tyre Age (laps)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));
      cell.value = TextCellValue("Session Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0));
      cell.value = TextCellValue("Track Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0));
      cell.value = TextCellValue("Air Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0));
      cell.value = TextCellValue("Wind Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0));
      cell.value = TextCellValue("Tyre Compound");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0));
      cell.value = TextCellValue("Driver Abb.");
      cell.cellStyle = cellStyle;



      for (int j = 0; j < sheets2[i].length; j++)
      {
        bool cancel = false;
        for (int k = 0; k < sheets2[i][j].length; k++)
        {
          if (count >= 1)
          {
            if (sheets2[i][j][k] != -1 && !cancel)
            {
              var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: k, rowIndex: count));
              if (sheets2[i][j][k] is int)
              {
                cell.value = IntCellValue(sheets2[i][j][k]);
              }
              else if (sheets2[i][j][k] is double)
              {
                cell.value = DoubleCellValue(sheets2[i][j][k]);
              }
              else if (sheets2[i][j][k] is String)
              {
                cell.value = TextCellValue(sheets2[i][j][k]);
              }
              else
              {
                cell.value = IntCellValue(-1);
              }
              cell.cellStyle = cellStyle;
            }
            else
            {
              if (!cancel)
              {
                count--;
              }
              cancel = true;
            }
          }
          
          
          /*var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: count));
          cell.value = TextCellValue(["SOFTS", "MEDIUMS", "HARDS", "INTERMEDIATES", "WETS"][j]);
          cell.cellStyle = cellStyle;
          cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: count));
          cell.value = TextCellValue(driverList[mapData["driver3"][i]]);
          cell.cellStyle = cellStyle;*/
        }
        count++;
      }

      sheetObject = excel[driverList[mapData["driver3"][i]] + " full filter"];
      count = 1;
      cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Calibri));

      // headers
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      cell.value = TextCellValue("Lap Number");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
      cell.value = TextCellValue("Lap Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
      cell.value = TextCellValue("Sector 1 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
      cell.value = TextCellValue("Sector 2 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
      cell.value = TextCellValue("Sector 3 (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
      cell.value = TextCellValue("Min Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
      cell.value = TextCellValue("Max Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0));
      cell.value = TextCellValue("Tyre Age (laps)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));
      cell.value = TextCellValue("Session Time (seconds)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0));
      cell.value = TextCellValue("Track Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0));
      cell.value = TextCellValue("Air Temp (celsius)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0));
      cell.value = TextCellValue("Wind Speed (km/h)");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0));
      cell.value = TextCellValue("Tyre Compound");
      cell.cellStyle = cellStyle;
      cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0));
      cell.value = TextCellValue("Driver Abb.");
      cell.cellStyle = cellStyle;



      for (int j = 0; j < sheets2[i].length; j++)
      {
        bool cancel = false;
        if (sheets2[i][j][1] < maxLap)
        {
          for (int k = 0; k < sheets2[i][j].length; k++)
          {
            if (count >= 1)
            {
              if (sheets2[i][j][k] != -1 && !cancel)
              {
                var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: k, rowIndex: count));
                if (sheets2[i][j][k] is int)
                {
                  cell.value = IntCellValue(sheets2[i][j][k]);
                }
                else if (sheets2[i][j][k] is double)
                {
                  cell.value = DoubleCellValue(sheets2[i][j][k]);
                }
                else if (sheets2[i][j][k] is String)
                {
                  cell.value = TextCellValue(sheets2[i][j][k]);
                }
                else
                {
                  cell.value = IntCellValue(-1);
                }
                cell.cellStyle = cellStyle;
              }
              else
              {
                if (cancel == false)
                {
                  count--;
                }
                cancel = true;
                print(sheets2[i][j][1].toString() + " plap");

                
              }
            }
            
            
            /*var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: count));
            cell.value = TextCellValue(["SOFTS", "MEDIUMS", "HARDS", "INTERMEDIATES", "WETS"][j]);
            cell.cellStyle = cellStyle;
            cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: count));
            cell.value = TextCellValue(driverList[mapData["driver3"][i]]);
            cell.cellStyle = cellStyle;*/
          }
          count++;
        }
      }
      
      
    }

    final directory = await getDownloadsDirectory() as Directory;
    final filePath = '${directory.path}/f1analysis.xlsx';
    final file = File(filePath);
    file.writeAsBytes(excel.encode()!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      load = true;
    }

    String formatSeconds(double seconds) {
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      double remainingSeconds = seconds % 60;
      remainingSeconds = double.parse(remainingSeconds.toStringAsFixed(3));
      String hoursStr = (hours < 10) ? '0$hours' : '$hours';
      String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
      String secondsStr = (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

      return '$hoursStr:$minutesStr:$secondsStr';
    }

    String formatSeconds2(double seconds) {
      int minutes = (seconds % 3600) ~/ 60;
      double remainingSeconds = seconds % 60;
      remainingSeconds = double.parse(remainingSeconds.toStringAsFixed(3));
      String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
      String secondsStr = (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

      return '$minutesStr:$secondsStr';
    }

    
    Container GetDriverData(String name, String displayName)
    {
      List<List<dynamic>> softs = [];
      List<List<dynamic>> mediums = [];
      List<List<dynamic>> hards = [];
      List<List<dynamic>> intermediates = [];
      List<List<dynamic>> wets = [];
      int cancelled = 0;
      print(name);
      try
      {
        for (int i = 0; i < mapData[name][0].length; i++)
        {
          if (mapData[name][0][i][2] != -1)
          {
            if (mapData[name][0][i][18] == 0)
            {
              softs.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0], mapData[name][15][i][5], mapData[name][15][i][1], mapData[name][15][i][7]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 1)
            {
              mediums.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0], mapData[name][15][i][5], mapData[name][15][i][1], mapData[name][15][i][7]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 2)
            {
              hards.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0], mapData[name][15][i][5], mapData[name][15][i][1], mapData[name][15][i][7]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 3)
            {
              intermediates.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0], mapData[name][15][i][5], mapData[name][15][i][1], mapData[name][15][i][7]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 4)
            {
              wets.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0], mapData[name][15][i][5], mapData[name][15][i][1], mapData[name][15][i][7]]); // weather is 15
            }
            print(i);
            print(mapData[name][0][i][2]);
            print(["SOFT", "MEDIUM", "HARD", "INTERMEDIATE", "WET"][mapData[name][0][i][18]]);
            print(mapData[name][15][i][5]);
          }
          else
          {
            
          }
        }
        List<List<List<dynamic>>> timesData = [softs, mediums, hards, intermediates, wets];

        exportData.add(timesData);

        List<String> names = ["Softs", "Mediums", "Hards", "Intermediates", "Wets"];
        List<Widget> widgets = [];
        widgets.add(Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
        List<Widget> widgetList = [];


        for (int i = 0; i < timesData.length; i++)
        {
          if (timesData[i].length != 0)
          {
            List<TableRow> tableWidgets = [
              TableRow(
                children: [
                  TableCell(
                    child: Center(child: Text('Lap Number')),
                  ),
                  TableCell(
                    child: Center(child: Text('Lap Time')),
                  ),
                  TableCell(
                    child: Center(child: Text('Tyre Age')),
                  ),
                  TableCell(
                    child: Center(child: Text('Session Time')),
                  ),
                  TableCell(
                    child: Center(child: Text('Track Temp.')),
                  ),
                  TableCell(
                    child: Center(child: Text('Air Temp.')),
                  ),
                  TableCell(
                    child: Center(child: Text('Wind Speed')),
                  ),
                ]
              )
            ];
            widgets.add(Text(
              names[i],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ));
            for (int j = 0; j < timesData[i].length; j++)
            {
              tableWidgets.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text((timesData[i][j][0] + 1).toString())),
                    ),
                    TableCell(
                      child: Center(child: Text(formatSeconds2(timesData[i][j][1]))),
                    ),
                    TableCell(
                      child: Center(child: Text(timesData[i][j][2].toString())),
                    ),
                    TableCell(
                      child: Center(child: Text(formatSeconds(timesData[i][j][3]))),
                    ),
                    TableCell(
                      child: Center(child: Text(timesData[i][j][4].toString())),
                    ),
                    TableCell(
                      child: Center(child: Text(timesData[i][j][5].toString())),
                    ),
                    TableCell(
                      child: Center(child: Text(timesData[i][j][6].toString())),
                    ),
                  ]
                )
              );
            }
            widgets.add(
              Table(
                border: TableBorder.all(),
                children: tableWidgets,
              )
            );
          }
          
        }
        screenshotControllers.add(ScreenshotController());
        return Container(
          child: Screenshot(
            controller: screenshotControllers[screenshotControllers.length - 1],

            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: widgets
                )
              )
            ),
          )
          
        );
      }
      catch (e)
      {
        print("Caught " + name.toString());
        return Container();
      }
    }
    List<Widget> containers = [];
    List<dynamic> drivers = mapData["results"];
    print(drivers);
    exportData = [];
    for (int i = 0; i < findMaxLength(drivers.length, mapData["driver3"].length); i++)
    {
      containers.add(
        GetDriverData(drivers[i].toString(), driverList[mapData["driver3"][i]].toString())
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Speed-Distance Graph'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_document),
            onPressed: ()  async{
              final directory = await getDownloadsDirectory() as Directory;
              final filePath = '${directory.path}/f1analysis.xlsx';
              exportToExcel(getData(), 1.07);
            },
          ),
          IconButton(
            icon: Icon(Icons.swap_vert_circle),
            onPressed: ()  async{
              Navigator.pushNamed(
                context,
                '/advancedtimesview', // Specify the route name
                arguments: mapData
              );
            },
          ),
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
          IconButton(
            icon: Icon(Icons.screenshot_monitor),
            onPressed: () async{
              final directory = await getDownloadsDirectory() as Directory;
              String folderPath = directory.path + "\\f1analysisscreenshots";

              Directory newFolder = Directory(folderPath);

              if (!newFolder.existsSync()) {
                // If the folder doesn't exist, create it
                newFolder.createSync(recursive: true);
                print('Folder created at: $folderPath');
              } else {
                // If the folder already exists, print a message
                print('Folder already exists at: $folderPath');
              }
              for (int i = 0; i < screenshotControllers.length; i++)
              {
                screenshotControllers[i]
                  .capture(delay: Duration(milliseconds: 10))
                  .then((capturedImage) async {
                  try {
                    // Get the path to the device's Downloads directory
                    
                    final filePath = '${newFolder.path}/${driverList[mapData["driver3"][i]]}.png';

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
              }
            },
          ),
        ],
      ),
      
      body: 
        SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: containers,
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