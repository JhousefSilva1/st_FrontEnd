import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/custom_field.dart';

class BrandProvider extends ChangeNotifier {
  void goToAddBrand(BuildContext context) {
    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        hintText: S.of(context).brand,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.drive_eta),
      ), 
      negativeText: S.of(context).cancel, 
      positiveOnPressed: (){}, 
      positiveText: S.of(context).add,
      title: S.of(context).addBrand,
    );
  }
  
  void goToAddModel(BuildContext context) {
    Utils.textFieldAlert(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            value: 'Suzuki',
            isExpanded: true,
            elevation: 16,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
            },
            items: <String>[
              'Suzuki',
              'Toyota',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: S.of(context).model,
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            prefixIcon: const Icon(Icons.drive_eta),
          ),
        ],
      ), 
      negativeText: S.of(context).cancel, 
      positiveOnPressed: (){}, 
      positiveText: S.of(context).add,
      title: S.of(context).addModel,
    );
  }
}