import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddEmployeeAdminView extends StatelessWidget {
  static const String routerName = 'addEmployeeAdmin';
  static const String routerPath = '/addEmployeeAdmin';
  const AddEmployeeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).addEmployee,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AddEmployeeAdminMobileView(),
              ],
            )
          ),
        ): const AddEmployeeAdminTabletView(),
      ),
    );
  }
}

class AddEmployeeAdminMobileView extends StatelessWidget {
  const AddEmployeeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AddEmployeeForm(),
      ],
    );
  }
}

class AddEmployeeAdminTabletView extends StatelessWidget {
  const AddEmployeeAdminTabletView({super.key});

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
                  AddEmployeeForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class AddEmployeeForm extends StatelessWidget {
  const AddEmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).vehicleData,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).lastNameF,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).lastNameF,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
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
                hintText: S.of(context).name,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).typeOfDocument,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.badge_outlined),
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
                hintText: S.of(context).dni,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.badge_outlined),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).gender,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.account_circle_rounded),
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
                hintText: S.of(context).birthdate,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.cake_rounded),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).email,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomField(
          hintText: S.of(context).phone,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.phone_android_rounded),
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