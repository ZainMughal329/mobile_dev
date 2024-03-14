import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardNotifier extends ChangeNotifier {

  String? role;


  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
    print(role);
  }
}
