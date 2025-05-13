import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../generated/l10n.dart';
import '../../../providers/providers.dart';
import '../../../style/app_style.dart';
import '../../../utils/utils.dart';


class StaffPreviewAdminView extends StatelessWidget {
  static const String routerName = 'staffPreviewAdmin';
  static const String routerPath = '/staffPreviewAdmin';

  const StaffPreviewAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).staffType,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StaffPreviewAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const StaffPreviewAdminTabletView(),
      ),
    );
  }
}
class StaffPreviewAdminMobileView extends StatelessWidget{
  const StaffPreviewAdminMobileView({super.key});
  @override
  Widget build(BuildContext context){
    return const Column(
      children: [
        StaffPreviewAdminList(),
      ],
    );
  }
}

class StaffPreviewAdminTabletView extends StatelessWidget{
  const StaffPreviewAdminTabletView({super.key});
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
                  StaffPreviewAdminList(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class StaffPreviewAdminList extends StatefulWidget{
  const StaffPreviewAdminList({super.key});
  @override
  State<StaffPreviewAdminList> createState() => _StaffPreviewAdminListState();
}

class _StaffPreviewAdminListState extends State<StaffPreviewAdminList> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffPreviewProvider>(context, listen: false).loadStaffType();
    });
  }
  @override
  Widget build(BuildContext context){
    final provider = context.watch<StaffPreviewProvider>();
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          onChanged: (value) {
            provider.searchStaffsTypes(value);
          },
        ),
        const SizedBox(height: 16),
        // estado de carga
        if(provider.isLoading && provider.staffsTypes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: CircularProgressIndicator(),
          ),
        // Mensaje de error
        if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          if(!provider.isLoading && provider.staffsTypes.isEmpty && provider.errorMessage == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No hay tipos de personal disponibles',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Lista de tipos de personal
            if(provider.staffsTypes.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.staffsTypes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return StaffPreviewCard(
                    staffType: provider.staffsTypes[index],
                  );
                },
              ),
      ],
    );
  }
}
