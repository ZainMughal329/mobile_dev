import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
//      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(30, 30, 30, 0.6),
      textColor: Colors.white
  );
}

void showCustomDialog({context = BuildContext, child = Widget}) {
  showDialog(
      context: context as BuildContext,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          child as Widget
        ],
      )
  );
}
