import 'dart:math' as math;
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

late MyNewChallengeController _myNewChallengeController;

class RanksTabs extends StatefulWidget {
  const RanksTabs({super.key});

  @override
  State<RanksTabs> createState() => _RanksTabsState();
}

class _RanksTabsState extends State<RanksTabs> {
  @override
  void initState() {
    _myNewChallengeController = Get.put(MyNewChallengeController());

    super.initState();
  }

  final _index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          MyAssetHelper.ranksBackground,
          fit: BoxFit.fill,
        ),
        DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: CustomTextWidget(
                text: 'Ranks',
                textColor: MyColorHelper.white,
                fontFamily: "Horta",
                fontSize: 30,
              ),
              backgroundColor: Colors.transparent,
              bottom: TabBar(
                indicatorColor: MyColorHelper.primaryColor,
                labelColor: MyColorHelper.white,
                labelStyle: const TextStyle(
                  color: MyColorHelper.white,
                  fontFamily: "Horta",
                  fontSize: 30,
                ),
                unselectedLabelColor: MyColorHelper.white,
                unselectedLabelStyle: const TextStyle(
                  color: MyColorHelper.white,
                  fontFamily: "Horta",
                  fontSize: 30,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: const Border(
                    right: BorderSide.none,
                    left: BorderSide.none,
                    bottom: BorderSide(
                      color: MyColorHelper
                          .white, // Set the color for the underline
                      width: 5.0, // Set the width for the underline
                    ),
                  ),
                  color: MyColorHelper.tabColor,
                ),
                onTap: (index) {
                  _index.value = index;
                },
                tabs: const [
                  Tab(text: 'Radar'),
                  Tab(text: 'Bar'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const RadarChartSample1(showBlurBackground: true),
                BarChartSample7(showBlurBackground: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///Radar Start
class RadarChartSample1 extends StatefulWidget {
  final bool showBlurBackground;
  const RadarChartSample1({super.key, required this.showBlurBackground});

  @override
  State<RadarChartSample1> createState() => _RadarChartSample1State();
}

class _RadarChartSample1State extends State<RadarChartSample1> {
  int selectedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: widget.showBlurBackground ? 5 : 0,
                sigmaY: widget.showBlurBackground ? 5 : 0),
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
                                    selectedDataSetIndex = response?.touchedSpot
                                            ?.touchedDataSetIndex ??
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
                                    return const RadarChartTitle(
                                        text: 'Timbre');
                                  case 1:
                                    return const RadarChartTitle(text: 'Pitch');
                                  case 2:
                                    return const RadarChartTitle(
                                        text: 'Expression');
                                  case 3:
                                    return const RadarChartTitle(
                                        text: 'Articulation');
                                  case 4:
                                    return const RadarChartTitle(
                                        text: 'Expression');
                                  case 5:
                                    return const RadarChartTitle(
                                        text: 'Pacing');
                                  default:
                                    return const RadarChartTitle(text: '');
                                }
                              },
                              tickCount: 1,
                              ticksTextStyle: const TextStyle(
                                  color: Colors.transparent, fontSize: 10),
                              tickBorderData:
                                  const BorderSide(color: Colors.transparent),
                              gridBorderData: const BorderSide(
                                  color: Colors.redAccent, width: 2),
                            ),
                            swapAnimationDuration:
                                const Duration(milliseconds: 400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

///Radar End

///Bar Start
class BarChartSample7 extends StatefulWidget {
  final bool showBlurBackground;
  BarChartSample7({super.key, required this.showBlurBackground});

  final shadowColor = const Color(0xFFCCCCCC);
  final dataList = [
    const _BarData(Colors.red, 18, 18),
    const _BarData(Colors.green, 17, 8),
    const _BarData(Colors.blue, 10, 15),
    const _BarData(Colors.orange, 2.5, 5),
    const _BarData(Colors.purple, 2, 2.5),
    const _BarData(Colors.greenAccent, 2, 2),
  ];

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
        BarChartRodData(
          toY: shadowValue,
          color: widget.shadowColor,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SvgPicture.asset(
            MyAssetHelper.backgroundImage,
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: widget.showBlurBackground ? 5 : 0,
                sigmaY: widget.showBlurBackground ? 5 : 0),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.4,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        borderData: FlBorderData(
                          show: true,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.brown.withOpacity(0.2),
                            ),
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            drawBelowEverything: true,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: MyColorHelper.white),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: _IconWidget(
                                    color: widget.dataList[index].color,
                                    isSelected: touchedGroupIndex == index,
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: Colors.black45,
                            strokeWidth: 1,
                          ),
                        ),
                        barGroups: widget.dataList.asMap().entries.map((e) {
                          final index = e.key;
                          final data = e.value;
                          return generateBarGroup(
                            index,
                            data.color,
                            data.value,
                            data.shadowValue,
                          );
                        }).toList(),
                        maxY: 20,
                        barTouchData: BarTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipMargin: 0,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                rod.toY.toString(),
                                TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: rod.color,
                                  fontSize: 18,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 12,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            if (event.isInterestedForInteractions &&
                                response != null &&
                                response.spot != null) {
                              setState(() {
                                touchedGroupIndex =
                                    response.spot!.touchedBarGroupIndex;
                              });
                            } else {
                              setState(() {
                                touchedGroupIndex = -1;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);
  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}

///Bar End

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: const Center(
        child: _IconWidget(
          color: MyColorHelper.caribbeanCurrent,
          isSelected: false,
        ),
      ),
    );
  }
}
