import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class CoordinateWidget extends StatelessWidget {
  final String lat;
  final String lng;

  CoordinateWidget({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Colors.black.withOpacity(0.2),
      child: TextFormField(
        readOnly: true,
        enabled: false,
        obscureText: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff626a76),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.PRIMARY_COLOR,
              width: 1.0,
            ),
          ),
          labelText: 'lat: $lat, lng: $lng',
          labelStyle: TextStyle(
            color: Color(0xff626a76),
            fontFamily: 'opensans',
          ),
          focusColor: AppColors.PRIMARY_COLOR,
          alignLabelWithHint: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
            fontFamily: 'opensans',
            color: AppColors.PRIMARY_COLOR,
            fontSize: 13.0),
      ),
      );
  }
}
