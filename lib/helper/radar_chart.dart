import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';

///Radar Start
class MyRadarChart extends StatefulWidget {
  final bool showBlurBackground;
  const MyRadarChart({super.key, required this.showBlurBackground});

  @override
  State<MyRadarChart> createState() => _MyRadarChartState();
}

class _MyRadarChartState extends State<MyRadarChart> {
  int selectedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: RadarChart(
                      RadarChartData(
                        radarTouchData: RadarTouchData(
                          touchCallback: (FlTouchEvent event, response) {
                            if (!event.isInterestedForInteractions) {
                              setState(() {
                                selectedDataSetIndex = -1;
                              });
                              return;
                            }
                            setState(() {
                              selectedDataSetIndex =
                                  response?.touchedSpot?.touchedDataSetIndex ??
                                      -1;
                            });
                          },
                        ),
                        dataSets: showingDataSets(),
                        radarBackgroundColor: Colors.transparent,
                        borderData: FlBorderData(show: false),
                        radarBorderData:
                            const BorderSide(color: Colors.transparent),
                        titlePositionPercentageOffset: 0.2,
                        titleTextStyle: const TextStyle(
                            color: MyColorHelper.white, fontSize: 14),
                        getTitle: (index, angle) {
                          switch (index) {
                            case 0:
                              return const RadarChartTitle(text: 'Timbre');
                            case 1:
                              return const RadarChartTitle(text: 'Pitch');
                            case 2:
                              return const RadarChartTitle(text: 'Expression');
                            case 3:
                              return const RadarChartTitle(
                                  text: 'Articulation');
                            case 4:
                              return const RadarChartTitle(text: 'Expression');
                            case 5:
                              return const RadarChartTitle(text: 'Pacing');
                            default:
                              return const RadarChartTitle(text: '');
                          }
                        },
                        tickCount: 1,
                        ticksTextStyle: const TextStyle(
                            color: Colors.transparent, fontSize: 10),
                        tickBorderData:
                            const BorderSide(color: Colors.transparent),
                        gridBorderData:
                            const BorderSide(color: Colors.redAccent, width: 2),
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 400),
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

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withOpacity(0.2)
            : rawDataSet.color.withOpacity(0.05),
        borderColor:
            isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Rizwan',
        color: Colors.amber,
        values: [300, 50, 250, 400, 150, 240],
      ),
      RawDataSet(
        title: 'Farooq',
        color: Colors.brown,
        values: [250, 100, 200, 400, 150, 390],
      ),
      RawDataSet(
        title: 'Hassan',
        color: Colors.cyan,
        values: [200, 150, 50, 400, 150, 170],
      ),
      RawDataSet(
        title: 'Muneeb',
        color: Colors.deepOrange,
        values: [150, 200, 150, 400, 150, 260],
      ),
      RawDataSet(
        title: 'Raveel',
        color: Colors.indigo,
        values: [100, 250, 100, 400, 150, 80],
      ),
    ];
  }
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
