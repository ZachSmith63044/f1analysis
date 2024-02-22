import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> copyScriptFromAssets(String year) async {
  final ByteData data = await rootBundle.load('assets/getSeason.py');
  final List<int> bytes = data.buffer.asUint8List();

  final String tempDir = (await getApplicationDocumentsDirectory()).path;
  final String scriptPath = '$tempDir/getSeason.py';

  final File file = File(scriptPath);
  await file.writeAsBytes(bytes);

  String pythonExecutable = 'python';
  List<String> arguments = [scriptPath, year, tempDir];
  await runCommand(pythonExecutable, arguments);
}

Future<void> runCommand(String command, List<String> arguments) async {
  final result = await Process.run(command, arguments);
  print('Exit code: ${result.exitCode}');
  print('Stdout: ${result.stdout}');
  print('Stderr: ${result.stderr}');
}