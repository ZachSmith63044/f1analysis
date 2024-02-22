import "package:f1analysis/pages/advancedTimesView.dart";
import 'package:flutter/material.dart';
import "package:f1analysis/pages/startMenu.dart";
import "package:f1analysis/pages/loadingSpeedTime.dart";
import "package:f1analysis/pages/loadingBoxPlotPace.dart";
import "package:f1analysis/pages/speedTime.dart";
import "package:f1analysis/pages/boxPlot.dart";
import "package:f1analysis/pages/seasonView.dart";
import "package:f1analysis/pages/topSpeedView.dart";
import "package:f1analysis/pages/loadingTopSpeed.dart";
import "package:f1analysis/pages/loadingSeasonPoints.dart";
import "package:f1analysis/pages/minSpeedView.dart";
import "package:f1analysis/pages/loadingMinSpeed.dart";
import "package:f1analysis/pages/loadingRaceStart.dart";
import "package:f1analysis/pages/raceStartView.dart";
import "package:f1analysis/pages/loadTyreStrat.dart";
import "package:f1analysis/pages/tyreStrat.dart";
import "package:f1analysis/pages/loadingTimes.dart";
import "package:f1analysis/pages/timesView.dart";
import "package:f1analysis/pages/timesViewNew.dart";
import "package:f1analysis/pages/loadingTimesViewNew.dart";
import "package:f1analysis/pages/lineGraph.dart";
import "package:f1analysis/pages/scatterGraph.dart";


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      initialRoute: "/startmenu",
      routes: {
        "/startmenu": (context) => const StartMenu(),
        "/loadspeedtime": (context) => const LoadSpeedTime(),
        "/loadboxplot": (context) => const LoadBoxPlot(),
        "/speedtime": (context) => const SpeedTime(),
        "/boxplot": (context) => BoxPlotChart(),
        "/topspeed": (context) => TopSpeedView(),
        "/loadtopspeed": (context) => const LoadTopSpeed(),
        "/loadseasonpoints": (context) => LoadSeasonPoints(),
        "/seasonpoints": (context) => SeasonView(),
        "/loadminspeed": (context) => LoadMinSpeed(),
        "/minspeed": (context) => MinSpeedView(),
        "/loadracestart": (context) => LoadRaceStart(),
        "/racestart": (context) => RaceStartView(),
        "/loadtyrestrat": (context) => LoadTyreStrategy(),
        "/tyrestratview": (context) => TyreStratView(),
        "/loadtimes": (context) => LoadTimes(),
        "/timesview": (context) => TimesView(),
        "/advancedtimesview": (context) => AdvancedTimesView(),
        "/newtimesview": (context) => TimesViewNew(),
        "/loadnewtimesview": (context) => LoadTimesNew(),
        "/linegraph": (context) => LineGraph(),
        "/scattergraph": (context) => ScatterGraph(),
      }
  ));
}