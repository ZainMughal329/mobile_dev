import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:rustenburg/app_color.dart';
import 'package:rustenburg/auth/Login.dart';
import 'package:rustenburg/auth/resetPassword.dart';
import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/global.dart';
import 'package:flutter/material.dart';
import 'package:rustenburg/globals.dart' as global;
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:adobe_xd/blend_mask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;
  bool _isSecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signUpClicked() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      signUp(emailController.text, passwordController.text);
    } else {
      setState(() {
        _isLoading = false;
      });
      showToastMessage(
        "Please enter email or phone number",
      );
    }
  }

  Future<Null> signUp(String email, pass) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('okay');
    Map data = {
      'email': email,
    'cellphone_number':pass
//      'username': 'abc'
//      'role': _selectedType
    };
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/forgot_password?email=$email"));
    print(response.body);
    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = json.decode(response.body);
//      showToastMessage('Some thing Went Wrong try later');
      sharedPreferences.setString("userID", jsonResponse['uuid']);
      sharedPreferences.setString('auth-token', jsonResponse['Authentication']);
      sharedPreferences.setString('email', jsonResponse['email']);
      var userID = sharedPreferences.getString('userID');
      print(userID);

      setState(() {
        print('done');

        _isLoading = false;
//      print(token);
        showToastMessage(jsonResponse['message']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => new ResetPassword()));
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
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Welcome to Flutter',
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Login.png"),
                fit: BoxFit.cover)),
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

                      child:Image.asset(
                        'assets/images/logo.jpg',
                        width: 250,
                      ),
                      // global.favicon_logo_square!=null? Image.network(global.favicon_logo_square ,
                      //   width: 200,
                      // ):
                      // Image.asset('assets/images/logo.jpg',
                      //   width: 200,
                      // )
                  ),

//                         Container( // lesedi && modimole
// //                          height: 70,
// //                          width: 150,
//                           child:Image(image: AssetImage('assets/images/mLogo.png') , width: 200,)
// //                           global.favicon_logo_square != null
// //                               ? CachedNetworkImage(
// //                             placeholder: (context, url) => CircularProgressIndicator(),
// //                             errorWidget: (context, url, error) => ,
// // //                                        height: 70,
// //                                         width: 200,
// // //                                        fit: BoxFit.fitWidth,
// //                             imageUrl:global.favicon_logo_square,
// //                           )
// //                               : Image(image: AssetImage('assets/images/mLogo.png') , width: 200,),
//                         ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0),
                        ),

//                / Text header "Welcome To" (Click to open code)
                        Text(
                          'FORGOT PASSWORD',
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
                            controller: passwordController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                            obscureText: false,
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
                                labelText: 'Cell Number',
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
                                        color: Colors.blue[700])),
                                floatingLabelBehavior: FloatingLabelBehavior.auto),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                                fontFamily: 'opensans',
                                color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
                                fontSize: 13.0),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50, bottom: 20, top: 0),
                          child: Text('OR' ,style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ), )
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20, top: 0),
                          child: new TextFormField(
                            obscureText: false,
                            controller: emailController,
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
                                labelText: 'Email',
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
                                  )),

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
                                    TextSpan(
                                      text: 'I Have Already Account ? ',
                                    ),
                                    TextSpan(
                                      text: 'Login',
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
