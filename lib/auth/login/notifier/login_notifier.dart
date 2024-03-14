import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  String? brand_name;
  String? logo;
  FocusNode focusNode = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  String? translation;

  bool isLoading = false;
  bool isSecure = true;
  TextEditingController emailController =
      TextEditingController(text: "hanan@gmail.com");
  TextEditingController passwordController =
      TextEditingController(text: "112233");
  SharedPreferences? prefs;
  String? _checkUserAuthImage;

  setLoading(bool val)
  {
    isLoading=val;
    notifyListeners();
  }

  setSecure()
  {
    isSecure=!isSecure;
    notifyListeners();
  }


  Future getUserAuthImage() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    _checkUserAuthImage = prefs.getString("favicon_logo_square");
    notifyListeners();
  }
  void signUpClicked({required BuildContext context}) async {
    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      signUp(email: emailController.text, pass: passwordController.text,context: context);
    } else {

        setLoading(false);

      showToastMessage(
        "Please enter password and email!",
      );
    }
  }

  Future signUp({required String email,required String pass,required BuildContext context}) async {
    setLoading(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('okay');
    Map data = {
      'email': email,
      'password': pass,
    };
    var jsonResponse;
    http.Response response = await http.get(
        Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/sign_in?email=$email&password=$pass&role='reviewer'"));
    print(response.body);
    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = json.decode(response.body);
      sharedPreferences.setString("userID", jsonResponse['uuid']);
      sharedPreferences.setString('auth-token', jsonResponse['Authentication']);
      sharedPreferences.setString('email', jsonResponse['email']);
      sharedPreferences.setString('role', jsonResponse['role']);
      var applicant_id = sharedPreferences.getInt('applicant_id');
      sharedPreferences.setBool('login', true);
      String? role = sharedPreferences.getString('role');

        print('done');

        setLoading(false);
        showToastMessage('SignIn successfully');

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new Dashboard(userRole: role??"" ,applicant_id: applicant_id??0)));
    } else {
      setLoading(false);
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
    }
    notifyListeners();
  }


  @override
  void dispose() {
    focusNode.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }
}
