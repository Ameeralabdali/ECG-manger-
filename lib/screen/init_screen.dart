import 'dart:math';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:awecg/widget/menu_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class InitScreen extends StatelessWidget {
  InitScreen({super.key});

  double menuButtonPadding = 5.dp;

  List<double>? ecgData;
  double? scale;
  double? speed;
  double? zoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /*NavigationRail(
            elevation: 8,
            extended: false,
            leading: IconButton(n  
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {}),
            backgroundColor: MyColors.blueL,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(
                  Icons.share,
                ),
                label: Text('Share'),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.search,
                ),
                label: Text('Search'),
              ),
            ],
            trailing: IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {}),
            selectedIndex: null,
          ),*/
          Container(
            width: 60.dp,
            color: MyColors.blueL,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.menu, // Menu button
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.share, // share button -----------------------------
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'lib/assets/svg_files/up-and-down.svg', // up and down button
                      width: 40.dp,
                      height: 40.dp,
                      color: MyColors.grayL,
                    ),
                    /*Icon(
                      Icons.insert_chart,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),*/
                    onPressed: () {
                      BlocProvider.of<InitScreenBloc>(context)
                          .add(LoadECGFIleInitScreen());
                    },
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Expanded(child: Container()),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: 12.dp,
                        bottom: 10.dp,
                        left: 10.dp,
                        right: 10.dp,
                      ),
                      child: Stack(
                        children: [
                          BlocBuilder<InitScreenBloc, InitScreenState>(
                            builder: (context, state) {
                              print('state: $state');
                              if (state is InitScreenLoadData) {
                                print('ecgData: ${state.data}');
                                ecgData = state.data;
                              }
                              if (state is InitScreenChangeScales) {
                                print('ecgData: ${state.data}');
                                scale = state.scale;
                                speed = state.speed;
                                zoom = state.zoom;
                                ecgData = state.data;
                              }
                              ecgData ??= [];
                              scale ??= 10;
                              speed ??= 25;
                              zoom ??= 1;
                              List<double> ecgShow = [];
                              print('ecgData: $ecgData');
                              for (int i = 0; i < ecgData!.length; i++) {
                                ecgShow.add(ecgData![i] * scale!);
                              }
                              return LineChart(
                                LineChartData(
                                  lineTouchData: LineTouchData(
                                    distanceCalculator:
                                        (touchPoint, spotPixelCoordinates) {
                                      return (touchPoint - spotPixelCoordinates)
                                          .distance;
                                    },
                                    touchTooltipData: LineTouchTooltipData(
                                        //maxContentWidth: 1,
                                        tooltipBgColor: MyColors.RedL,
                                        getTooltipItems: (touchedSpots) {
                                          return touchedSpots
                                              .map((LineBarSpot touchedSpot) {
                                            final textStyle = TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.dp,
                                            );
                                            return LineTooltipItem(
                                                'Time: ${(touchedSpot.x / speed!).toStringAsFixed(3)} s\nVoltage: ${(touchedSpot.y / scale!).toStringAsFixed(2)} mV',
                                                textStyle);
                                          }).toList();
                                        }),
                                    handleBuiltInTouches: true,
                                    getTouchLineStart: (data, index) => 0,
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      show: true,
                                      color: MyColors.grayL,
                                      spots: ecgShow.isEmpty
                                          ? []
                                          : ecgShow
                                              .asMap()
                                              .map((index, value) => MapEntry(
                                                  index,
                                                  FlSpot(
                                                      index * (0.004) * speed!,
                                                      value)))
                                              .values
                                              .toList(),
                                      isCurved: false,
                                      curveSmoothness: 0.1,
                                      isStrokeCapRound: false,
                                      barWidth: 1,
                                      belowBarData: BarAreaData(
                                        show: false,
                                      ),
                                      dotData: FlDotData(show: false),
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    show: false,
                                    leftTitles: AxisTitles(
                                      axisNameWidget: Text(
                                        'Voltage [mV]',
                                        style: TextStyle(
                                          color: Colors.black
                                              .withOpacity(0.5), // 0.2
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.dp,
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        //getTitlesWidget: leftTitleWidgets,
                                        reservedSize: 30.dp,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Text(
                                        'Time [s]',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black
                                              .withOpacity(0.5), // 0.2
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.dp,
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        //getTitlesWidget: bottomTitleWidgets,
                                        reservedSize: 26.dp,
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawHorizontalLine: true,
                                    drawVerticalLine: true,
                                    horizontalInterval:
                                        1, // scale in mV (0.1 mV)
                                    verticalInterval: 1, // scale to show
                                    getDrawingHorizontalLine: (value) {
                                      return value % 5 == 0
                                          ? FlLine(
                                              color: MyColors.RedL, // 0.2
                                              strokeWidth: 0.5,
                                            )
                                          : FlLine(
                                              color: MyColors.RedL, // 0.2
                                              strokeWidth: 0.1,
                                            );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return value % 5 == 0
                                          ? FlLine(
                                              color: MyColors.RedL, // 0.2
                                              strokeWidth: 0.5,
                                            )
                                          : FlLine(
                                              color: MyColors.RedL, // 0.2
                                              strokeWidth: 0.1,
                                            );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                      color: MyColors.RedL,
                                      width: 1,
                                    ),
                                  ),
                                  maxY: 30 * zoom!,
                                  minY: -30 * zoom!,
                                  minX: 0,
                                  maxX: 80 * zoom!,
                                ),
                              );
                            },
                            buildWhen: (previous, current) =>
                                current is InitScreenLoadData ||
                                current is InitScreenInitial ||
                                current is InitScreenChangeScales,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5.dp),
                              decoration: BoxDecoration(
                                color: MyColors.RedL,
                                borderRadius: BorderRadius.circular(5.dp),
                              ),
                              child:
                                  BlocBuilder<InitScreenBloc, InitScreenState>(
                                builder: (context, state) {
                                  String scaleText = "";
                                  String speedText = "";
                                  if (state is InitScreenChangeScales) {
                                    scale = state.scale;
                                    speed = state.speed;
                                  }
                                  if (scale == 10.0) {
                                    scaleText = '10';
                                  } else if (scale == 20.0) {
                                    scaleText = '20';
                                  } else if (scale == 30.0) {
                                    scaleText = '30';
                                  } else if (scale == 2.0) {
                                    scaleText = '2';
                                  } else if (scale == 2.5) {
                                    scaleText = '2.5';
                                  } else if (scale == 5.0) {
                                    scaleText = '5';
                                  }

                                  if (speed == 25.0) {
                                    speedText = '25';
                                  } else if (speed == 30.0) {
                                    speedText = '30';
                                  } else if (speed == 50.0) {
                                    speedText = '50';
                                  } else if (speed == 20.0) {
                                    speedText = '20';
                                  }

                                  return Text(
                                    '${const I18n().ecgSignal} \t ${const I18n().scale}: ${scaleText} div/mV \t ${const I18n().speed}: ${speedText} div/s',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.dp,
                                    ),
                                  );
                                },
                                buildWhen: (previous, current) =>
                                    current is InitScreenChangeScales,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  color: MyColors.blueL,
                  width: 200.dp,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // title of section
                                padding: EdgeInsets.all(5.dp),
                                decoration: BoxDecoration(
                                  color: MyColors.RedL,
                                  borderRadius: BorderRadius.circular(5.dp),
                                ),
                                child: Text(
                                  const I18n().frequency.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.dp,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: MyColors.RedL,
                                    size: 40.dp,
                                  ),
                                  Text(
                                    '89',
                                    style: TextStyle(
                                      color: MyColors.RedL,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.dp,
                                    ),
                                  ),
                                  Text(
                                    'bpm',
                                    style: TextStyle(
                                      color: MyColors.RedL,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.dp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: MyColors.grayL,
                        thickness: 0.5,
                        height: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /*Container( // title of section Scale
                                padding: EdgeInsets.all(5.dp),
                                decoration: BoxDecoration(
                                  color: MyColors.RedL,
                                  borderRadius: BorderRadius.circular(5.dp),
                                ),
                                child: Text(
                                  const I18n().scale.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.dp,
                                  ),
                                ),
                              ),*/
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Tooltip(
                                          message: I18n().changeSpeed,
                                          waitDuration:
                                              const Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ChangeSpeedInitScreen());
                                            },
                                            onHover: (value) {
                                              // show tooltip here with name of button
                                            },
                                            child: Transform.rotate(
                                              angle: 90 * pi / 180,
                                              child: Icon(
                                                Icons.height,
                                                size: 25.dp,
                                                color: MyColors.GrayL,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: I18n().resetZoom,
                                          waitDuration: Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ResetZoomInitScreen());
                                            },
                                            onHover: (value) {
                                              // show tooltip here with name of button
                                            },
                                            child: Icon(
                                              Icons.find_replace,
                                              size: 25.dp,
                                              color: MyColors.GrayL,
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: I18n().zoomIn,
                                          waitDuration: Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ZoomInInitScreen());
                                            },
                                            onHover: (value) {
                                              // show tooltip here with name of button
                                            },
                                            child: Icon(
                                              Icons.zoom_in,
                                              size: 25.dp,
                                              color: MyColors.GrayL,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Tooltip(
                                          message: I18n().changeScale,
                                          waitDuration: Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ChangeScaleInitScreen());
                                            },
                                            child: Icon(
                                              Icons.height,
                                              size: 25.dp,
                                              color: MyColors.GrayL,
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: I18n().resetScale,
                                          waitDuration: Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ResetScalesInitScreen());
                                            },
                                            child: Icon(
                                              Icons.autorenew,
                                              size: 25.dp,
                                              color: MyColors.GrayL,
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: I18n().zoomOut,
                                          waitDuration: Duration(seconds: 1),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.RedL,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.dp),
                                              ),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(ZoomOutInitScreen());
                                            },
                                            onHover: (value) {
                                              // show tooltip here with name of button
                                            },
                                            child: Icon(
                                              Icons.zoom_out,
                                              size: 25.dp,
                                              color: MyColors.GrayL,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: MyColors.grayL,
                        thickness: 0.5,
                        height: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Row(
                            children: [],
                          ),
                        ),
                      ),
                      Divider(
                        color: MyColors.grayL,
                        thickness: 0.5,
                        height: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Row(
                            children: [],
                          ),
                        ),
                      ),
                      Divider(
                        color: MyColors.grayL,
                        thickness: 0.5,
                        height: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Row(
                            children: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
