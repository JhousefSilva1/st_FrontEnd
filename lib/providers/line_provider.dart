import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LineProvider extends ChangeNotifier {
  void goToAddLine(BuildContext context) {
    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        hintText: S.of(context).line,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.emoji_transportation_rounded),
      ), 
      negativeText: S.of(context).cancel, 
      positiveOnPressed: (){}, 
      positiveText: S.of(context).add,
      title: S.of(context).addLine,
    );
  }
}