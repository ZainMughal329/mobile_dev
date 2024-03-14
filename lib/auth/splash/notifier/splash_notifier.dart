import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/auth/login/view/login_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lesedi/utils/globals.dart' as global;


class SplashNotifier extends ChangeNotifier {
  String? SplashImage;

  /// Declare startTime to InitState
  ServicesRequest servicesRequest = ServicesRequest();

  /// Setting duration in splash screen
  startTime({required BuildContext context}) async {
    return await new Timer(Duration(milliseconds: 6500),()=> NavigatorPage(context: context));
  }

  /// To navigate layout change
  Future<void> NavigatorPage({required BuildContext context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLogin = sharedPreferences.getBool('login');
    var role = sharedPreferences.getString('role');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    if (isLogin != null && isLogin) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => Dashboard(userRole: role??"",applicant_id:  applicant_id??0)));
    } else {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => Login()));
    }
  }

  getTenant() async {
    Response res = await get(
      Uri.parse('${MyConstants.myConst.baseUrl}api/v1/settings/1'),
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


        global.company_name = responseJson['splash_screen'];

      sharedPreferences.setString(
          SplashImage ?? "", responseJson['splash_screen']);
      print('working');
      print(global.company_name);
      notifyListeners();
    }

    notifyListeners();
  }

  init({required BuildContext context})async{
    getTenant();
    startTime(context: context);
    print('working');
    servicesRequest.ifInternetAvailable();
    LocalStorage.localStorage.getApplicationsList();
    print('working again');
    print(SplashImage);
  }
}
