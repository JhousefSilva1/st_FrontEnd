import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({super.key, required this.current, this.height = 2, this.isFirst = false, this.isSecond = false, this.isThree = false});
  final double current;
  final double height;
  final bool isFirst;
  final bool isSecond;
  final bool isThree;

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
                width: x * .3,
                height: height,
                decoration: BoxDecoration(
                  color: AppStyle.primary,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
            Positioned(
              left: x * .32,
              child: Container(
                width: x * .3,
                height: height,
                decoration: BoxDecoration(
                  color: isSecond || isThree? AppStyle.primary: AppStyle.primaryLigth,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
            Positioned(
              left: x * .64,
              child: Container(
                width: x * .65,
                height: height,
                decoration: BoxDecoration(
                  color:  isThree? AppStyle.primary: AppStyle.primaryLigth,
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