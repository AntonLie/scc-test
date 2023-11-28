import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/scc_calendar.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart({
    Key? key,
  }) : super(key: key);
  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  bool isDownloadOpen = false;
  List<ChartSampleData>? chartData;

  //Calendar State
  DateTime? startDtSelected;
  DateTime? endDtSelected;
  bool reset = false;

  void handleIsDownloadOpen() {
    setState(() {
      isDownloadOpen = !isDownloadOpen;
    });
  }

  List<SplineSeries<ChartSampleData, String>> _getDefaultSplineSeries() {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData!,
          name: 'TP1',
          markerSettings: const MarkerSettings(isVisible: true),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.tp1,
          legendIconType: LegendIconType.horizontalLine),
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData!,
          name: 'TP2',
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.tp2,
          markerSettings: const MarkerSettings(isVisible: true),
          legendIconType: LegendIconType.horizontalLine),
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData!,
          name: 'TP3',
          markerSettings: const MarkerSettings(isVisible: true),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.tp3,
          legendIconType: LegendIconType.horizontalLine),
      SplineSeries<ChartSampleData, String>(
          dataSource: chartData!,
          name: 'TP4',
          markerSettings: const MarkerSettings(isVisible: true),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.tp4,
          legendIconType: LegendIconType.horizontalLine),
    ];
  }

  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(x: '10 Oct', tp1: 0, tp2: 0, tp3: 0, tp4: 0),
      ChartSampleData(x: '11 Oct', tp1: 23, tp2: 24, tp3: 41, tp4: 24),
      ChartSampleData(x: '12 Oct', tp1: 42, tp2: 59, tp3: 45, tp4: 67),
      ChartSampleData(x: '13 Oct', tp1: 69, tp2: 60, tp3: 48, tp4: 30),
      ChartSampleData(x: '14 Oct', tp1: 34, tp2: 96, tp3: 52, tp4: 23),
      ChartSampleData(x: '15 Oct', tp1: 65, tp2: 37, tp3: 57, tp4: 78),
      ChartSampleData(x: '16 Oct', tp1: 41, tp2: 40, tp3: 61, tp4: 62),
      ChartSampleData(x: '17 Oct', tp1: 10, tp2: 50, tp3: 66, tp4: 15),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Total Transaction",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.scaleFont(18))),
                      Row(
                        children: [
                          SizedBox(
                            height: 48,
                            // width: context.deviceWidth() * 0.15,
                            child: SccPeriodPicker(
                              isRTL: true,
                              reset: reset,
                              onFinishedBuild: () {
                                reset = false;
                              },
                              onRangeDateSelected: (val) {
                                startDtSelected = val?.start;
                                endDtSelected = val?.end;
                              },
                              onStartDateChanged: (val) {
                                startDtSelected = val;
                                endDtSelected = val;
                              },
                              onEndDateChanged: (val) {
                                endDtSelected = val;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                              onTap: () => {handleIsDownloadOpen()},
                              child: Icon(
                                Icons.cloud_download_outlined,
                                color: sccMapZoomSeperator.withOpacity(0.5),
                                size: 25,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SfTheme(
                    data: SfThemeData(
                      chartThemeData: SfChartThemeData(
                          plotAreaBackgroundColor: sccDark.withOpacity(0.8),
                          majorGridLineColor: sccDark2.withOpacity(0.5)),
                    ),
                    child: SfCartesianChart(
                      palette: const <Color>[
                        Colors.red,
                        Colors.blue,
                        Colors.yellow,
                        Colors.green
                      ],
                      legend: Legend(isVisible: true),
                      primaryXAxis: CategoryAxis(
                          labelPlacement: LabelPlacement.onTicks,
                          title: AxisTitle(text: "Time")),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          axisLine: const AxisLine(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          labelFormat: '{value}',
                          majorTickLines: const MajorTickLines(size: 0),
                          title: AxisTitle(text: "Total Transaction")),
                      series: _getDefaultSplineSeries(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ))
              ],
            )),
        Visibility(
            visible: isDownloadOpen,
            child: Positioned(
                top: 50.0,
                right: 0.0,
                child: Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                    decoration: BoxDecoration(
                        color: sccWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => {handleIsDownloadOpen()},
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Download PDF",
                                      textAlign: TextAlign.left,
                                    ),
                                  ])),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                            width: 120.0,
                            height: 2.0,
                            color: sccLightGrayDivider),
                        const SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () => {handleIsDownloadOpen()},
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Download Excel",
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      ],
    );
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.tp1,
      this.xValue,
      this.yValue,
      this.tp2,
      this.tp3,
      this.tp4,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? tp1;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? tp2;

  /// Holds y value of the datapoint(for 3rd series)
  final num? tp3;

  /// Holds y value of the datapoint(for 4th series)
  final num? tp4;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
