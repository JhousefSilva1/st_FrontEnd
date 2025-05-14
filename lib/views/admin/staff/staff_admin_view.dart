import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../../widgets/widgets.dart';

class StaffAdminView extends StatelessWidget {
  static const String routerName = 'staffAdmin';
  static const String routerPath = '/staffAdmin/:personTypeId';
  final int personTypeId;
  
  const StaffAdminView({super.key, required this.personTypeId});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            onPressed: () => showAddStaffDialog(context, personTypeId),
            icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
          )
        ],
        centerTitle: true,
        text: S.of(context).staff,
      ),
      backgroundColor: AppStyle.white,
      body: SafeArea(
        child: isMobile
            ? _buildMobileLayout()
            : _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          StaffAdminList(personTypeId: personTypeId),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StaffAdminList(personTypeId: personTypeId),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StaffAdminList extends StatefulWidget {
  final int personTypeId;
  const StaffAdminList({super.key, required this.personTypeId});

  @override
  State<StaffAdminList> createState() => _StaffAdminListState();
}

class _StaffAdminListState extends State<StaffAdminList> {
  @override
  void initState() {
    super.initState();
    _loadPersonsByPersonType();
  }

  @override
  void didUpdateWidget(StaffAdminList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.personTypeId != widget.personTypeId) {
      _loadPersonsByPersonType();
    }
  }

  void _loadPersonsByPersonType() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false)
          .loadPersonsByPersonTypeId(widget.personTypeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StaffProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) => provider.searchStaff(value as String),
        ),
        const SizedBox(height: 16),
        _buildContent(provider),
      ],
    );
  }

  Widget _buildContent(StaffProvider provider) {
    if (provider.isLoading && provider.filteredStaff.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: AppStyle.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Column(
        children: [
          Text(
            provider.errorMessage!,
            style: const TextStyle(
              color: AppStyle.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: provider.retryLoading,
            child: Text(
              S.of(context).retry,
              style: const TextStyle(color: AppStyle.white),
            ),
          ),
        ],
      );
    }

    if (provider.filteredStaff.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No hay resultados',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppStyle.black,
          ),
        ),
      );
    }
    if (provider.filteredStaff.isNotEmpty) {
      return ListView.separated(
        itemCount: provider.filteredStaff.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => StaffCard(
          staff: provider.filteredStaff[index], onEdit: () {  }, onDelete: () {  },

        ),
      );
    }

    // Default return statement to ensure a Widget is always returned
    return const SizedBox.shrink();
  }


}

void showAddStaffDialog(BuildContext context, int personTypeId) {
  // Implementar diálogo para agregar staff
}