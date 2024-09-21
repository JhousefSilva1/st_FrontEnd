import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class NotificationView extends StatelessWidget {
  static const String routerName = 'notification';
  static const String routerPath = '/notification';
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).notification,
        ),
        backgroundColor: AppStyle.ligthGrey,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NotificationMobileView()
              ],
            ),
          ),
        ): const NotificationTabletView(),
      ),
    );
  }
}

class NotificationMobileView extends StatelessWidget {
  const NotificationMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NotificationBody()
      ],
    );
  }
}

class NotificationTabletView extends StatelessWidget {
  const NotificationTabletView({super.key});

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
                  NotificationBody()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButton(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                value: '5617-KNK',
                isExpanded: true,
                elevation: 16,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                },
                items: <String>[
                  '5617-KNK',
                  '6235-NYG',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: CustomButton(
                height: 40,
                text: 'Buscar',
                onPressed: () {}
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          itemBuilder: (context, index) {
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
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppStyle.white,
                    radius: 24,
                    child: Image.asset('assets/car.jpg', height: 50, width: 50),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('Urujara', 
                                style: TextStyle(
                                  color: AppStyle.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Bs. 2', 
                              style: TextStyle(
                                color: AppStyle.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text('5617-KNK', 
                                style: TextStyle(
                                  color: AppStyle.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('01/09/24 12:00', 
                              style: TextStyle(
                                fontSize: 14,
                                color: AppStyle.grey,
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 15,
          physics: const NeverScrollableScrollPhysics(),
          primary: true,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        )
      ],
    );
  }
}