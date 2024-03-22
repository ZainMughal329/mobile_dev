import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lesedi/applicants/widgets/gridview_widget.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/model/applicants.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllApplicantsNotifier extends ChangeNotifier {
  ServicesRequest request = ServicesRequest();
  bool? submitStatus;
  List<Map<String, dynamic>> mapData = <Map<String, dynamic>>[];
  bool isLoading = false;
  bool isSyncLoading = false;

  bool isVisible = true;

  List<NodoPOJO> models = [];

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
  setSyncLoading(bool val) {
    isSyncLoading = val;
    notifyListeners();
  }

  setVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  getLocalData() async {
    print("Get Local Data Called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var localData = sharedPreferences.getStringList('applicationIds');
    log('Local Data ::::  ${localData.toString()}');
    if (localData != null) {
      for (int i = 0; i < localData.length; i++) {
        var responseData = sharedPreferences.getString(localData[i]);
        if (responseData != null) {
          print("Each map saved ::: $responseData");
          mapData.add(json.decode(responseData));
        } else {
          print("${localData[i]} is null");
        }
      }
    }
    print(mapData);
    notifyListeners();
  }

  getAllApplicant() async {
    List<NodoPOJO> responseM = [];
    await request.ifInternetAvailable();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    if (MyConstants.myConst.internet ?? false) {
      setLoading(true);
      try{
        http.Response response = await http.get(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/all_applications"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID ?? "",
              'Authentication': authToken ?? ""
            });
        if (response.statusCode == 200) {
          jsonResponse = json.decode(response.body);

          List<dynamic> dataHolder = jsonResponse;
          print(jsonResponse);
          print('total length');
          print(dataHolder.length);
          for (int j = 0; j < dataHolder.length; j++) {
            var dataSort = dataHolder.toList()[j];
            NodoPOJO models = NodoPOJO.fromJson(dataSort);
            responseM.add(models);
            print(responseM[0].extremo1);
          }

          print('done');
          models = responseM;
          if (models.length == 0) {
            setVisibility();
          }
          setLoading(false);
        } else {
          jsonResponse = json.decode(response.body);
          print('data');
          setLoading(false);
          showToastMessage(
              jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
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

    }
    notifyListeners();
  }

  reviewedApplicant(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    try{    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=$id&accepted=true"),
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
      getAllApplicant();
      gridViewWidget(
        mapData: mapData,
        notifier: AllApplicantsNotifier(),
      );
    } else {
      jsonResponse = json.decode(response.body);
      print('data');
      showToastMessage(
          jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
    }}
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

  removeReviewedApplicant(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    try{

      http.Response response = await http.put(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=$id&accepted=false"),
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
        getAllApplicant();
        gridViewWidget(
          mapData: mapData,
          notifier: AllApplicantsNotifier(),
        );
      } else {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
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

  initFunction({required BuildContext context}) async {
    getLocalData();
    getAllApplicant();
  }
}
