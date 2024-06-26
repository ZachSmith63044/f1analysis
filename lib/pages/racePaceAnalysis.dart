import 'package:flutter/material.dart';

class RacePaceChoices extends StatefulWidget {
  const RacePaceChoices({super.key});

  @override
  State<RacePaceChoices> createState() => _RacePaceChoicesState();
}

List<String> tyres = ["SOFTS", "MEDIUMS", "HARDS", "INTERMEDIATES", "WETS", "ALL"];
List<String> xAxis = ["Session Time (line)", "Lap Number (line)", "Session Time (scatter)", "Lap Number (scatter)", "Tyre Age (scatter)", "Track Temp. (scatter)", "Min Speed (scatter)", "Max Speed (scatter)", "Wind Speed (scatter)", "Air Temp. (scatter)", "Full Throttle (scatter)"];
List<String> driverList = ["ALB", "ALO", "BOT", "DEV", "GAS", "GIO", "HAM", "HUL", "KUB", "LAT", "LAW", "LEC", "MAG", "MAZ", "NOR", "OCO", "PER", "PIA", "RIC", "RUS", "SAI", "SAR", "SCH", "STR", "TSU", "VER", "ZHO", "GIO", "RAI", "VET", "MAZ"];
Map<String, dynamic> mapData = {};
List<List<List<List<dynamic>>>> exportData = [];
bool load = false;

class _RacePaceChoicesState extends State<RacePaceChoices> {
  List<List<bool>> chosenLaps = [];
  List<List<double>> chosenLapTimes = [];

  double findBestLap(List<dynamic> laps)
  {
    double minimum = 999;
    print(laps);
    for (int i = 0; i < laps.length; i++)
    {
      if (laps[i][2] != -1)
      {
        if (minimum > laps[i][2])
        {
          minimum = laps[i][2];
        }
      }
    }
    return minimum;
  }

  List<int> getLaps(bool containing, int index, int tyreIndex)
  {
    List<int> laps = [];
    if (containing)
    {
      for (int i = 0; i < mapData[mapData["results"][index].toString()][0].length; i++)
      {
        if (mapData[mapData["results"][index].toString()][0][i][2] != -1 && mapData[mapData["results"][index].toString()][0][i][18] == tyreIndex)
        {
          laps.add(i);
        }
      }
      return laps;
    }
    else
    {
      List<dynamic> _laps = mapData[mapData["results"][index].toString()][0];
      double maxLap = findBestLap(_laps) * 1.1;
      for (int i = 0; i < mapData[mapData["results"][index].toString()][0].length; i++)
      {
        if (mapData[mapData["results"][index].toString()][0][i][2] < maxLap && mapData[mapData["results"][index].toString()][0][i][2] != -1 && mapData[mapData["results"][index].toString()][0][i][18] == tyreIndex)
        {
          laps.add(i);
        }
      }
      return laps;
    }
  }

  List<List<int>> getAllLaps(bool containing, int index)
  {
    List<List<int>> laps = [[], [], [], [], []];
    
    if (containing)
    {
      for (int i = 0; i < mapData[mapData["results"][index].toString()][0].length; i++)
      {
        if (mapData[mapData["results"][index].toString()][0][i][2] != -1)
        {
          laps[mapData[mapData["results"][index].toString()][0][i][18]].add(i);
        }
      }
      return laps;
    }
    else
    {
      List<dynamic> _laps = mapData[mapData["results"][index].toString()][0];
      double maxLap = findBestLap(_laps) * 1.1;
      for (int i = 0; i < mapData[mapData["results"][index].toString()][0].length; i++)
      {
        if (mapData[mapData["results"][index].toString()][0][i][2] < maxLap && mapData[mapData["results"][index].toString()][0][i][2] != -1)
        {
          laps[mapData[mapData["results"][index].toString()][0][i][18]].add(i);
        }
      }
      return laps;
    }
  }

  void FindRace(BuildContext context) async {
    String xAxisValue = xAxis.first;
    String tyreValue = tyres.first;
    bool includeAll = false;
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
                  checkbox(
                    title: "Include All Valid Laps",
                    initValue: includeAll,
                    onChanged: (sts) => setState(() => includeAll = sts)
                  ),
                  SizedBox(height: 4,),
                  Text("X-Axis Value"),
                  SizedBox(height: 4,),
                  DropdownMenu<String>(
                    initialSelection: xAxis.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        xAxisValue = value!;
                      });
                    },
                    dropdownMenuEntries: xAxis.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  ),
                  SizedBox(height: 4,),
                  Text("Tyre"),
                  SizedBox(height: 4,),
                  DropdownMenu<String>(
                    initialSelection: tyres.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        tyreValue = value!;
                      });
                    },
                    dropdownMenuEntries: tyres.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  )
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
                if (tyres.indexOf(tyreValue) == 5)
                {
                  List<List<double>> xAxisData = [];
                  List<List<double>> yAxisData = [];

                  List<List<int>> laps = getAllLaps(includeAll, currentIndex);
                  int ind = xAxis.indexOf(xAxisValue);
                  int count = 0;
                  for (int i = 0; i < laps.length; i++)
                  {
                    xAxisData.add([]);
                    yAxisData.add([]);
                    for (int j = 0; j < laps[i].length; j++)
                    {
                      if (ind == 0 || ind == 2)
                      {
                        xAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][0][laps[i][j]][0]);
                      }
                      else if (ind == 1 || ind == 3)
                      {
                        xAxisData[i].add(count.toDouble());
                      }
                      else if (ind == 4)
                      {
                        xAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][0][laps[i][j]][19]);
                      }
                      else if (ind == 5)
                      {
                        xAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][15][laps[i][j]][5]);
                      }
                      else if (ind == 6)
                      {
                        double minSpeed = -1;
                        try{minSpeed = mapData[mapData["results"][currentIndex].toString()][1][laps[i][j]].reduce((value, element) => value < element ? value : element);}
                        catch(e){}

                        xAxisData[i].add(minSpeed);
                      }
                      else if (ind == 7)
                      {
                        double maxSpeed= -1;
                        try{maxSpeed = mapData[mapData["results"][currentIndex].toString()][1][laps[i][j]].reduce((value, element) => value > element ? value : element);}
                        catch(e){}

                        xAxisData[i].add(maxSpeed);
                      }
                      else if (ind == 8)
                      {
                        xAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][15][laps[i][j]][7]);
                      }
                      else if (ind == 9)
                      {
                        xAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][15][laps[i][j]][1]);
                      }
                      else if (ind == 10)
                      {
                        double res = (mapData[mapData["results"][currentIndex].toString()][4][laps[i][j]].map((element) => element > 95 ? 1 : 0).reduce((value, element) => value + element))/mapData[mapData["results"][currentIndex].toString()][4][laps[i][j]].length * 100;
                        xAxisData[i].add(res);
                      }
                      yAxisData[i].add(mapData[mapData["results"][currentIndex].toString()][0][laps[i][j]][2]);
                      count++;
                    }
                  }
                  print(laps);
                  print(xAxisData);
                  print(yAxisData);

                  if (ind == 0 || ind == 1)
                  {
                    Navigator.pushNamed(
                      context,
                      "/linegraph", // Specify the route name
                      arguments: {
                        "xAxis": xAxisData,
                        "yAxis": yAxisData,
                        "title": "Title",
                        "colour": [Color.fromARGB(255, 200, 0, 0), Color.fromARGB(255, 255, 238, 0), Color.fromARGB(255, 208, 208, 208), Color.fromARGB(255, 0, 175, 12), Color.fromARGB(255, 0, 20, 200)],
                        "xAxisTitle": ["Session Time (seconds)", "Lap Number"][xAxis.indexOf(xAxisValue)],
                        "yAxisTitle": "Lap Time (seconds)",
                        "toMins": true
                      }
                    );
                  }
                  else
                  {
                    Navigator.pushNamed(
                      context,
                      "/scattergraph", // Specify the route name
                      arguments: {
                        "xAxis": xAxisData,
                        "yAxis": yAxisData,
                        "title": "Title",
                        "colour": [Color.fromARGB(255, 200, 0, 0), Color.fromARGB(255, 255, 238, 0), Color.fromARGB(255, 208, 208, 208), Color.fromARGB(255, 0, 175, 12), Color.fromARGB(255, 0, 20, 200)],
                        "xAxisTitle": ["Session Time (seconds)", "Lap Number", "Session Time (seconds)", "Lap Number", "Tyre Age", "Track Temp. (C)", "Min Speed (km/h)", "Max Speed (km/h)", "Wind Speed (km/h)", "Air Temp. (C)", "Full Throttle (%)"][xAxis.indexOf(xAxisValue)],
                        //["Session Time (line)", "Lap Number (line)", "Session Time (scatter)", "Lap Number (scatter)", "Tyre Age (scatter)", "Track Temp. (scatter)", "Min Speed (scatter)", "Max Speed (scatter)", "Wind Speed (scatter)", "Air Temp. (scatter)"]
                        "yAxisTitle": "Lap Time (seconds)",
                        "toMins": true,
                        "title": "Driver Number: " + mapData["results"][currentIndex].toString()
                      }
                    );
                  }
                }
                else
                {
                  print(includeAll);
                  print(tyreValue);
                  int ind = tyres.indexOf(tyreValue);
                  List<int> list = getLaps(includeAll, currentIndex, ind);
                  print(list.toString() + "list");
                  List<double> xAxisData = [];
                  List<double> yAxisData = [];
                  ind = xAxis.indexOf(xAxisValue);
                  for (int i = 0; i < list.length; i++)
                  {
                    if (ind == 0 || ind == 2)
                    {
                      xAxisData.add(mapData[mapData["results"][currentIndex].toString()][0][list[i]][0]);
                    }
                    else if (ind == 1 || ind == 3)
                    {
                      xAxisData.add(i.toDouble());
                    }
                    else if (ind == 4)
                    {
                      xAxisData.add(mapData[mapData["results"][currentIndex].toString()][0][list[i]][19]);
                    }
                    else if (ind == 5)
                    {
                      xAxisData.add(mapData[mapData["results"][currentIndex].toString()][15][list[i]][5]);
                    }
                    else if (ind == 6)
                    {
                      double minSpeed = -1;
                      try{minSpeed = mapData[mapData["results"][currentIndex].toString()][1][list[i]].reduce((value, element) => value < element ? value : element);}
                      catch(e){}
                      xAxisData.add(minSpeed);
                    }
                    else if (ind == 7)
                    {
                      double maxSpeed = -1;
                      try{maxSpeed = mapData[mapData["results"][currentIndex].toString()][1][list[i]].reduce((value, element) => value > element ? value : element);}
                      catch(e){}
                      xAxisData.add(maxSpeed);
                    }
                    else if (ind == 8)
                    {
                      xAxisData.add(mapData[mapData["results"][currentIndex].toString()][15][list[i]][7]);
                    }
                    else if (ind == 9)
                    {
                      xAxisData.add(mapData[mapData["results"][currentIndex].toString()][15][list[i]][1]);
                    }
                    else if (ind == 10)
                    {
                      double res = (mapData[mapData["results"][currentIndex].toString()][4][list[i]].map((element) => element == 100 ? 1 : 0).reduce((value, element) => value + element))/mapData[mapData["results"][currentIndex].toString()][4][list[i]].length * 100;
                      xAxisData.add(res.toDouble());
                    }
                    
                    yAxisData.add(mapData[mapData["results"][currentIndex].toString()][0][list[i]][2]);
                  }
                  print(yAxisData);
                  print(xAxisData);
                  if (ind == 0 || ind == 1)
                  {
                    Navigator.pushNamed(
                      context,
                      "/linegraph", // Specify the route name
                      arguments: {
                        "xAxis": [xAxisData],
                        "yAxis": [yAxisData],
                        "title": "Title",
                        "colour": [[Color.fromARGB(255, 200, 0, 0), Color.fromARGB(255, 255, 238, 0), Color.fromARGB(255, 208, 208, 208), Color.fromARGB(255, 0, 175, 12), Color.fromARGB(255, 0, 20, 200)][tyres.indexOf(tyreValue)]],
                        "xAxisTitle": ["Session Time (seconds)", "Lap Number"][xAxis.indexOf(xAxisValue)],
                        "yAxisTitle": "Lap Time (seconds)",
                        "toMins": true
                      }
                    );
                  }
                  else
                  {
                    Navigator.pushNamed(
                      context,
                      "/scattergraph", // Specify the route name
                      arguments: {
                        "xAxis": [xAxisData],
                        "yAxis": [yAxisData],
                        "title": "Title",
                        "colour": [[Color.fromARGB(255, 200, 0, 0), Color.fromARGB(255, 255, 238, 0), Color.fromARGB(255, 208, 208, 208), Color.fromARGB(255, 0, 175, 12), Color.fromARGB(255, 0, 20, 200)][tyres.indexOf(tyreValue)]],
                        "xAxisTitle": ["Session Time (seconds)", "Lap Number", "Session Time (seconds)", "Lap Number", "Tyre Age", "Track Temp. (C)", "Min Speed (km/h)", "Max Speed (km/h)", "Wind Speed (km/h)", "Air Temp. (C)", "Throttle Percentage"][xAxis.indexOf(xAxisValue)],
                        "yAxisTitle": "Lap Time (seconds)",
                        "toMins": true,
                        "title": "Driver Number: " + mapData["results"][currentIndex].toString()
                      }
                    );
                  }
                }
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

  int currentIndex = 0;

  int findMaxLength(int a, int b)
  {
    List<int> list = [a, b];
    return list.reduce((curr, next) => curr < next? curr: next);
  }

  
  List<Widget> containers = [
    Container(
      color: Colors.blue,
      child: Center(child: Text("Container 1")),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("Container 2")),
    ),
    Container(
      color: Colors.orange,
      child: Center(child: Text("Container 3")),
    ),
  ];

  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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

    
    Container GetDriverData(String name, String displayName, int index)
    {
      if (chosenLaps.length <= index)
      {
        chosenLaps.add([]);
        chosenLapTimes.add([]);
      }
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
              softs.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 1)
            {
              mediums.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 2)
            {
              hards.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 3)
            {
              intermediates.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0]]); // weather is 15
            }
            else if (mapData[name][0][i][18] == 4)
            {
              wets.add([i - cancelled, mapData[name][0][i][2], mapData[name][0][i][19], mapData[name][0][i][0]]); // weather is 15
            }
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

        int count = 0;
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
                    child: Center(child: Text('Selected')),
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
              if (chosenLaps[index].length <= count)
              {
                chosenLaps[index].add(false);
                chosenLapTimes[index].add(-1);
              }
              chosenLapTimes[index][count] = timesData[i][j][1];

              int _count = count;
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
                      child: Center(
                        child: checkbox(
                          title: "",
                          initValue: chosenLaps[index][count], 
                          onChanged:  (sts) => setState(() {chosenLaps[index][_count] = !chosenLaps[index][_count]; containers[index] = GetDriverData(name, displayName, index);})
                        )
                      ),
                    ),
                  ]
                )
              );
              print(count.toString() + " count");
              count++;
            }
            widgets.add(
              Table(
                border: TableBorder.all(),
                children: tableWidgets,
              )
            );
          }
          
        }
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: widgets
            )
          )
        );
      }
      catch (e)
      {
        print("Caught " + name.toString());
        return Container();
      }
    }

    

    void goToPreviousContainer() {
      setState(() {
        currentIndex -= 1;
      });

    }

    void goToNextContainer() {
      setState(() {
        currentIndex += 1;
      });
    }

    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      load = true;
      setState(() {
        containers = [];
        List<dynamic> drivers = mapData["results"];
        print(drivers);
        exportData = [];
        for (int i = 0; i < findMaxLength(drivers.length, mapData["driver3"].length); i++)
        {
          containers.add(
            GetDriverData(drivers[i].toString(), "Driver Number: " + drivers[i].toString(), containers.length)
          );
        }
      });
      print(containers.length);
      load = true;
    }
    

    return Scaffold(
      appBar: AppBar(
        title: Text("#" + mapData["results"][currentIndex].toString()),
        actions: [
          ElevatedButton(
            onPressed: () {
              List<List<double>> lapTimes = [];
              for (int i = 0; i < chosenLaps.length; i++)
              {
                lapTimes.add([]);
                for (int j = 0; j < chosenLaps[i].length; j++)
                {
                  if (chosenLaps[i][j])
                  {
                    lapTimes[i].add(chosenLapTimes[i][j]);
                  }
                }
              }
              print(lapTimes);
              Map<String, dynamic> jsonMap = {
                "Laps": lapTimes,
                "Names": mapData["results"]
              };
              Navigator.of(context).pop();
              Navigator.pushNamed(
                context,
                "/racepaceanalyse",
                arguments: jsonMap
              );
            },
            child: Text('Analyse'),
          ),
          ElevatedButton(
            onPressed: currentIndex > 0 ? goToPreviousContainer : null,
            child: Text('Previous'),
          ),
          ElevatedButton(
            onPressed: currentIndex < containers.length - 1 ? goToNextContainer : null,
            child: Text('Next'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: containers[currentIndex],
      )
    );
  }

  Widget checkbox(
      {required String title, required bool initValue, required Function(bool boolValue) onChanged}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          Checkbox(value: initValue, onChanged: (b) => onChanged(b!))
        ]);
  }
}