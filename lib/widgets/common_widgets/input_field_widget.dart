import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesedi/utils/app_color.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hasSuffix = false,
    this.enable = true,
    this.isObscure = false,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.validator,
    this.horizontalPadding = 50,
    this.verticalPadding = 20,
    this.onChange,
    this.textInputType = TextInputType.text,
    this.textInputFormatter,
  });

  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final TextEditingController controller;
  final String label;
  final bool hasSuffix;
  final bool isObscure;
  final bool enable;
  final Widget? suffixIcon;
  final Function(String val)? validator;
  final TextInputType textInputType;
  final double horizontalPadding;
  final Function(String val)? onChange;
  final List<TextInputFormatter>? textInputFormatter;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: new TextFormField(
        obscureText: isObscure,
        controller: controller,
        enabled: enable,
        inputFormatters: textInputFormatter ?? [],
        decoration: new InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xff626a76), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.0),
            ),
            labelText: label,
            labelStyle: new TextStyle(
                color: const Color(0xff626a76), fontFamily: 'opensans'),
            focusColor: AppColors.PRIMARY_COLOR,
            alignLabelWithHint: true,
            fillColor: Colors.white,
            suffixIcon: !hasSuffix
                ? Container(
                    height: 10,
                    width: 10,
                  )
                : suffixIcon ??
                    Container(
                      height: 10,
                      width: 10,
                    ),
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(4.0),
                borderSide: new BorderSide(color: Colors.blue.shade700)),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        keyboardType: textInputType,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        style: new TextStyle(
            fontFamily: 'opensans',
            color: AppColors.PRIMARY_COLOR,
            fontSize: 13.0),
        validator: (val) {
          if (validator != null) {
            validator!(val!);
          }
          return null;
        },
        onChanged: (val) {
          if (onChange != null) {
            onChange!(val);
          }
        },
      ),
    );
  }
}
