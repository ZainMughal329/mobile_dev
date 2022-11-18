import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:lesedi/Dashboard.dart';
import 'package:lesedi/app_color.dart';
import 'package:lesedi/auth/ForgotPassword.dart';
import 'package:lesedi/auth/Signup.dart';
import 'package:lesedi/applicants/allApplicants.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/global.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/globals.dart' as global;
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:adobe_xd/blend_mask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../example.dart';
import 'Login.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

//PDF147
class _ResetPasswordState extends State<ResetPassword> {

  String brand_name;
  String logo;
  FocusNode _focusNode;
  FocusNode _focusNodePassword;
  String _translation;

  bool _isLoading = false;
  bool _isSecure = true;
  bool _isSecureconfirm = true;
  TextEditingController tokenNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  SharedPreferences prefs;
  String _checkUserAuthImage;

  Future<Null> _getUserAuthImage() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkUserAuthImage = prefs.getString("favicon_logo_square");
//      print('hi');
//      print(_checkUserAuthImage);
    });
  }
  void signUpClicked() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (tokenNumberController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        if (passwordController.text  == confirmpasswordController.text){
          signUp(tokenNumberController.text, passwordController.text);
        }
        else {
          setState(() {
            _isLoading = false;
          });
          showToastMessage(
            "Password Not Match!",
          );
        }
    } else {
      setState(() {
        _isLoading = false;
      });
      showToastMessage(
        "Please enter password and token number!",
      );
    }
  }

  Future<Null> signUp(String email, pass) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('okay');

    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/reset_password?reset_password_token=$email&password=$pass"));
    print(response.body);
//    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = json.decode(response.body);


      setState(() {
        print('done');

        if (jsonResponse['message']=='password updated successfully'){
          _isLoading = false;
//      print(token);
          showToastMessage('Password Updated Successfully');

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => new Login()));
        }
        else {
          _isLoading = false;
          showToastMessage('Please Insert Valid Token!');
        }


      });
    } else {
      setState(() {
        _isLoading = false;
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNodePassword = FocusNode();
    _getUserAuthImage();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
//      FocusScope.of(context).requestFocus(_focusNodePassword);
    });
  }

  void _requestFocusPassword() {
    setState(() {
//      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(_focusNodePassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Welcome to Flutter',
      home: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/Login.png"),
              fit: BoxFit.cover,
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
//
          body: Container(
            /// Set Background image in splash screen layout (Click to open code)
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage('assets/images/Splash.png'), fit: BoxFit.contain)),
            child: Container(
              /// Set gradient black in image splash screen (Click to open code)
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0)
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter)),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 80.0),
                        ),

                        Container(
//                          height: 70,
//                          width: 150,

                            child:
                            // global.favicon_logo_square!=null? Image.network(global.favicon_logo_square ,
                            //   width: 200,
                            // ):
                            Image.asset('assets/images/logo_lesedi.png',
                              width: 200,
                            )

//
//                        child: CachedNetworkImage(
//                          placeholder: (context, url) => CircularProgressIndicator(),
//                            errorWidget: (context, url, error) => Image.asset('assets/images/Group_81.png'),
//                          imageUrl:global.favicon_logo_square,
//                          height: 70,
//                                        width: 100,
//                                        fit: BoxFit.fitWidth,
//                        )

//                          child:global.favicon_logo_square != null
//                              ? CachedNetworkImage(
//                            placeholder: (context, url) => CircularProgressIndicator(),
//                            errorWidget: (context, url, error) => Image.asset('assets/images/Group_81.png'),
////                                        height: 70,
////                                        width: 100,
////                                        fit: BoxFit.fitWidth,
//                            imageUrl:global.favicon_logo_square,
//                          )
//                              : Image(image: AssetImage('assets/images/Group_81.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0),
                        ),

//                / Text header "Welcome To" (Click to open code)
                        Text(
                          'Reset Password'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 22,
                            color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20, top: 40),
                          child: new TextFormField(
                            obscureText: false,
                            controller: tokenNumberController,
                            decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xff626a76),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                      width: 1.0),
                                ),
                                labelText: 'Token Number',
                                labelStyle: new TextStyle(
                                    color: const Color(0xff626a76),
                                    fontFamily: 'opensans'),
                                focusColor: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(4.0),
                                    borderSide: new BorderSide(
                                        color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                                fontFamily: 'opensans',
                                color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                fontSize: 13.0),
                          ),
                        ),

                        /// Text header "Welcome To" (Click to open code)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20),
                          child: new TextFormField(
//                            autofocus: true,
                            controller: passwordController,

//                            onTap: _requestFocusPassword,
                            obscureText: _isSecure ? true : false,
                            decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xff626a76),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                      width: 1.0),
                                ),
                                labelText: 'Password',
                                labelStyle: new TextStyle(
                                    color: const Color(0xff626a76),
                                    fontFamily: 'opensans'),
                                focusColor: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                alignLabelWithHint: true,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_isSecure == false) {
                                        _isSecure = true;
                                      } else {
                                        _isSecure = false;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    size: 18.0,
                                    color: const Color(0xff626a76),
                                  ),
                                ),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(4.0),
                                    borderSide: new BorderSide(
                                        color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                                fontFamily: 'opensans',
                                color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                fontSize: 13.0),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 10),
                          child: new TextFormField(
//                            autofocus: true,
                            controller: confirmpasswordController,

//                            onTap: _requestFocusPassword,
                            obscureText: _isSecureconfirm ? true : false,
                            decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xff626a76),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                      width: 1.0),
                                ),
                                labelText: 'Confirm Password',
                                labelStyle: new TextStyle(
                                    color: const Color(0xff626a76),
                                    fontFamily: 'opensans'),
                                focusColor: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                alignLabelWithHint: true,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_isSecureconfirm == false) {
                                        _isSecureconfirm = true;
                                      } else {
                                        _isSecureconfirm = false;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    size: 18.0,
                                    color: const Color(0xff626a76),
                                  ),
                                ),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(4.0),
                                    borderSide: new BorderSide(
                                        color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                                fontFamily: 'opensans',
                                color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                fontSize: 13.0),
                          ),
                        ),






                        InkWell(

                            onTap: () {
                              if (!_isLoading) {
                                signUpClicked();
                              }
                            },
                            child: _isLoading
                                ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 50, left: 50),
                              child: Container(
                                height: 50.0,
                                padding: EdgeInsets.only(top: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x1a000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: CircularProgressIndicator(
                                  valueColor:
                                  new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 50, left: 50),
                              child: Container(

                                height: 50.0,
                                padding: EdgeInsets.only(top: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x1a000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 16,
                                    color: const Color(0xffffffff),
                                    letterSpacing: 0.152,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Container(
                            width: 150,
                            height: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            if (!_isLoading) {
                              Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => Login()));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Container(
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 14,
                                    color: const Color(0xff4d4d4d),
                                  ),
                                  children: [
//                                    TextSpan(
//                                      text: ' ',
//                                    ),
                                    TextSpan(
                                      text: 'Back to Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )

                        /// Animation text Treva Shop to choose Login with Hero Animation (Click to open code)
//                      Hero(
//                        tag: "Treva",
//                        child: Text(
//                          AppLocalizations.of(context).tr('title'),
//                          style: TextStyle(
//                            fontFamily: 'Sans',
//                            fontWeight: FontWeight.w900,
//                            fontSize: 35.0,
//                            letterSpacing: 0.4,
//                            color: Colors.white,
//                          ),
//                        ),
//                      )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
