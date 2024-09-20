import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/drawer.dart';

class HomeView extends StatelessWidget {
  static const String routerName = 'home';
  static const String routerPath = '/home';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
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
        drawer: isMobile? const SmartTollsDrawer(): null,
        backgroundColor: AppStyle.ligthGrey,
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16),
        //     child: SizedBox(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           const SizedBox(height: 16),
        //           Container(
        //             decoration: BoxDecoration(
        //               border: Border.all(color: AppStyle.white, width: 1),
        //               borderRadius: const BorderRadius.all(Radius.circular(8)),
        //               color: AppStyle.white,
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.1),
        //                   blurRadius: 4,
        //                   spreadRadius: 1
        //                 ),
        //               ]
        //             ),
        //             width: double.infinity,
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        //               child: AspectRatio(
        //                 aspectRatio: 1.70,
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(
        //                     right: 18,
        //                     left: 12,
        //                     top: 24,
        //                     bottom: 12,
        //                   ),
        //                   child: LineChart(
        //                     mainData(homeProvider),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                HomeMobileView()
              ],
            ),
          ),
        ): const HomeTabletView(),
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

class HomeMobileView extends StatelessWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Home()
      ],
    );
  }
}

class HomeTabletView extends StatelessWidget {
  const HomeTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Home()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: Text(S.of(context).appName, style: const TextStyle(color: AppStyle.primary, fontSize: 30, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: HomeCard(
                data: '2',
                icon: const Icon(Icons.electric_car_rounded, color: AppStyle.primary, size: 30),
                title: S.of(context).registerCars
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: HomeCard(
                data: '20',
                icon: const Icon(Icons.wallet, color: AppStyle.primary, size: 30),
                title: S.of(context).completedTransactions
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: HomeCard(
                data: '5',
                icon: const Icon(Icons.business_outlined, color: AppStyle.primary, size: 30),
                title: S.of(context).tollsUsed
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: HomeCard(
                data: 'Bs. 15',
                icon: const Icon(Icons.paid_rounded, color: AppStyle.primary, size: 30),
                title: S.of(context).totalPaid
              ),
            ),
          ],
        ),
      ],
    );
  }
}
class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.data, required this.icon, required this.title});
  final String data;
  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(data, style: const TextStyle(color: AppStyle.primary, fontSize: 26, fontWeight: FontWeight.w800), textAlign: TextAlign.center)
                  )
                ],
              ),
            ),
            icon
          ],
        ),
      ),
    );
  }
}