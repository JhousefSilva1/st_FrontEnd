import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer_operador.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets.dart';

class HomeOperadorView extends StatelessWidget{
  static const String routerName = 'homeOperador';
  static const String routerPath = '/homeOperador';
  const HomeOperadorView({super.key});

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
        child: Scaffold(
            appBar: const CustomAppBar(
              actions:[

              ],
              centerTitle: true,
              text: 'Home Operador',
            ),
            backgroundColor: AppStyle.white,
            drawer: isMobile ? const SmartTollsOperadorDrawer() : null,
            body: isMobile
                ? const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        HomeOperadorMobileView(),
                      ],
                    )
                  ),
                )
                : const HomeOperadorTabletView(),
        ),
      
      );
  }
}

class HomeOperadorMobileView extends StatelessWidget{
  const HomeOperadorMobileView({super.key});

  @override
  Widget build(BuildContext context){
    return const Column(
      children: [
        HomeOperadorList(),
      ],
    );
  }
}
class HomeOperadorTabletView extends StatelessWidget{
  const HomeOperadorTabletView({super.key});

  @override
  Widget build (BuildContext context){
    return const Row(
      children: [
        SmartTollsOperadorDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HomeOperadorList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeOperadorList extends StatefulWidget{
  const HomeOperadorList({super.key});

  @override
  State<HomeOperadorList> createState() => _HomeOperadorListState();
}
class _HomeOperadorListState extends State<HomeOperadorList>{
  @override
  void initState() {
    super.initState();
    // Initialize any data or state here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform actions after the first frame is rendered
      // For example, you can fetch data or update the UI
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
        )
      ],
    );
  }
}