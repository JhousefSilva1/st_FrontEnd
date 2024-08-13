import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.actions, this.backgroundColor, this.centerTitle = false, this.iconThemeData, this.leading, required this.text, this.textStyle});
  final Color? backgroundColor;
  final bool centerTitle;
  final IconThemeData? iconThemeData;
  final IconButton? leading;
  final String text;
  final TextStyle? textStyle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: leading == null? true:false,
      actions: actions,
      backgroundColor: backgroundColor?? AppStyle.primary,
      centerTitle: centerTitle,
      elevation: 0,
      title: Text(
        text,
        style: textStyle ?? const TextStyle(color: Colors.white),
      ),
      iconTheme: iconThemeData ?? const IconThemeData(color: Colors.white),
      leading: leading,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}