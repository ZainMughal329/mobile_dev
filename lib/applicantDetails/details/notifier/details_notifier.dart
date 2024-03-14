import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lesedi/utils/Constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingReject = false;
  var role;

  bool isVisible = true;


  setLoading(bool val)
  {
    isLoading=val;
    notifyListeners();
  }
  setLoadingReject(bool val)
  {
    isLoadingReject=val;
    notifyListeners();
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
    print(role);
  }

  reviewedApplicant() async {
    setLoading(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${widget.id}&accepted=true"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);

      setLoading(false);

    } else {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
    }
    notifyListeners();
  }

  removeReviewedApplicant({required String applicationId}) async {
    setLoadingReject(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${applicationId}&accepted=false"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);

      setLoadingReject(false);

    } else {

        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
        setLoadingReject(true);

    }
    notifyListeners();
  }
}
