import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';

class HomeView extends StatelessWidget {
  static const String routerName = 'home';
  static const String routerPath = '/home';
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppStyle.primary,
                radius: 16,
                child: Icon(Icons.verified_user, color: AppStyle.white, size: 20),
              ),
              SizedBox(width: 8),
              Text('Jose Pozo', style: TextStyle(color: AppStyle.primary, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppStyle.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: AppStyle.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1
                        ),
                      ]
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: Text(S.of(context).appName, style: const TextStyle(color: AppStyle.primary, fontSize: 24.0, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.white, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: AppStyle.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1
                            ),
                          ]
                        ),
                        width: MediaQuery.of(context).size.width * .44,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).registerCars, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text('2', style: TextStyle(color: AppStyle.primary, fontSize: 18.0, fontWeight: FontWeight.w800), textAlign: TextAlign.center)
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.electric_car_rounded, color: AppStyle.primary, size: 30),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.white, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: AppStyle.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1
                            ),
                          ]
                        ),
                        width: MediaQuery.of(context).size.width * .44,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).completedTransactions, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text('20', style: TextStyle(color: AppStyle.primary, fontSize: 18.0, fontWeight: FontWeight.w800), textAlign: TextAlign.center)
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.wallet, color: AppStyle.primary, size: 30),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.white, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: AppStyle.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1
                            ),
                          ]
                        ),
                        width: MediaQuery.of(context).size.width * .44,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).tollsUsed, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text('5', style: TextStyle(color: AppStyle.primary, fontSize: 18.0, fontWeight: FontWeight.w800), textAlign: TextAlign.center)
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.business_outlined, color: AppStyle.primary, size: 30),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.white, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: AppStyle.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1
                            ),
                          ]
                        ),
                        width: MediaQuery.of(context).size.width * .44,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).totalPaid, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text('Bs. 15', style: TextStyle(color: AppStyle.primary, fontSize: 18.0, fontWeight: FontWeight.w800), textAlign: TextAlign.center)
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.paid_rounded, color: AppStyle.primary, size: 30),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppStyle.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: AppStyle.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1
                        ),
                      ]
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: AspectRatio(
                        aspectRatio: 1.70,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            left: 12,
                            top: 24,
                            bottom: 12,
                          ),
                          child: LineChart(
                            mainData(homeProvider),
                          ),
                        ),
                      ),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1K';
        break;
      case 3:
        text = '3k';
        break;
      case 5:
        text = '5k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(HomeProvider homeProvider) {
    return LineChartData(
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppStyle.ligthGrey),
      ),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppStyle.grey,
            strokeWidth: 1,
          );
        },
        horizontalInterval: 1,
        show: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: homeProvider.gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: homeProvider.gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
      maxX: 11,
      maxY: 6,
      minX: 0,
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
    );
  }
}