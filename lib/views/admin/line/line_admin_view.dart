import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LineAdminView extends StatelessWidget {
  static const String routerName = 'lineAdmin';
  static const String routerPath = '/lineAdmin';
  const LineAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final LineProvider lineProvider = Provider.of<LineProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => lineProvider.goToAddLine(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).lines
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                LineAdminMobileView(),
              ],
            )
          ),
        ): const LineAdminTabletView(),
      ),
    );
  }
}

class LineAdminMobileView extends StatelessWidget {
  const LineAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LineAdminForm()
      ],
    );
  }
}

class LineAdminTabletView extends StatelessWidget {
  const LineAdminTabletView({super.key});

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
                  LineAdminForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class LineAdminForm extends StatelessWidget {
  const LineAdminForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const LineCard();
          },
          physics: const NeverScrollableScrollPhysics(),
          primary: true,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ],
    );
  }
}