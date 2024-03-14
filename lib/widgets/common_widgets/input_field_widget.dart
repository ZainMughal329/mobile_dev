import 'package:flutter/material.dart';
import 'package:lesedi/utils/app_color.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hasSuffix=false,
    this.isObscure=false,
    this.suffixIcon,
    this.validator,
    this.textInputType =TextInputType.text,
  });

  final TextEditingController controller;
  final String label;
  final bool hasSuffix;
  final bool isObscure;
  final Widget? suffixIcon;
  final Function(String val)? validator;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 50.0, right: 50, bottom: 20, top: 20),
      child: new TextFormField(
        obscureText:isObscure,
        controller: controller,

        decoration: new InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color(0xff626a76),
                  width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:AppColors.PRIMARY_COLOR,
                  width: 1.0),
            ),
            labelText: label,
            labelStyle: new TextStyle(
                color: const Color(0xff626a76),
                fontFamily: 'opensans'),
            focusColor:  AppColors.PRIMARY_COLOR,
            alignLabelWithHint: true,
            fillColor: Colors.white,
            suffixIcon:!hasSuffix?Container(
              height: 10,width: 10,
            ):suffixIcon??Container( height: 10,width: 10,),
            border: new OutlineInputBorder(
                borderRadius:
                new BorderRadius.circular(4.0),
                borderSide: new BorderSide(
                    color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),
        keyboardType: textInputType,
        style: new TextStyle(
            fontFamily: 'opensans',
            color:AppColors.PRIMARY_COLOR,
            fontSize: 13.0),
validator: (val){
          if(validator!=null)
            {
              validator!(val!);
            }
          return null;
},
      ),
    );
  }
}