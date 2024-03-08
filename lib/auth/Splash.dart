import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:lesedi/Dashboard.dart';
import 'package:lesedi/auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/helpers/utils.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lesedi/globals.dart' as global;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? SplashImage;
  // Request request =
  /// Declare startTime to InitState
  ServicesRequest servicesRequest = ServicesRequest();
  @override
  void initState() {
    super.initState();
    getTenant();
    startTime();
    print('working');
    servicesRequest.ifInternetAvailable();
    LocalStorage.localStorage.getApplicationsList();
    print('working again');
    print(SplashImage);
  }

  @override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 6500), NavigatorPage);
  }

  /// To navigate layout change
  Future<void> NavigatorPage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLogin = sharedPreferences.getBool('login');
    var role = sharedPreferences.getString('role');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    if (isLogin != null && isLogin) {
      // Utils.checkFormStatusAndSubmit();
      // print("Inside Splash Screen file, checkFormStatusAndSubmit called");
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => Dashboard(role, applicant_id)));
    } else {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => Login()));
    }
  }

  getTenant() async {
    setState(() {});
    Response res = await get(
      Uri.parse('${MyConstants.myConst.baseUrl}api/v1/settings/1'),
//        headers: {'Content-Type': 'application/json; charset=utf-8'}
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (res.statusCode == 200) {
      var responseJson = json.decode((utf8.decode(res.bodyBytes)));
      print(responseJson);

      print(responseJson['splash_screen']);

      sharedPreferences.setString(
          'brand_color_primary_action', responseJson['color'].trim());


      global.brand_color_primary_action =
          await sharedPreferences.getString("brand_color_primary_action");

      sharedPreferences.setString('favicon_logo_square', responseJson['logo']);

      global.favicon_logo_square =
          await sharedPreferences.getString("favicon_logo_square");

      setState(() {
        global.company_name = responseJson['splash_screen'];
      });
      sharedPreferences.setString(SplashImage??"", responseJson['splash_screen']);
      print('working');
      print(global.company_name);
    }

//    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image:
//                global.company_name!=null? CachedNetworkImageProvider(global.company_name):
                    AssetImage('assets/images/Login.png'),
                fit: BoxFit.fill)),
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
                      padding: EdgeInsets.only(top: 30.0),
                      child:
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child:
                        // Image.asset(
                        //   'assets/images/moiloa.png',
                        //   width: 250,
                        // ),
                        // global.company_name != null
                        //     ? CachedNetworkImage(
                        //   imageUrl: global.company_name,
                        //   width: 250,
                        // )
                        //     :
                        Image.asset(
                          // 'assets/images/emfuleni.jpg',
                          MyConstants.myConst.appLogo,
                          width: 250,
                        ),
                      ),
                      // global.company_name != null
                      //     ? CachedNetworkImage(
                      //         imageUrl: global.company_name,
                      //         width: 250,
                      //       )
                      //     :
                      // Image.asset( //lesedi && modimolle
                      //         'assets/images/mLogo.png',
                      //         width: 250,
                      //       ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
