import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../../widgets/widgets.dart';

class HomeAdminView extends StatelessWidget {
  static const String routerName = 'homeAdmin';
  static const String routerPath = '/homeAdmin';
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          actions:[

          ],
          centerTitle: true,
          text: 'Home Admin',
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const  SmartTollsDrawer() : null,
        body: isMobile
          ? const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    HomeAdminMobileView(),
                  ],
                ),
              ),
          )
          : const HomeAdminTabletView(),
      ),
    );
  }
}

class HomeAdminMobileView extends StatelessWidget{
  const HomeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
         HomeAdminList(),
      ],
    );
  }
}
class HomeAdminTabletView extends StatelessWidget{
  const HomeAdminTabletView({super.key});

  @override
  Widget build(BuildContext context){
    return const Row(
      children: [
        SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HomeAdminList(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeAdminList extends StatefulWidget{
  const HomeAdminList({super.key});

  @override
  State<HomeAdminList> createState() => _HomeAdminListState();

}
class _HomeAdminListState extends State<HomeAdminList> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aquí puedes llamar a tu función de inicialización
      // homeAdminProvider.getBrands(context);
    });
  }

  @override
  Widget build(BuildContext context){

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          
        )
      ],
    );
  }
}