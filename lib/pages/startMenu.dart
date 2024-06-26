import 'package:flutter/material.dart';



class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

List<String> sessions = ["FP1", "FP2", "FP3", "Qualifying", "Sprint Shootout", "Sprint", "Race"];
List<String> testingSessions = ["1", "2", "3"];

class _StartMenuState extends State<StartMenu> {

  void FindRace(BuildContext context, String path) async {
    final TextEditingController _firstNumberController = TextEditingController();
    final TextEditingController _secondNumberController = TextEditingController();
    String dropdownValue = "FP1";
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
                  TextField(
                    controller: _firstNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                  TextField(
                    controller: _secondNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Round (e.g., Bahrain)'),
                  ),
                  SizedBox(height: 14,),
                  DropdownMenu<String>(
                    initialSelection: sessions.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: sessions.map<DropdownMenuEntry<String>>((String value) {
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
                setState(() {
                  print("Add");
                  print(_firstNumberController.text);
                  print(_secondNumberController.text);
                  print(dropdownValue);
                });
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  path, // Specify the route name
                  arguments: {
                    "year": _firstNumberController.text,
                    "round": _secondNumberController.text,
                    "session": dropdownValue,
                    "test": false
                  }
                );
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

  void FindTest(BuildContext context, String path) async {
    final TextEditingController _firstNumberController = TextEditingController();
    final TextEditingController _secondNumberController = TextEditingController();
    String dropdownValue = "1";
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
                  TextField(
                    controller: _firstNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                  TextField(
                    controller: _secondNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Round (e.g., Bahrain)'),
                  ),
                  SizedBox(height: 14,),
                  DropdownMenu<String>(
                    initialSelection: testingSessions.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: testingSessions.map<DropdownMenuEntry<String>>((String value) {
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
                setState(() {
                  print("Add");
                  print(_firstNumberController.text);
                  print(_secondNumberController.text);
                  print(dropdownValue);
                });
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  path, // Specify the route name
                  arguments: {
                    "year": _firstNumberController.text,
                    "round": _secondNumberController.text,
                    "session": dropdownValue,
                    "test": true
                  }
                );
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
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Start Menu'),
        backgroundColor: const Color.fromARGB(255, 0, 31, 236),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  print("Speed-time graph");
                  FindRace(context, "/loadspeedtime");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Speed-time graph")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Box Plot Race Pace");
                  FindRace(context, "/loadboxplot");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Box Plot Race Pace")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Top Speed View");
                  FindRace(context, "/loadmaxspeed");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Max Speed")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Top Speed View");
                  FindRace(context, "/loadminimumspeed");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Min Speed")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Top Speed View");
                  FindRace(context, "/loadtopspeed");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Top Speeds")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Top Speed View");
                  FindRace(context, "/loadminspeed");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Min Speeds")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Race Start");
                  FindRace(context, "/loadracestart");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Race Start Analysis"),
              ),
              ElevatedButton(
                onPressed: () {
                  print("Race Start");
                  FindRace(context, "/loadtyrestrat");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Tyre Strategy"),
              ),
              ElevatedButton(
                onPressed: () {
                  print("Load Season Points");
                  FindRace(context, "/loadseasonpoints");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Season Points Anim")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Load Season Points");
                  FindRace(context, "/loadtimes");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Load Times")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Load Season Points");
                  FindRace(context, "/loadnewtimesview");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Load Times New")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Load Season Points");
                  FindRace(context, "/loadracepaceanalysis");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Load Race Pace Analysis")
              ),
              ElevatedButton(
                onPressed: () {
                  print("Test Speed-time graph");
                  FindTest(context, "/loadspeedtime");
                  //Navigator.pushNamed(context, "/loadspeedtime");
                },
                child: Text("Speed-time graph")
              ),
            ],
          )
        )
      )
    );
  }
}