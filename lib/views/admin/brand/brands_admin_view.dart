import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class BrandsAdminView extends StatelessWidget {
  static const String routerName = 'brandsAdmin';
  static const String routerPath = '/brandsAdmin';
  const BrandsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandProvider brandProvider = Provider.of<BrandProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            PopupMenuButton(
              color: AppStyle.white,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.add),
              ),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () => brandProvider.goToAddBrand(context),
                    child: Text(S.of(context).brand),
                  )
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () => brandProvider.goToAddModel(context),
                    child: Text(S.of(context).model),
                  )
                )
              ],
            )
          ],
          centerTitle: true,
          text: S.of(context).brand
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                BrandsAdminMobileView(),
              ],
            )
          ),
        ): const BrandsAdminTabletView(),
      ),
    );
  }
}

class BrandsAdminMobileView extends StatelessWidget {
  const BrandsAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BrandsForm()
      ],
    );
  }
}

class BrandsAdminTabletView extends StatelessWidget {
  const BrandsAdminTabletView({super.key});

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
                  BrandsForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class BrandsForm extends StatelessWidget {
  const BrandsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {},
        ),
        ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const BrandsCard();
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