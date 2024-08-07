import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key, required this.current, this.height = 2, this.hideFirst = false});
  final double current;
  final double height;
  final bool hideFirst;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        return Stack(
          children: [
            Container(
              width: x,
              height: height,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                width: x * .495,
                height: height,
                decoration: BoxDecoration(
                  color: hideFirst? AppStyle.primary: AppStyle.primaryLigth,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
            Positioned(
              left: x * .505,
              child: Container(
                width: x * .49,
                height: height,
                decoration: BoxDecoration(
                  color: current == 1? AppStyle.primary: AppStyle.primaryLigth,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}