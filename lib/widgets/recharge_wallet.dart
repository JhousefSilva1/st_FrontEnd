import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class RechargeWallet extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback? onPressed;
  const RechargeWallet({
    required this.text,
    required this.active,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        border: Border.all(
          color: active ? AppStyle.primary : Colors.white, 
          width: 1
        ),
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(15.0))
      ),
      child: MaterialButton(
        color: AppStyle.white,
        disabledColor: AppStyle.ligthGrey,
        elevation: 0,
        highlightColor: AppStyle.white,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        splashColor: AppStyle.white,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: active? AppStyle.primary : Colors.black,
              fontWeight: active? FontWeight.bold : FontWeight.normal,
            ),
          )
        ),
      )
    );
  }
}