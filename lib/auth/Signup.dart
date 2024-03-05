import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:lesedi/Dashboard.dart';
import 'package:lesedi/auth/Login.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/global.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/globals.dart' as global;
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:adobe_xd/blend_mask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../app_color.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  String? _translation;
  String? roleHolder;
  bool _isSecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  var role;

  void signUpClicked() async {
    print(_translation);

    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (_translation != null) {
        signUp(emailController.text, passwordController.text,
            usernameController.text, cellPhoneController.text);
      } else {
        setState(() {
          _isLoading = false;
        });
        showToastMessage("Please enter role");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showToastMessage(
        "Please enter password and email!",
      );
    }
  }

  Future<Null> signUp(String email, pass, username,cellPhone) async {
    print(_translation);
    setState(() {
      _isLoading = true;
      if (_translation == 'Field Worker'){
        setState(() {
          roleHolder = 'field_worker';
          print(roleHolder);
        });

      }
      else if (_translation == 'Reviewer'){
        roleHolder = 'reviewer';

      }
      else if (_translation == 'Supervisor'){
        roleHolder = 'supervisor';

      }

    });
    print(_translation);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('okay');
    Map data = {
      'email': email,
      'password': pass,
      'username': username,
      'cellphone_number':cellPhone,
      'role': roleHolder,
//      'role': _selectedType
    };
    var jsonResponse;
    http.Response response = await http
        .post(Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/register"), body: data);
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
//      sharedPreferences.setBool('login', true);
      var userID = sharedPreferences.getString('userID');
      print(userID);

//      showToastMessage('Some thing Went Wrong try later');
      setState(() {
        print('done');

        _isLoading = false;
//      print(token);
        showToastMessage("Please Contact your admin first.");

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new Login()));
      });
    } else {
      setState(() {
        _isLoading = false;
        jsonResponse = json.decode(response.body);
        print('data');
        print(jsonResponse['password']);
        showToastMessage(
            jsonResponse.toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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

                      child:
                      // Image.asset(
                      //   'assets/images/moiloa.png',
                      //   width: 250,
                      // ),
                      // global.favicon_logo_square!=null? Image.network(global.favicon_logo_square ,
                      //   width: 200,
                      // ):
                      Image.asset('assets/images/emfuleni.jpg',
                        width: 200,
                      )
                  ),


//                         Container( //lesidi && modimolw
// //                          height: 70,
// //                          width: 150,
//                           child:
// //                           global.favicon_logo_square != null
// //                               ? CachedNetworkImage(
// //                             placeholder: (context, url) => CircularProgressIndicator(),
// //                             errorWidget: (context, url, error) => Image.asset('assets/images/logo.jpg'),
// // //                                        height: 70,
// //                                         width: 200,
// // //                                        fit: BoxFit.fitWidth,
// //                             imageUrl:global.favicon_logo_square,
// //                           )
// //                               :
//                           Image(image: AssetImage('assets/images/mLogo.png') , width: 200,),
//                         ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),

//                / Text header "Welcome To" (Click to open code)
                        Text(
                          'SIGNUP',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 22,
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20, top: 30),
                          child: Container(
                            height: 50,
                            child: new TextFormField(
                              controller: usernameController,
                              obscureText: false,
                              decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xff626a76),
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.PRIMARY_COLOR,
                                        width: 1.0),
                                  ),
                                  labelText: 'Name',
                                  labelStyle: new TextStyle(
                                      color: const Color(0xff626a76),
                                      fontFamily: 'opensans'),
                                  focusColor: AppColors.PRIMARY_COLOR,
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      borderSide: new BorderSide(
                                          color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),
                              validator: (val) {
                                if (val?.length == 0) {
                                  return "Email Cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20, top: 0),
                          child: Container(
                            height: 50,
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
                                        color: AppColors.PRIMARY_COLOR,
                                        width: 1.0),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: new TextStyle(
                                      color: const Color(0xff626a76),
                                      fontFamily: 'opensans'),
                                  focusColor: AppColors.PRIMARY_COLOR,
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      borderSide: new BorderSide(
                                          color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),
                            ),
                          ),
                        ),

                        /// Text header "Welcome To" (Click to open code)

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20),
                          child: Container(
                            height: 50,
                            child: new TextFormField(
                              controller: cellPhoneController,
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
                                        color: AppColors.PRIMARY_COLOR,
                                        width: 1.0),
                                  ),
                                  labelText: 'Cell Number',
                                  labelStyle: new TextStyle(
                                      color: const Color(0xff626a76),
                                      fontFamily: 'opensans'),
                                  focusColor: AppColors.PRIMARY_COLOR,
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      borderSide: new BorderSide(
                                          color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                              keyboardType: TextInputType.phone,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 10),
                          child: Container(
                            height: 50,
                            child: new TextFormField(
//                            autofocus: true,
                              controller: passwordController,
                              obscureText: _isSecure ? true : false,

//                            onTap: _requestFocusPassword,
                              decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xff626a76),
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.PRIMARY_COLOR,
                                        width: 1.0),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: new TextStyle(
                                      color: const Color(0xff626a76),
                                      fontFamily: 'opensans'),
                                  focusColor: AppColors.PRIMARY_COLOR,
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
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
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      borderSide: new BorderSide(
                                          color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 10, top: 10),
                          child: Container(
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.black,
                              ),
//              itemHeight: 60,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),

                              decoration: InputDecoration(
//                              isDense: true,
//                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xff626a76),
                                      width: 1.0),
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0.0),
                                labelStyle: new TextStyle(
                                    color: const Color(0xff626a76),
                                    fontFamily: 'opensans'),
//                                labelText: 'Role',
                              ),
                              items: <String>[
                                'Select Role',
                                'Field Worker',
                                'Reviewer',
                                'Supervisor'
                              ].map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: new Text(
                                          val.toString(),
                                          style: TextStyle(
                                            color: const Color(0xff626a76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              value: _translation != null
                                  ? _translation
                                  : "Select Role",

                              validator: (value) => value == null ||
                                      value == 'Please select a role'
                                  ? 'role type required'
                                  : null,
                              onChanged: (newVal) {
//
                                _translation = newVal??"";

                                print(_translation);

//                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(
                                  () {},
                                );
                              },
                            ),
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
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: AppColors.PRIMARY_COLOR,
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
                                        color: AppColors.PRIMARY_COLOR,
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
                              color: AppColors.PRIMARY_COLOR,
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
                        ),
                        SizedBox(height: 20,)

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
