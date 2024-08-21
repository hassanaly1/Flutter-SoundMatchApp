import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/models/result_model.dart';

class MyBarChart extends StatefulWidget {
  final ResultModel resultModel;

  const MyBarChart({super.key, required this.resultModel});

  final shadowColor = const Color(0xFFCCCCCC);

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  int touchedGroupIndex = -1;

  BarChartGroupData generateBarGroup(
    int x,
    double value1,
    double value2,
    double value3,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value1,
          color: Colors.red,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: value2,
          color: Colors.green,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: value3,
          color: Colors.blue,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0, 1, 2] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: MyColorHelper.white),
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
                              color: Colors.white,
                              isSelected: touchedGroupIndex == index,
                              profilePictureUrl: widget
                                      .resultModel
                                      .allRoomResult?[index]
                                      .participant!
                                      .profile ??
                                  '',
                            ),
                          );
                        },

                        // getTitlesWidget: (value, meta) {
                        //   final index = value.toInt();
                        //   return SideTitleWidget(
                        //     axisSide: meta.axisSide,
                        //     child: _IconWidget(
                        //       color: Colors.blue,
                        //       isSelected: touchedGroupIndex == index,
                        //     ),
                        //   );
                        // },
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
                  barGroups: widget.resultModel.allRoomResult
                          ?.asMap()
                          .entries
                          .map((e) {
                        final index = e.key;
                        final data = e.value;
                        print('index: $index, data: ${data.roomOne}');
                        return generateBarGroup(
                          index,
                          data.roomOne?.toDouble() ?? 0,
                          data.roomTwo?.toDouble() ?? 0,
                          data.roomThree?.toDouble() ?? 0,
                        );
                      }).toList() ??
                      [],
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipMargin: 8,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      fitInsideHorizontally: true,
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
                            fontSize: 16,
                            fontFamily: 'Poppins',
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
    );
  }
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
    required this.profilePictureUrl,
  }) : super(duration: const Duration(milliseconds: 300));

  final Color color;
  final bool isSelected;
  final String profilePictureUrl;

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
      child: CircleAvatar(
        backgroundColor: widget.color,
        radius: 20,
        backgroundImage: NetworkImage(widget.profilePictureUrl),
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

// class _IconWidget extends ImplicitlyAnimatedWidget {
//   const _IconWidget({
//     required this.color,
//     required this.isSelected,
//   }) : super(duration: const Duration(milliseconds: 300));
//   final Color color;
//   final bool isSelected;
//
//   @override
//   ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
//       _IconWidgetState();
// }
//
// class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
//   Tween<double>? _rotationTween;
//
//   @override
//   Widget build(BuildContext context) {
//     final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
//     final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
//     return Transform(
//       transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
//       origin: const Offset(14, 14),
//       child: Icon(
//         widget.isSelected ? Icons.face_retouching_natural : Icons.face,
//         color: widget.color,
//         size: 28,
//       ),
//     );
//   }
//
//   @override
//   void forEachTween(TweenVisitor<dynamic> visitor) {
//     _rotationTween = visitor(
//       _rotationTween,
//       widget.isSelected ? 1.0 : 0.0,
//       (dynamic value) => Tween<double>(
//         begin: value as double,
//         end: widget.isSelected ? 1.0 : 0.0,
//       ),
//     ) as Tween<double>?;
//   }
// }
