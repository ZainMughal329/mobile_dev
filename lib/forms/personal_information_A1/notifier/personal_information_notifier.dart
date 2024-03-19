import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/forms/personal_information_B2/view/personal_information_B2_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PersonalInformationNotifier extends ChangeNotifier {
  Location location = new Location();
  bool _coordinatesLoading = false;
  bool isLoading = false;
  var applicantID;
  var applicant_id;
  String? birthDate;
  TextEditingController dateOfApplicationController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController applicantIDController = TextEditingController();
  TextEditingController spouseIDController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dependentIDController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var formatter = new DateFormat('MMMMd');
  var myFormat = DateFormat('d-MM-yyyy');
  var role;
  var DataResult;
  var concatenate;
  var lat = '';
  var lng = '';
  LocationData? _locationData;
  ServicesRequest request = ServicesRequest();
  bool previousFormSubmitted = false;
  int age = -1;
  final List scannerList = [];

  setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    notifyListeners();
  }

  function(value) {
    notifyListeners();
    return applicant_id = value;
  }

  getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    lat = _locationData?.latitude.toString() ?? "";
    lng = _locationData?.longitude.toString() ?? "";
    notifyListeners();

    print(_coordinatesLoading);
    print('location holdeer');
    print(_locationData?.latitude);
  }

  Future selectDate(BuildContext context,) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      selectedDate = picked;
        var date = DateTime.parse(selectedDate.toString());
        var formattedDate = "${date.day}-${date.month}-${date.year}";
        print(formattedDate);
        dateOfApplicationController.value =
            TextEditingValue(text: formattedDate.toString());
      notifyListeners();
  }
  void formClicked({required BuildContext context}) async {
    // Pattern pattern =
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (dateOfApplicationController.text.isNotEmpty) {
      if (surNameController.text.isNotEmpty) {
        if (firstNameController.text.isNotEmpty) {
          if (applicantIDController.text.isNotEmpty) {
            if (spouseIDController.text.isNotEmpty) {
              if (birthDate != null) {
                if (addressController.text.isNotEmpty) {
                  if (dependentIDController.text.isNotEmpty) {
                    if (!isLoading) {
                      submitForm(
                        dateOfApplicationController.text,
                        surNameController.text,
                        firstNameController.text,
                        accountNumberController.text,
                        applicantIDController.text,
                        spouseIDController.text,
                        ageController.text,
                        addressController.text,
                        dependentIDController.text,
                        context,
                      );
                    }
                  } else {
                    setLoading(false);
                    showToastMessage("Please enter Occupant ID ");
                  }
                } else {
                  setLoading(false);
                  showToastMessage("Please enter address ");
                }
              } else {
                setLoading(false);
                showToastMessage("Please enter age ");
              }
            } else {
              setLoading(false);

              showToastMessage("Please enter spouse ID");
            }
          } else {
            setLoading(false);

            showToastMessage("Please enter application ID");
          }
        } else {
          setLoading(false);
          showToastMessage("Please enter firstname");
        }
      } else {
        showToastMessage("Please enter surname");
      }
    } else {
      setLoading(false);

      showToastMessage("Please enter date of application");
    }
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
    print(role);
  }

  Future submitForm(
    String dateOfApplication,
    surname,
    firstname,
    municipalAccountNumber,
    applicantID,
    spouseID,
    age,
    address,
    dependantID,
    context,
  ) async {
    setLoading(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    await request.ifInternetAvailable();
    print('okay');
    print(userID);
    print('okay');
    Map<String, dynamic> data = {
      'application_id': applicant_id,
      'date_of_application': dateOfApplication,
      'latitude': lat,
      'longitude': lng,
      'surname': surname,
      'first_name': firstname,
      'address': address,
      'account_number': municipalAccountNumber,
      'occupant_id': dependantID,
      'spouse_id_number': spouseID,
      'dob': birthDate,
      'id_number': applicantID,
    };

    print('id');

    LocalStorage.localStorage.saveFormData(data);
    if (MyConstants.myConst.internet ?? false) {
      try {
        var jsonResponse;
        if (applicant_id == null) {
          print('yuppp');
          http.Response response = await http.post(
              Uri.parse(
                  "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
              headers: {
                'Content-Type': 'application/json',
                'uuid': userID ?? "",
                'Authentication': authToken ?? ""
              },
              body: jsonEncode(data));

          print(response.headers);

          print(response.body);
          print(data);
          if (response.statusCode == 200) {
            print('sss');
            jsonResponse = jsonDecode(response.body);
            LocalStorage.localStorage.clearCurrentApplication();

            print(jsonResponse);
            print("applicant id is ${jsonResponse['application_id']}");
            sharedPreferences.setInt(
                'applicant_id', jsonResponse['application_id']);
            applicant_id = sharedPreferences.getInt('applicant_id');
            print('id');
            print(applicant_id);
            print('done');
            showToastMessage('Form Submitted');
            previousFormSubmitted = true;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new
                    // Attachments(applicant_id, "30", previousFormSubmitted)
                    PersonalInformationB1(
                        applicant_id, function, previousFormSubmitted)));
          } else {
            setLoading(false);

            jsonResponse = json.decode(response.body);
            print('data');
            showToastMessage(
                jsonResponse.toString().replaceAll("[\\[\\](){}]", ""));
          }
        } else if (applicant_id != null) {
          print('weeeee');

          Map data = {
            'application_id': applicant_id,
            'date_of_application': dateOfApplication,
            'surname': surname,
            'first_name': firstname,
            'address': address,
            'account_number': municipalAccountNumber,
            'dob': birthDate,
            'occupant_id': dependantID,
            'spouse_id_number': spouseID,
            'id_number': applicantID,
          };
          var jsonResponse;
          http.Response response = await http.post(
              Uri.parse(
                  "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
              headers: {
                'Content-Type': 'application/json',
                'uuid': userID ?? "",
                'Authentication': authToken ?? ""
              },
              body: jsonEncode(data));

          print(response.headers);

          print(response.body);
          print(data);
          if (response.statusCode == 200) {
            print('sss');
            jsonResponse = jsonDecode(response.body);
            sharedPreferences.setInt('applicant_id', data['application_id']);
            LocalStorage.localStorage.clearCurrentApplication();
            setLoading(false);

            showToastMessage('Form Submitted');
            previousFormSubmitted = true;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new
                    // Attachments(applicant_id, "30", previousFormSubmitted)
                    PersonalInformationB1(
                        applicant_id, function, previousFormSubmitted)));
          } else {
            setLoading(false);

            jsonResponse = json.decode(response.body);
            print('data');
//        print(jsonResponse);
            showToastMessage(jsonResponse['message']);
          }
        }
      } on SocketException catch (e) {
        Fluttertoast.showToast(msg: "Internet not available");
        setLoading(false);

        print('dsa');
        print(e);
      } on FormatException catch (e) {
        Fluttertoast.showToast(msg: "Bad Request");
        setLoading(false);

        print(e);
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
        setLoading(false);

        print(e);
      }
    } else {
      setLoading(false);

      print("A1 Navigated from Else");
      print("A1 form submission status :::: $previousFormSubmitted");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new
              // Attachments(applicant_id, "30", previousFormSubmitted)
              PersonalInformationB1(
                  applicant_id ?? "", function, previousFormSubmitted)));
    }
    notifyListeners();
  }


  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    notifyListeners();
    return age;
  }
  Future scan(int callType) async {
    ScanResult scanResult;
    int type = callType;

    final _flashOnController = TextEditingController(text: "Flash on");
    final _flashOffController = TextEditingController(text: "Flash off");
    final _cancelController = TextEditingController(text: "Cancel");

    var _aspectTolerance = 0.00;
    var _selectedCamera = -1;
    var _useAutoFocus = true;
    var _autoEnableFlash = false;

    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      print(result.rawContent.toString());

      print('content');
      var updateList;
      print(result.rawContent.length);
      if (result != null && result.rawContent != null) {
        var array = result.rawContent.toString().split('|');
        print('raw content');
        print(array);
//      updateList = array.elementAt(0);

        print('length');
        print(array.length);
          if (type == 3) {
            if (array.length >= 4) {
              updateList = array.elementAt(4);
            } else if (array.length == 1) {
              updateList = array.elementAt(0);
            }
            scannerList.add(updateList);
          }
          print('list');
          // print(widget.scannerList);
          // DataResult = widget.scannerList.join('.');
          print('lini1 ${DataResult}');
          concatenate = StringBuffer();
          notifyListeners();
          return scannerList;
      }

      if (result != null && result.rawContent != null) {
        var arr = result.rawContent.toString().split('|');
        if (arr.length >= 4) {
          setScanValues(type, arr.elementAt(4));
        } else if (arr.length == 1) {
          setScanValues(type, arr.elementAt(0));
        }
      }

    scanResult = result;
      notifyListeners();
    } on PlatformException catch (e) {
      ScanResult result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
      notifyListeners();
      } else {
        // result.rawContent = 'Unknown error: $e';
      }

        scanResult = result;
        print('result');
        print(scanResult);
        notifyListeners();
    }
  }

  void setScanValues(int type, String number) {
    if (type == 1) {
      applicantIDController.value = TextEditingValue(text: number);
    } else if (type == 2) {
      spouseIDController.value = TextEditingValue(text: number);
    } else if (type == 3) {
      dependentIDController.text = DataResult.toString();
    }
  }
  selectDatePicker(BuildContext context, DateTime initialDateTime,
      {DateTime? lastDate}) async {
    Completer completer = Completer();
    String _selectedDateInString;
//    if (Platform.isAndroid)
    showDatePicker(
            context: context,
            initialDate: initialDateTime,
            firstDate: DateTime(1912),
            lastDate: lastDate == null
                ? DateTime(initialDateTime.year + 10)
                : lastDate)
        .then((temp) {
      if (temp == null) return null;
      completer.complete(temp);
notifyListeners();
        });
    /*else
      DatePicker.showDatePicker(
        context,
        dateFormat: 'yyyy-mmm-dd',
//        locale: 'en',
        onConfirm: (temp, selectedIndex) {
          if (temp == null) return null;
          completer.complete(temp);

          setState(() {});
        },
      );*/
    return completer.future;
  }
  void init() {
    ageController.text = '22';
    getRole();
    print(applicant_id);
    getLocation();
    checkInternetAvailability();
  }
}

