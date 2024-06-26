import 'package:f1analysis/main.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class RacePaceAnalyse extends StatefulWidget {
  const RacePaceAnalyse({super.key});

  @override
  State<RacePaceAnalyse> createState() => _RacePaceAnalyseState();
}

Map<String, dynamic> mapData = {};
bool load = false;

class _RacePaceAnalyseState extends State<RacePaceAnalyse> {
  List<List<double>> lapTimes = [];
  List<double> driverConsistency = [];
  List<double> driverAbove = [];
  List<bool> valid = [];
  List<int> consistencyRank = [];
  List<int> aboveRank = [];
  ScreenshotController screenshotController = ScreenshotController();

  List<List<double>> sort2D(List<List<double>> list2D)
  {
    bool flag = true;
    List<List<double>> newList = list2D;
    while (flag)
    {
      flag = false;
      for (int i = 0; i < list2D.length - 1; i++)
      {
        if (newList[i][0] > newList[i + 1][0])
        {
          List<double> temp = newList[i];
          newList[i] = newList[i + 1];
          newList[i + 1] = temp;
          flag = true;
        }
      }
    }
    return newList;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget mainContainer = Container(
    child: Text("child")
  );

  @override
  Widget build(BuildContext context) {

    if (load == false)
    {
      mapData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      load = true;
      lapTimes = mapData["Laps"];
      lapTimes[0].sort();
      print(lapTimes);
      print(lapTimes.length);

      for (int i = 0; i < lapTimes.length; i++)
      {
        if (lapTimes[i].length == 0)
        {
          driverAbove.add(99999999);
          driverConsistency.add(99999999);
          valid.add(false);
        }
        else
        {
          double median = 0;
          if (lapTimes.length % 2 == 0)
          {
              median = (lapTimes[i][((lapTimes[i].length)/2 - 1).toInt()] + lapTimes[i][((lapTimes[i].length)/2).toInt()])/2;
          }
          else
          {
              median = (lapTimes[i][(lapTimes.length/2 - 0.5).toInt()]);
          }

          double mean = 0;
          lapTimes[i].forEach((e) => mean += e);
          mean = mean/lapTimes[i].length;

          print(mean);
          print(median);

          double consistency = 0;
          int above = 0;
          for (int j = 0; j < lapTimes[i].length; j++)
          {
            if (lapTimes[i][j] <= median)
            {
              consistency -= lapTimes[i][j] - median;
            }
            else
            {
              consistency += lapTimes[i][j] - median;
            }
            if (lapTimes[i][j] > mean)
            {
              above++;
            }
          }
          driverAbove.add(above/lapTimes[i].length);
          driverConsistency.add(consistency/lapTimes[i].length);
          valid.add(true);
          print(above.toString() + " above");
          print(consistency);
          print((consistency/lapTimes.length).toString() + " consistency");
          
        }
      }

      List<List<double>> toSort = [];
      for (int i = 0; i < driverConsistency.length; i++)
      {
        toSort.add([driverConsistency[i], i.toDouble()]);
      }
      toSort = sort2D(toSort);
      for (int i = 0; i < toSort.length; i++)
      {
        consistencyRank.add(0);
      }
      for (int i = 0; i < toSort.length; i++)
      {
        consistencyRank[toSort[i][1].toInt()] = i;
      }

      toSort = [];
      for (int i = 0; i < driverAbove.length; i++)
      {
        toSort.add([driverAbove[i], i.toDouble()]);
      }
      toSort = sort2D(toSort);
      for (int i = 0; i < toSort.length; i++)
      {
        aboveRank.add(0);
      }
      for (int i = 0; i < toSort.length; i++)
      {
        aboveRank[toSort[i][1].toInt()] = i;
      }
      List<dynamic> names = mapData["Names"];
      List<TableRow> tableWidgets = [
        TableRow(
          children: [
            TableCell(
              child: Center(child: Text(
                "Driver Number",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )),
            ),
            TableCell(
              child: Center(child: Text(
                "Rank Type 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )),
            ),
            TableCell(
              child: Center(child: Text(
                "Rank Type 2",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )),
            ),
          ]
        )
      ];
      for (int i = 0; i < aboveRank.length; i++)
      {
        tableWidgets.add(
          TableRow(
            children: [
              TableCell(
                child: Center(child: Text(names[i].toString())),
              ),
              TableCell(
                child: Center(child: Text(consistencyRank[i].toString())),
              ),
              TableCell(
                child: Center(child: Text(aboveRank[i].toString())),
              ),
            ]
          )
        );
      }

      mainContainer = Container(
        child: Table(
          border: TableBorder.all(),
          children: tableWidgets,
        )
      );

      print(aboveRank);
      print(toSort);
      print(consistencyRank);
      print(driverAbove);
      print(driverConsistency);
    }
    

    return Scaffold(
      appBar: AppBar(
        title: Text("TITLE"),
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                mainContainer
              ],
            ),
          ),
        ),
      )
    );
  }
}