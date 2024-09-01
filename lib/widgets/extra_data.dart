import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class ExtraText extends StatelessWidget {
  const ExtraText({super.key, 
    required this.data,
    this.dataStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppStyle.black
    ),
    this.flexFirst = 2, 
    this.flexSecond = 1, 
    this.marginHorizontal = 4,
    required this.title, 
    this.titleStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppStyle.primary
    )
  });
  final String data;
  final TextStyle dataStyle;
  final int flexFirst;
  final int flexSecond;
  final double marginHorizontal;
  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: flexFirst,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              child: Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Flexible(
            flex: flexSecond,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Text(
                  data,
                  textAlign: TextAlign.start,
                  style: dataStyle
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}