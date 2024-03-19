import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/forms/marital_status/view/marital_status.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ApplicationStatusNotifier extends ChangeNotifier {

  ServicesRequest request = ServicesRequest();

  TextEditingController grossMonthlyController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  bool isLoading = false;
  bool? checked = true;
  bool? heckedUn = true;
  bool? checkedG = false;
  bool? checkedUn = false;
  bool? checkedEm = false;
  bool? checkedCh = false;
  bool? heckedDI = false;
  bool? checkedESM = false;
  bool? checkedDI = false;

  bool? checkedGMI = false;
  var grossMonthlyStorage;
  var remarksStorage;

  String checkBoxValue = 'pensioner';


  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
  checkInternetAvailability() async {
    await request.ifInternetAvailable();
   notifyListeners();

  }

  getCheckValues() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      if (checked == null) {
        checked = true;
        checked = sharedPreferences.getBool('_checked');
      }

      if (checkedG == null) {
        checkedG = false;
        checkedG = sharedPreferences.getBool('_checkedG');
      }

      if (checkedUn == null) {
        checkedUn = false;
        checkedUn = sharedPreferences.getBool('_checkedUn');
      }
      if (checkedEm == null) {
        checkedEm = false;
        checkedEm = sharedPreferences.getBool('_checkedEm');
      }
      if (checkedCh == null) {
        checkedCh = false;
        checkedCh = sharedPreferences.getBool('_checkedCh');
      }
      if (checkedESM == null) {
        checkedESM = false;
        checkedESM = sharedPreferences.getBool('_checkedESM');
      }
      if (checkedDI == null) {
        checkedDI = false;
        checkedDI = sharedPreferences.getBool('_checkedDI');
      }

      if (checkedGMI == null) {
        checkedGMI = false;
        checkedGMI = sharedPreferences.getBool('_checkedGMI');
      }

      grossMonthlyStorage = sharedPreferences.getString('grossMonthlyStorage');

      if (grossMonthlyStorage != null) {
        grossMonthlyController =
            TextEditingController(text: '$grossMonthlyStorage');
      }
      if (remarksStorage != null) {
        remarksController = TextEditingController(text: '$remarksStorage');
      }
    notifyListeners();
  }
  Future submitForm(checkBoxValue,previousFormSubmitted,applicant_id,context) async {
    setLoading(true);
    print("Previous Form Submitted ::::: ${previousFormSubmitted}");
    await request.ifInternetAvailable();
    // checkInternetAvailability();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    // print('okay');
    print("Applicant ID is ::: $applicant_id");
    print("Widget Applicant ID is ::: ${applicant_id}");
    // print('okay');
    Map<String, dynamic>? data = {
      'application_id': applicant_id,
      'employment_status': checkBoxValue,
      'gross_monthly_income': grossMonthlyController.text,
      'remarks': remarksController.text,
//      'role': _selectedType
    };

    LocalStorage.localStorage.saveFormData(data);
    var jsonResponse;
    http.Response response;
    if (MyConstants.myConst.internet ?? false) {
      if (previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application?application_id=${applicant_id}&employment_status=$checkBoxValue&gross_monthly_income=${grossMonthlyController.text}"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID??"",
              'Authentication': authToken??""
            });
      } else {
        data = LocalStorage.localStorage
            .getFormData(MyConstants.myConst.currentApplicantId??"");
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID??"",
              'Authentication': authToken??""
            },
            body: jsonEncode(data));
      }

      print(response.headers);
      print('sss');
      print(response.body);
      print(data);
      if (response.statusCode == 200) {
        LocalStorage.localStorage.clearCurrentApplication();
        print('sss');
        jsonResponse = jsonDecode(response.body);
        print('data hai');
        print(jsonResponse['message']);
        print(jsonResponse['application_id']);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('_checked', checked!);
        await prefs.setBool('_checkedG', checkedG!);
        await prefs.setBool('_checkedUn', checkedUn!);
        await prefs.setBool('_checkedEm', checkedEm!);
        await prefs.setBool('_checkedCh', checkedCh!);
        await prefs.setBool('_checkedDI', checkedDI!);
        await prefs.setBool('_checkedGMI', checkedGMI!);
        sharedPreferences.setString(
            "grossMonthlyStorage", grossMonthlyController.text);
        if (!previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          applicant_id = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data?['application_id']);
          applicant_id = data['application_id'];
        }
          print('done');

          setLoading(false);
          showToastMessage('Form Submitted');
          previousFormSubmitted = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new MaritalStatus(
                  applicant_id??0,
                  grossMonthlyController.text,
                  previousFormSubmitted)));
      } else {

          setLoading(false);
          jsonResponse = json.decode(response.body);
          print('data');
          showToastMessage(jsonResponse['message']);

      }
    } else {
      setLoading(false);

      print("ApplicationStatus Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new MaritalStatus(
              applicant_id??0,
              grossMonthlyController.text,
              previousFormSubmitted)));
    }
  }

  init(){
    print('daya');
    getCheckValues();
    checkInternetAvailability();
  }



}
