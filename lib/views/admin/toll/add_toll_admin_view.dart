import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddTollAdminView extends StatelessWidget {
  static const String routerName = 'addTollAdminView';
  static const String routerPath = '/addTollAdminView';
  const AddTollAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).addToll,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AddTollAdminMobileView(),
              ],
            )
          ),
        ): const AddTollAdminTabletView(),
      ),
    );
  }
}

class AddTollAdminMobileView extends StatelessWidget {
  const AddTollAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AddTollAdminForm(),
      ],
    );
  }
}

class AddTollAdminTabletView extends StatelessWidget {
  const AddTollAdminTabletView({super.key});

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
                  AddTollAdminForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class AddTollAdminForm extends StatelessWidget {
  const AddTollAdminForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).tollData,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).department,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.location_city_rounded),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).province,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.location_city_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).locality,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.location_city_rounded),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).initialSection,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.emoji_transportation_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).finalSection,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.emoji_transportation_rounded),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).typeOfRoad,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.add_road),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomField(
          hintText: S.of(context).cost,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.payment_rounded),
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () {},
          text: S.of(context).add,
        ),
      ],
    );
  }
}