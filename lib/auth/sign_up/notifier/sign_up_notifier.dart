import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/auth/login/view/login_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUpNotifier extends ChangeNotifier {
  bool isLoading = false;
  String? translation;
  String? roleHolder;
  bool isSecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  var role;

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  setSecure() {
    isSecure = !isSecure;
    notifyListeners();
  }
  setTranslation(String val)
  {
    translation=val;
    notifyListeners();
  }

  void signUpClicked({required BuildContext context}) async {
    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (translation != null) {
        signUp(
          email: emailController.text,
          pass: passwordController.text,
          username: usernameController.text,
          cellPhone: cellPhoneController.text,
          context: context,
        );
      } else {
        setLoading(false);
        showToastMessage("Please enter role");
      }
    } else {
      setLoading(false);

      showToastMessage(
        "Please enter password and email!",
      );
    }
  }

  Future signUp({
    required String email,
    required String pass,
    required String username,
    required String cellPhone,
    required BuildContext context,
  }) async {
    print(translation);
    setLoading(true);

    if (translation == 'Field Worker') {
      roleHolder = 'field_worker';
      print(roleHolder);
    } else if (translation == 'Reviewer') {
      roleHolder = 'reviewer';
    } else if (translation == 'Supervisor') {
      roleHolder = 'supervisor';
    }

    // });
    print(translation);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('okay');
    Map data = {
      'email': email,
      'password': pass,
      'username': username,
      'cellphone_number': cellPhone,
      'role': roleHolder,
//      'role': _selectedType
    };
    try{
      var jsonResponse;
      http.Response response = await http.post(
          Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/register"),
          body: data);
      print(response.body);
      print(data);
      if (response.statusCode == 200) {
        print('sss');
        jsonResponse = json.decode(response.body);
        print(jsonResponse);

        sharedPreferences.setString("userID", jsonResponse['uuid']);
        sharedPreferences.setString('auth-token', jsonResponse['Authentication']);
        sharedPreferences.setString('email', jsonResponse['email']);
        sharedPreferences.setString('role', jsonResponse['role']);
        var userID = sharedPreferences.getString('userID');
        print(userID);
        print('done');

        setLoading(false);
        showToastMessage("Please Contact your admin first.");

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => new Login()));
      } else {
        setLoading(false);
        jsonResponse = json.decode(response.body);
        print('data');
        print(jsonResponse['password']);
        showToastMessage(jsonResponse.toString().replaceAll("[\\[\\](){}]", ""));
      }
    }
    on SocketException catch (e) {
      Fluttertoast.showToast(msg: "Internet not available");
      print('dsa');
      print(e);
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('dsa');
      print(e);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print('dsa');
      print(e);
    }

    notifyListeners();
  }
}
