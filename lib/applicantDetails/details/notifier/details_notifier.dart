import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lesedi/model/occupant_and_spouse_model.dart';
import 'package:lesedi/model/applicant_info_model.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingReject = false;
  String role = '';

  bool isVisible = true;
  ApplicantInfo? models;
  OccupantAndSpouseModel? occupantAndSpouseModel;

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  setLoadingReject(bool val) {
    isLoadingReject = val;
    notifyListeners();
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role')!;
    print(role);
  }

  reviewedApplicant({required int applicationId}) async {
    setLoading(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    try {
      http.Response response = await http.put(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${applicationId}&accepted=true"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
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
    } on SocketException catch (e) {
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

  removeReviewedApplicant({required int applicationId}) async {
    setLoadingReject(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    try {
      http.Response response = await http.put(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${applicationId}&accepted=false"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
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
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: "Internet not available");
      print('dsa');
      print(e);
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Bad Request");
      print('dsa');
      print(e);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print('dsa');
      print(e);
    }

    notifyListeners();
  }

  getApplicantDetails({required int applicationId}) async {
    // ApplicantInfo responseM;
    log("api is called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = await sharedPreferences.getString('userID');
    var authToken = await sharedPreferences.getString('auth-token');
    var jsonResponse;
    try {
      print("MyConstants.myConst.baseUrl ==> ${MyConstants.myConst.baseUrl}");
      http.Response response = await http.get(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/review?application_id=$applicationId"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
          });
      log("body => ${response.body}");
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        Map<String, dynamic> dataHolder = jsonResponse;
        // log("jsonResponse => $jsonResponse");
        var dataSort = dataHolder.values.toList();

        print(dataSort);

        print("bank json is ${dataHolder["bank_details_attributes"]}");
        ApplicantInfo data = ApplicantInfo.fromJson(dataHolder);
        OccupantAndSpouseModel occupantAndSpouseData = OccupantAndSpouseModel.fromJson(dataHolder);
        models = data;
        occupantAndSpouseModel = occupantAndSpouseData;

        log("jsonResponse => ${models?.bankDetails}");

        isVisible = true;
        print('name');
      } else {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      }
      print("detail of bank == > ${models?.bankDetails} ");
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: "Internet not available");
      print('dsa');
      print(e);
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Bad Request");
      print('dsa');
      print(e);
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateApplication({
    required String remarks,
    required String userRole,
    required int applicationId,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');

    Map<String, dynamic> data = {
      'application_id': applicationId,
      'remarks': remarks,
      'user_type': userRole,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID ?? "",
          'Authentication': authToken ?? "",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        showToastMessage(jsonResponse['message']);
      } else {
        var jsonResponse = json.decode(response.body);
        showToastMessage(
          jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""),
        );
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: "Internet not available");
      print(e);
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Bad Request");
      print(e);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }
}
