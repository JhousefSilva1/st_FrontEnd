import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttolls/style/app_style.dart';

class CustomField extends StatelessWidget {
    final double borderRadius;
  final bool? enabled;
  final String? hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final bool obscureText;
  final ValueChanged? onChanged;
  final GestureTapCallback? onTap;
  final Widget? prefixIcon;
  final FormFieldValidator? validator;
  final double? width;
  
  const CustomField({
    super.key,
    this.borderRadius = 8,
    this.enabled = true,
    this.hintText,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.label,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.validator,
    this.width = double.infinity
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: width,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppStyle.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enabled!? AppStyle.primary: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          filled: true,
          fillColor: AppStyle.ligthGrey,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(color: AppStyle.primary),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppStyle.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          hintText: hintText ?? '',
          labelStyle: const TextStyle(color: AppStyle.primary),
          labelText: hintText ?? '',
          prefixIcon: prefixIcon,
          prefixIconColor: AppStyle.primary,
        ),
        enabled: enabled,
        inputFormatters: inputFormatters ?? [],
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
      )
    );
  }
}