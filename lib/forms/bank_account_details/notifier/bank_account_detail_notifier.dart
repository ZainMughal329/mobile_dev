import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/forms/attachments/view/attachments.dart';
import 'package:lesedi/model/bank_details_model.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class BankAccountDetailNotifier extends ChangeNotifier {
  bool isLoading = false;
  int counter = 1;
  ServicesRequest request = ServicesRequest();

  List<TextEditingController> bankName =
      List.generate(3, (i) => TextEditingController());
  List<TextEditingController> accountNoCon =
      List.generate(3, (i) => TextEditingController());
  List<TextEditingController> branchCodeCon =
      List.generate(3, (i) => TextEditingController());

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    notifyListeners();
  }
  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
  Future submitForm(
      List<String> bankName,
      List<String> bankAc,
      List<String> branchCode,
      int applicant_id,
      bool previousFormSubmitted,
      var gross_monthly_income,
      BuildContext context
      ) async {
    setLoading(true);
    print(bankName.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    await request.ifInternetAvailable();
    if (MyConstants.myConst.internet ?? false) {
      BankDetailsModel bankDetailsModel = BankDetailsModel();
      bankDetailsModel.bankDetailsAttributes = [];

      for (int i = 0; i < 3; i++) {
        if (bankName[i].isNotEmpty &&
            bankAc[i].isNotEmpty &&
            branchCode[i].isNotEmpty) {
          bankDetailsModel.bankDetailsAttributes?.add(
            BankDetailsAttributes(
              bankNumber: bankName[i],
              bankAccountNumber: bankAc[i],
              branchCode: branchCode[i],
            ),
          );
        }
      }

      bankDetailsModel.applicationId = applicant_id;
      var jsonResponse;
      try{      http.Response response = await http.post(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
          },
          body: jsonEncode(bankDetailsModel.toJson()
            //     {
            //   "bank_details_attributes": bankDetailsModel.bankDetailsAttributes,
            //   "application_id" : widget.applicant_id
            // }
          ));
      print(bankDetailsModel.toJson());

      print(response.headers);

      print(response.body);
      // print(data);
      if (response.statusCode == 200) {
        jsonResponse = jsonDecode(response.body);
        // sharedPreferences.setInt('applicant_id', data['application_id']);
        // LocalStorage.localStorage.clearCurrentApplication();
        print('done');

        setLoading(false);
        previousFormSubmitted = true;
        showToastMessage('Form Submitted');
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => Attachments(
                applicant_id: applicant_id,
                gross_monthly_income: gross_monthly_income,
                previousFormSubmitted: previousFormSubmitted)));
        notifyListeners();
      } else {
        setLoading(false);

        jsonResponse = json.decode(response.body);
        print('data');
//        print(jsonResponse);
        showToastMessage(jsonResponse['message']);
        notifyListeners();
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

    }
  }
  init(){
    checkInternetAvailability();
  }
}
