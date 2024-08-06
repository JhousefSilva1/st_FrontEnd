import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class AssetsImages{
    static Widget getImage({
    double? height,
    String? ext = 'png',
    double? width,
    required String path
  }){
    if(ext == 'svg'){
      return SvgPicture.asset(
        path,
        height: height,
        width: width,
      );
    }
    return Image.asset(
      path,
      height: height,
      width: width,
    );
  }

  static Widget logo({double? height, double? width}){
    return getImage(
      ext: 'png',
      path: 'assets/logo.png',
      height: height,
      width: width
    );
  }

  static Widget map({double? height, double? width}){
    return getImage(
      ext: 'png',
      path: 'assets/map.png',
      height: height,
      width: width
    );
  }
}