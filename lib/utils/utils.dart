import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/style/app_style.dart';

class Utils{
  static textFieldAlert({required BuildContext context, required Widget content, required String negativeText, Function()? positiveOnPressed, required String positiveText, required String title, Function()? negativeOnPressed}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyle.white,
          contentPadding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          surfaceTintColor: Colors.transparent,
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppStyle.white,
                elevation: 0,
                foregroundColor: AppStyle.primary,
                shadowColor: AppStyle.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                surfaceTintColor: Colors.transparent,
              ),
              onPressed: negativeOnPressed ?? () {
                context.pop();
              },
              child: Text(
                negativeText, 
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppStyle.white,
                elevation: 0,
                foregroundColor: AppStyle.primary,
                shadowColor: AppStyle.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                surfaceTintColor: Colors.transparent,
              ),
              onPressed: positiveOnPressed,
              child: Text(
                positiveText, 
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}