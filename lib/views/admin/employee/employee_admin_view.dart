import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class EmployeeAdminView extends StatelessWidget {
  static const String routerName = 'employeeAdmin';
  static const String routerPath = '/employeeAdmin';
  const EmployeeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => employeeProvider.goToAddEmployeeAdmin(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).staff
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                EmployeeAdminMobileView(),
              ],
            )
          ),
        ): const EmployeeAdminTabletView(),
      ),
    );
  }
}

class EmployeeAdminMobileView extends StatelessWidget {
  const EmployeeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeForm()
      ],
    );
  }
}

class EmployeeAdminTabletView extends StatelessWidget {
  const EmployeeAdminTabletView({super.key});

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
                  EmployeeForm()
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class EmployeeForm extends StatelessWidget {
  const EmployeeForm({super.key});

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
            return const EmployeeCard();
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