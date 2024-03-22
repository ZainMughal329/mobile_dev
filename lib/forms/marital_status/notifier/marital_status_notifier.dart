import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/forms/attachments/view/attachments.dart';
import 'package:lesedi/forms/bank_account_details/view/bank_account_details.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MaritalStatusNotifier extends ChangeNotifier {

  ServicesRequest request = ServicesRequest();

  bool isLoading = false;
  bool? checked = true;
  bool? checkedG = false;
  bool? checkedUn = false;
  bool? checkedEm = false;
  bool? checkedCh = false;
  bool? checkedESM = false;

  bool? checkedDI = false;
  String checkBoxValue = 'married';

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
        checked = sharedPreferences.getBool('_checkedM');
      }
      if (checkedUn == null) {
        checkedUn = false;
        checkedUn = sharedPreferences.getBool('_checkedUnM');
      }
      if (checkedG == null) {
        checkedG = false;
        checkedG = sharedPreferences.getBool('_checkedGM');
      }
      if (checkedEm == null) {
        checkedEm = false;
        checkedEm = sharedPreferences.getBool('_checkedEmM');
      }
      if (checkedCh == null) {
        checkedCh = false;
        checkedCh = sharedPreferences.getBool('_checkedChM');
      }
      if (checkedESM == null) {
        checkedESM = false;
        checkedESM = sharedPreferences.getBool('_checkedESMM');
      }
      if (checkedDI == null) {
        checkedDI = false;
        checkedDI = sharedPreferences.getBool('_checkedDIM');
      }
    notifyListeners();
  }

  void submitForm(checkBoxValue,previousFormSubmitted,applicantId,gross_monthly_income,context) async {
    await request.ifInternetAvailable();
    print("Widget.previousFormSubmitted :::: ${previousFormSubmitted}");
    print("Widget.applicantId :::: ${applicantId}");
    print("Widget.grossMonthlyIncome :::: ${gross_monthly_income}");
    setLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    print('okay');
    print(applicant_id);
    print('okay');
    Map<String, dynamic>? data = {
      'application_id': applicant_id,
      'marital_status': checkBoxValue
//      'role': _selectedType
    };
    LocalStorage.localStorage.saveFormData(data);
    var jsonResponse;
    http.Response response;
    if (MyConstants.myConst.internet ?? false) {
      if (previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application?application_id=${applicantId}&marital_status=$checkBoxValue"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID ?? "",
              'Authentication': authToken ?? ""
            });
      } else {
        data = LocalStorage.localStorage
            .getFormData(MyConstants.myConst.currentApplicantId ?? "");
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID ?? "",
              'Authentication': authToken ?? ""
            },
            body: jsonEncode(data));
      }

      print(response.headers);

      print(response.body);
      print(data);
      if (response.statusCode == 200) {
        print('sss');
        LocalStorage.localStorage.clearCurrentApplication();
        jsonResponse = jsonDecode(response.body);
        print('income');
        print(jsonResponse['gross_monthly_income']);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('_checkedM', checked ?? false);
        await prefs.setBool('_checkedGM', checkedG ?? false);
        await prefs.setBool('_checkedUnM', checkedUn ?? false);
        await prefs.setBool('_checkedEmM', checkedEm ?? false);
        await prefs.setBool('_checkedChM', checkedCh ?? false);
        await prefs.setBool('_checkedESMM', checkedESM ?? false);
        await prefs.setBool('_checkedDIM', checkedDI ?? false);

        if (!previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          applicantId = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data?['application_id']);
          applicantId = data['application_id'];
        }

//      showToastMessage('Some thing Went Wrong try later');
        // sharedPreferences.setInt('applicant_id', data['application_id']);

          print('done');

        setLoading(false);
         showToastMessage('Form Submitted');
          previousFormSubmitted = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new BankAccountDetails(
                  applicantId,
                  gross_monthly_income,
                  previousFormSubmitted)
            // new Attachments(
            //     widget.applicant_id,
            //     widget.gross_monthly_income,
            //     widget.previousFormSubmitted)
          ));
      } else {
          setLoading(false);
          jsonResponse = json.decode(response.body);
          print('data');
          showToastMessage(jsonResponse['message']);

      }
    } else {
     setLoading(false);
      print("Marital Status Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new Attachments(
              applicant_id: applicantId,
              gross_monthly_income: gross_monthly_income,
              previousFormSubmitted: previousFormSubmitted)));
    }
  }

  init(){
    getCheckValues();
    checkInternetAvailability();
  }




}

