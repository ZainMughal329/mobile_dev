import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lesedi/forms/application_status/view/application_status.dart';

class PersonalInformationB2Notifier extends ChangeNotifier {
  ServicesRequest request = ServicesRequest();

  bool checkboxValueCity = false;
  List<String> allCities = ['Water', 'Electricity', 'Refuse Removal', 'None'];
  List<String> selectedCities=[];

  RegExp pattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController emailController = TextEditingController();

  TextEditingController wardNumberController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController standNumberController = TextEditingController();
  TextEditingController serviceLinkedtoStandController =
      TextEditingController();
  TextEditingController eskomAccountNumberController = TextEditingController();
  TextEditingController contectNumberController = TextEditingController();
  TextEditingController telephoneNumberController = TextEditingController();
  TextEditingController FinancialYearController = TextEditingController();
  var translation;
  bool isLoading = false;
  var role;
  var emailStorage;
  var wardNumberStorage;
  var municipalAccountNumber;
  var standNumber;
  List<String> serviceLinkedHolder = [
    'Water',
    'Electricity',
    'Refuse Removal',
    'None'
  ];
  var maskFormatter = new MaskTextInputFormatter(
      mask: '### ### ######## ##### #### ####',
      filter: {"#": RegExp(r'[0-9]')});
  var eskonAccountNumber;
  var contactNumber;
  var telephone_number;
  var formattedString = '';

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    notifyListeners();
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
//    role = sharedPreferences.getString('role');

    emailStorage = sharedPreferences.getString('emailStorage');
    wardNumberStorage = sharedPreferences.getString('wardNumberStorage');
    municipalAccountNumber =
        sharedPreferences.getString('municipalAccountNumber');
    standNumber = sharedPreferences.getString('standNumber');
    if (sharedPreferences.getStringList('serviceLinked') != null) {
      serviceLinkedHolder = sharedPreferences.getStringList('serviceLinked')!;
    }
    eskonAccountNumber = sharedPreferences.getString('eskonAccountNumber');
    contactNumber = sharedPreferences.getString('contactNumber');
    telephone_number = sharedPreferences.getString('telephone_number');

    if (emailStorage != null) {
      emailController = TextEditingController(text: '$emailStorage');
    }
    if (wardNumberStorage != null) {
      wardNumberController = TextEditingController(text: '$wardNumberStorage');
    }

    if (municipalAccountNumber != null) {
      accountNumberController =
          TextEditingController(text: '$municipalAccountNumber');
    }

    if (standNumber != null) {
      standNumberController = TextEditingController(text: '$standNumber');
    }
    if (eskonAccountNumber != null) {
      eskomAccountNumberController =
          TextEditingController(text: '$eskonAccountNumber');
    }
    if (contactNumber != null) {
      contectNumberController = TextEditingController(text: '$contactNumber');
    }
    if (telephone_number != null) {
      telephoneNumberController =
          TextEditingController(text: '$telephone_number');
    }

    print('email');
    print(emailStorage);
    print(serviceLinkedHolder);
    print(role);
    notifyListeners();
  }

  void formClicked(
      {required bool previousFormSubmitted,
      required int id,
      required BuildContext context}) async {
    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty) {
      // if (wardNumberController.text.isNotEmpty) {
      if (formattedString.isNotEmpty) {
        if (selectedCities.isNotEmpty) {
          if (eskomAccountNumberController.text.isNotEmpty) {
            if (contectNumberController.text.isNotEmpty) {
              if (telephoneNumberController.text.isNotEmpty) {
                if (FinancialYearController.text.isNotEmpty) {
                  if (!isLoading) {
                    submitForm(
                        emailController.text,
                        wardNumberController.text,
                        accountNumberController.text,
                        formattedString,
                        translation,
                        eskomAccountNumberController.text,
                        contectNumberController.text,
                        telephoneNumberController.text,
                        FinancialYearController.text,
                        previousFormSubmitted,
                        id,
                        context);
                  }
                } else {
                  setLoading(false);
                  showToastMessage("Please select financial year ");
                }
              } else {
                setLoading(false);

                showToastMessage("Please enter telephone number ");
              }
            } else {
              setLoading(false);

              showToastMessage("Please enter contact number ");
            }
          } else {
            setLoading(false);

            showToastMessage("Please enter eskon account number ");
          }
        } else {
          setLoading(false);

          showToastMessage("Please enter service link to stand number");
        }
      } else {
        setLoading(false);

        showToastMessage("Please enter  stand/ erf number");
      }
      // }
      // else {
      //   setState(() {
      //     _isLoading = false;
      //     showToastMessage("Please enter ward number");
      //   });
      // }
    } else {
      setLoading(false);

      showToastMessage("Please enter email");
    }
  }

  Future submitForm(
      String email,
      wardNumber,
      municipalAccountNumber,
      standNumber,
      serviceLinked,
      eskonAccountNumber,
      contactNumber,
      telephone_number,
      financial_year,
      previousFormSubmitted,
      applicant_id,
      context) async {
    setLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');

    var applicant_id = sharedPreferences.getInt('applicant_id');
    // checkInternetAvailability();
    await request.ifInternetAvailable();
    print('okay');
    print(userID);
    print('okay');
    Map<String, dynamic>? data = {
      'application_id': applicant_id,
      'email': email,
      'ward_number': wardNumber,
      'stand_number': standNumber,
      'services_linked':
          selectedCities!.isNotEmpty ? selectedCities : serviceLinkedHolder,
      'eskom_account_number': eskonAccountNumber,
      'cellphone_number': contactNumber,
      'telephone_number': telephone_number,
      'financial_year': financial_year
    };
    // checkInternetAvailability();
    LocalStorage.localStorage.saveFormData(data);
    if (MyConstants.myConst.internet ?? false) {
      var jsonResponse;
      http.Response response;

      if (previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID ?? "",
              'Authentication': authToken ?? ""
            },
            body: jsonEncode(data));
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
        LocalStorage.localStorage.clearCurrentApplication();
        print('sss');
        jsonResponse = jsonDecode(response.body);
        log("Response logs " + jsonResponse.toString());
        sharedPreferences.setString("emailStorage", email);
        // sharedPreferences.setString("wardNumberStorage", wardNumber);
        sharedPreferences.setString(
            "municipalAccountNumber", municipalAccountNumber);
        sharedPreferences.setString("standNumber", standNumber);
        sharedPreferences.setStringList("serviceLinked", selectedCities ?? []);
        sharedPreferences.setString("eskonAccountNumber", eskonAccountNumber);
        sharedPreferences.setString("contactNumber", contactNumber);
        sharedPreferences.setString("telephone_number", telephone_number);
//      showToastMessage('Some thing Went Wrong try later');

        if (!previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          applicant_id = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data['application_id']);
          applicant_id = data['application_id'];
        }

        print('done');

        setLoading(false); //      print(token);
        showToastMessage('Form Submitted');
        previousFormSubmitted = true;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => new ApplicationStatus(
                applicant_id ?? 0, previousFormSubmitted)));
      } else {
        setLoading(false);
        jsonResponse = json.decode(response.body);
        print('data');
//        print(jsonResponse);
        showToastMessage(jsonResponse['message']);
      }
    } else {
      setLoading(false);
      print("B1 Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              new ApplicationStatus(applicant_id ?? 0, previousFormSubmitted)));
    }
    notifyListeners();
  }

  Future selectDateYear(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      dateFormat: 'yyyy',
      minDateTime: DateTime(1901, 1),
      maxDateTime: DateTime(2100),
      onConfirm: (dateTime, List<int> index) {
        print(dateTime.year);
//              _dateTime = dateTime;
        FinancialYearController.value =
            TextEditingValue(text: dateTime.year.toString());
        notifyListeners();
      },
    );
  }

  getFormattedList() {
    List<int> zeroList = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    var formattedString = '';
    for (int i = 0; i < zeroList.length; i++) {
      print(i);
      switch (i) {
        case 3:
        case 6:
        case 14:
        case 19:
        case 23:
//        case 4:
//        case 4:
          {
            formattedString += " " + zeroList[i].toString();
          }
          break;
        default:
          {
            formattedString += zeroList[i].toString();
          }
      }

//                              formattedString+=zeroList[i];
    }
    print(formattedString);
  }

  init() {

    getRole();
    checkInternetAvailability();
    // maskFormatter = new MaskTextInputFormatter(
    //     mask: '### ### ######## ##### #### ####',
    //     filter: {"#": RegExp(r'[0-9]')});
  }
}
