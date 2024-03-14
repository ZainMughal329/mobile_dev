import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lesedi/auth/login/view/login_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ResetPasswordNotifier extends ChangeNotifier {
  String? brand_name;
  String? logo;
  FocusNode focusNode = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  bool isLoading = false;
  bool isSecure = true;
  bool isResetSecure = true;
  bool isSecureConfirm = true;
  TextEditingController tokenNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  SharedPreferences? prefs;
  String? checkUserAuthImage;

  setLoading(bool val){
    isLoading=val;
    notifyListeners();
  }

  setSecure(){
    isSecure=!isSecure;
    notifyListeners();
  }
  setResetSecure(){
    isResetSecure=!isResetSecure;
    notifyListeners();
  }

  Future getUserAuthImage() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    checkUserAuthImage = prefs.getString("favicon_logo_square");
    notifyListeners();
  }

  void resetPasswordClicked({required BuildContext context}) async {
    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (tokenNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (passwordController.text == confirmPasswordController.text) {
        resetPassword(token: tokenNumberController.text,pass:  passwordController.text,context: context);
      } else {
      setLoading(false);
        showToastMessage(
          "Password Not Match!",
        );
      }
    } else {
      setLoading(false);

      showToastMessage(
        "Please enter password and token number!",
      );
    }
  }

  Future resetPassword({required String token,required String pass,required BuildContext context}) async  {
    setLoading(true);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('okay');

    var jsonResponse;
    http.Response response = await http.put(Uri.parse(
        "${MyConstants.myConst.baseUrl}api/v1/users/reset_password?reset_password_token=$token&password=$pass"));
    print(response.body);
//    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = json.decode(response.body);


        if (jsonResponse['message'] == 'password updated successfully') {
          setLoading(false);
          showToastMessage('Password Updated Successfully');

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => new Login()));
        } else {
          setLoading(false);
          showToastMessage('Please Insert Valid Token!');
        }

    } else {

        setLoading(false);
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));

    }
  }
}
