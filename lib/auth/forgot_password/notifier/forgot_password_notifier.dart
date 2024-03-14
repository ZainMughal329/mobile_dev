import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesedi/auth/reset_password_view/view/reset_password.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isSecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  setSecure() {
    isSecure = !isSecure;
    notifyListeners();
  }


  void signUpClicked({required BuildContext context}) async {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      signUp(email: emailController.text, pass: passwordController.text,context: context);
    } else {
      setLoading(false);
      showToastMessage(
        "Please enter email or phone number",
      );
    }
  }

  Future<Null> signUp({required String email,required String pass,required BuildContext context}) async {
    setLoading(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('okay');
    Map data = {
      'email': email,
      'cellphone_number':pass
    };
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/forgot_password?email=$email"));
    print(response.body);
    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = json.decode(response.body);
      /// only message is returning from response
      // print("jsonResponse $jsonResponse");
      // sharedPreferences.setString("userID", jsonResponse['uuid']);
      // sharedPreferences.setString('auth-token', jsonResponse['Authentication']);
      // sharedPreferences.setString('email', jsonResponse['email']);
      // var userID = sharedPreferences.getString('userID');
      // print(userID);

      setLoading(false);
        showToastMessage(jsonResponse['message']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => new ResetPassword()));

    } else {
      setLoading(false);
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));

    }
    notifyListeners();
  }
}
