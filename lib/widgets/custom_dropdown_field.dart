import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class CustomDropdownfield extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextEditingController? controller;
  final IconData? icon;
  final IconData? suffixIcon;
  final Widget? suffixIconButton;
  final Widget? iconButton;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Function(dynamic)? onChanged;
  final FormFieldValidator? validator;
  final GestureTapCallback? onTap;
  final String? label;
  final Color? fillColor;
  final bool? filled;
  final bool autofocus;
  final double? width;
  final double? height;
  final List<DropdownMenuItem<Object>>? items;
  final Object? value;
  final bool? disable;

  const CustomDropdownfield(
      {super.key,
      this.initialValue,
      this.hintText,
      this.labelText,
      this.helperText,
      this.controller,
      this.icon,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.onChanged,
      this.validator,
      this.onTap,
      this.fillColor = Colors.white,
      this.filled = true,
      this.obscureText = false,
      this.readOnly = false,
      this.label = '',
      this.width,
      this.autofocus = false,
      this.height,
      this.suffixIconButton,
      this.iconButton,
      this.items,
      this.value,
      this.disable=false});

  @override
  State<CustomDropdownfield> createState() => _CustomDropdownfieldState();
}

class _CustomDropdownfieldState extends State<CustomDropdownfield> {
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            onFocusChange: ((value) {
              setState(() {
                focused = value;
              });
            }),
            child: DropdownButtonFormField(
              icon: widget.iconButton,
              value: widget.value,
              autofocus: widget.autofocus,
              onChanged: widget.disable==false? widget.onChanged: null,
              validator: widget.validator,
              onTap: widget.onTap,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppStyle.primary),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppStyle.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 10.0),
                filled: widget.filled,
                fillColor: widget.fillColor,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: widget.hintText,
                labelText: widget.label ?? '',
                helperText: widget.helperText,
                prefixIcon:
                    widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
                suffixIcon: widget.suffixIcon == null
                    ? widget.suffixIconButton
                    : Icon(widget.suffixIcon),
                icon: widget.icon == null ? null : Icon(widget.icon),
              ),
              items: widget.items,
            ),
          ),
        ],
      ),
    );
  }
}
