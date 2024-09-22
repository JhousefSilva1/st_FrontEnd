import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class TollAdminView extends StatelessWidget {
  static const String routerName = 'tollAdmin';
  static const String routerPath = '/tollAdmin';
  const TollAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final TollProvider tollProvider = Provider.of<TollProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => tollProvider.goToAddTollAdmin(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).tolls
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TollAdminMobileView(),
              ],
            )
          ),
        ): const TollAdminTabletView(),
      ),
    );
  }
}

class TollAdminMobileView extends StatelessWidget {
  const TollAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TollAdminForm()
      ],
    );
  }
}

class TollAdminTabletView extends StatelessWidget {
  const TollAdminTabletView({super.key});

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
                  TollAdminForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class TollAdminForm extends StatelessWidget {
  const TollAdminForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {},
        ),
        ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const TollCard();
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