import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/Dashboard.dart';
import 'package:lesedi/forms/PersonalInformationB1.dart';
import 'package:lesedi/forms/attachments.dart';
import 'package:lesedi/forms/water_and_electricity_information/view/water_and_electricity_info_view.dart';
import 'package:lesedi/global.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:lesedi/app_color.dart';
import 'package:location/location.dart';

class PersonalInformationA1 extends StatefulWidget {
  var userRole;
  var applicant_id;
  List scannerList = [];
  PersonalInformationA1(this.userRole, this.applicant_id);
  @override
  _PersonalInformationA1State createState() => _PersonalInformationA1State();
}

class _PersonalInformationA1State extends State<PersonalInformationA1> {
  Location location = new Location();
  bool _coordinatesLoading = false;
  bool _isLoading = false;
  var applicantID;
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
  @override
  void initState() {
    ageController.text = '22';
    getRole();
    print(widget.applicant_id);
    getLocation();
    checkInternetAvailability();
    return super.initState();
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
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
    setState(() {
      lat = _locationData?.latitude.toString()??"";
      lng = _locationData?.longitude.toString()??"";
    });

    print(_coordinatesLoading);
    print('location holdeer');
    print(_locationData?.latitude);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
//        formatter.format(DateTime.parse(picked));
        selectedDate = picked;
        var date = DateTime.parse(selectedDate.toString());
        var formattedDate = "${date.day}-${date.month}-${date.year}";
        print(formattedDate);
//        var picker = formatter.format(DateTime.parse(picked));
        dateOfApplicationController.value =
            TextEditingValue(text: formattedDate.toString());
      });
  }

  void formClicked() async {
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
                    if (!_isLoading) {
                      submitForm(
                          dateOfApplicationController.text,
                          surNameController.text,
                          firstNameController.text,
                          accountNumberController.text,
                          applicantIDController.text,
                          spouseIDController.text,
                          ageController.text,
                          addressController.text,
                          dependentIDController.text);
                    }
                  } else {
                    setState(() {
                      _isLoading = false;
                      showToastMessage("Please enter Occupant ID ");
                    });
                  }
                } else {
                  setState(() {
                    _isLoading = false;
                    showToastMessage("Please enter address ");
                  });
                }
              } else {
                setState(() {
                  _isLoading = false;
                  showToastMessage("Please enter age ");
                });
              }
            } else {
              setState(() {
                _isLoading = false;
                showToastMessage("Please enter spouse ID");
              });
            }
          } else {
            setState(() {
              _isLoading = false;
              showToastMessage("Please enter application ID");
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            showToastMessage("Please enter firstname");
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          showToastMessage("Please enter surname");
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showToastMessage("Please enter date of application");
    }
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
//    role = sharedPreferences.getString('role');
//    applicant_id = sharedPreferences.getInt('applicant_id');

    print(role);
  }

  var applicant_id;
  Future<Null> submitForm(
      String dateOfApplication,
      surname,
      firstname,
      municipalAccountNumber,
      applicantID,
      spouseID,
      age,
      address,
      dependantID) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    // checkInternetAvailability();
    await request.ifInternetAvailable();
    print('okay');
    print(userID);
    print('okay');
    Map<String, dynamic> data = {
      // 'application_id': widget.applicant_id,
      'date_of_application': dateOfApplication,
      'latitude': lat,
      'longitude': lng,
      'surname': surname,
      'first_name': firstname,
      'address': address,
      'account_number': municipalAccountNumber,
      'occupant_id': dependantID,
//      'age':'22',
      'spouse_id_number': spouseID,
      'dob': birthDate,
      'id_number': applicantID,
//      'spouse_id': spouseID
    };

    print('id');

    // checkInternetAvailability();
    LocalStorage.localStorage.saveFormData(data);
    if (MyConstants.myConst.internet ?? false) {
      var jsonResponse;
      if (applicant_id == null) {
        print('yuppp');
        http.Response response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID??"",
              'Authentication': authToken??""
            },
            body: jsonEncode(data));

        print(response.headers);

        print(response.body);
        print(data);
        if (response.statusCode == 200) {
          print('sss');
          jsonResponse = jsonDecode(response.body);
          LocalStorage.localStorage.clearCurrentApplication();

//      showToastMessage('Some thing Went Wrong try later');
          print(jsonResponse);
          sharedPreferences.setInt(
              'applicant_id', jsonResponse['application_id']);
          applicant_id = sharedPreferences.getInt('applicant_id');
          print('id');
          print(applicant_id);
          setState(() {
            print('done');

            _isLoading = false;
//      print(token);
            showToastMessage('Form Submitted');
            previousFormSubmitted = true;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new
                // Attachments(applicant_id, "30", previousFormSubmitted)
                PersonalInformationB1(
                    applicant_id, function, previousFormSubmitted)
            ));
//        );
          });
        } else {
          setState(() {
            _isLoading = false;
            jsonResponse = json.decode(response.body);
            print('data');
            showToastMessage(
                jsonResponse.toString().replaceAll("[\\[\\](){}]", ""));
          });
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
              'uuid': userID??"",
              'Authentication': authToken??""
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
          setState(() {
            print('done');

            _isLoading = false;
            showToastMessage('Form Submitted');
            previousFormSubmitted = true;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new
                // Attachments(applicant_id, "30", previousFormSubmitted)
                PersonalInformationB1(
                    applicant_id, function, previousFormSubmitted)
            ));
          });
        } else {
          setState(() {
            _isLoading = false;
            jsonResponse = json.decode(response.body);
            print('data');
//        print(jsonResponse);
            showToastMessage(jsonResponse['message']);
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print("A1 Navigated from Else");
      print("A1 form submission status :::: $previousFormSubmitted");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new
          // Attachments(applicant_id, "30", previousFormSubmitted)
          PersonalInformationB1(
              widget.applicant_id, function, previousFormSubmitted)
      ));
    }
  }

  String birthDate = "";
  int age = -1;
  TextStyle valueTextStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'opensans');
  TextStyle textTextStyle = TextStyle(fontSize: 13, fontFamily: 'opensans');
  TextStyle buttonTextStyle =
      TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'opensans');
  selectDate(BuildContext context, DateTime initialDateTime,
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
      setState(() {});
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
    return age;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton (
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton (
      child: Text("Okay"),
      onPressed: () {
//        Navigator.of(context).pop(true);
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                Dashboard(widget.userRole, widget.applicant_id)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to exit form?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton (
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton (
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
//        elevation: .5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
//            Navigator.of(context).pop(false);
            showAlertDialog(context);
          },
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'PERSONAL INFORMATION',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
//          height: 665.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 30),
                  child: Container(
                    height: 55,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor:
                            AppColors.PRIMARY_COLOR, //color of the main banner
                        hintColor: AppColors.PRIMARY_COLOR,
                        colorScheme: ColorScheme.light().copyWith(
                          primary: AppColors.PRIMARY_COLOR,
                          secondary: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: new TextFormField(
                                controller: dateOfApplicationController,
                                obscureText: false,
                                decoration: new InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xff626a76),
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PRIMARY_COLOR,
                                          width: 1.0),
                                    ),
                                    labelText: 'Date of Application',
                                    labelStyle: new TextStyle(
                                        color: const Color(0xff626a76),
                                        fontFamily: 'opensans'),
                                    focusColor: AppColors.PRIMARY_COLOR,
                                    alignLabelWithHint: true,
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(4.0),
                                        borderSide: new BorderSide(
                                            color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),
                                keyboardType: TextInputType.datetime,
                                style: new TextStyle(
                                    fontFamily: 'opensans',
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 13.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: accountNumberController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'Account Number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 0),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: surNameController,
                      obscureText: false,
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'Surname',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                /// Text header "Welcome To" (Click to open code)

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: firstNameController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'First Name',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
//                            autofocus: true,
                      controller: applicantIDController,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.scanner),
                            color: AppColors.PRIMARY_COLOR,
                            onPressed: () {
                              scan(1);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'Applicant ID',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                        (age > -1)
//                            ?
                    Column(
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                primaryColor: AppColors
                                    .PRIMARY_COLOR, //color of the main banner
                                hintColor: AppColors.PRIMARY_COLOR,
                                colorScheme: ColorScheme.light().copyWith(
                                  primary: AppColors.PRIMARY_COLOR,
                                  secondary: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  DateTime birthDate = await selectDate(
                                      context, DateTime(1912),
                                      lastDate: DateTime.now());
                                  final df = new DateFormat('dd-MMM-yyyy');
                                  this.birthDate = df.format(birthDate);
                                  this.age = calculateAge(birthDate);

                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(5, 5)),
                                      border: Border.all(color: Colors.grey)),
                                  padding: EdgeInsets.all(18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "DOB: ",
                                        style: textTextStyle,
                                      ),
                                      Text(
                                        "$birthDate",
                                        style: valueTextStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.all(18),
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(5, 5)),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Age: ",
                                style: textTextStyle,
                              ),
                              (age > -1)
                                  ? Text(
                                      "$age",
                                      style: valueTextStyle,
                                    )
                                  : Text('')
                            ],
                          ),
                        )
                      ],
                    ),
//                            : Text("Press button to see age"),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: spouseIDController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.scanner),
                            color: AppColors.PRIMARY_COLOR,
                            onPressed: () {
                              scan(2);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'Spouse ID',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: dependentIDController,
//                            autofocus: true,

//                     Wa       onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.scanner),
                            color: AppColors.PRIMARY_COLOR,
                            onPressed: () {
                              scan(3);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'Occupant ID',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: addressController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR != null
                                    ? AppColors.PRIMARY_COLOR
                                    : Color(0xffDE626C),
                                width: 1.0),
                          ),
                          labelText: 'Address',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR != null
                              ? AppColors.PRIMARY_COLOR
                              : Color(0xffDE626C),
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR != null
                              ? AppColors.PRIMARY_COLOR
                              : Color(0xffDE626C),
                          fontSize: 13.0),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 0),
                  child: Container(
                    height: 55,
                    color: Colors.black.withOpacity(0.2),
                    child: new TextFormField(
                      readOnly: true,
                      enabled: false,
//                          controller: accountNumberController,
//                            autofocus: true,

//                            onTap: _requestFocusPassword,
                      obscureText: false,
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff626a76), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.PRIMARY_COLOR, width: 1.0),
                          ),
                          labelText: 'lat:' + lat + ',' + ' lng:' + lng,
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue.shade700)), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13.0),
                    ),
                  ),
                ),

              ],
            ),
          ),
          InkWell(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild?.unfocus();
              }
              formClicked();
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => new
              //     // Attachments(applicant_id, "30", previousFormSubmitted)
              //     PersonalInformationB1(
              //         1, function, true)
              // ));
              //    Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> PersonalInformationB1()));
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  margin: EdgeInsets.only(right: 0, bottom: 20),
//                alignment: Alignment.bottomRight,
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR != null
                        ? AppColors.PRIMARY_COLOR
                        : Color(0xffDE626C),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(-4, 0),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child:
                      // Adobe XD layer: 'back-arrow' (shape)
                      Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: _isLoading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: 30,
                                color: Colors.white,
                              )),
                  )),
            ),
          ),

        ],
      )),
    );
  }

  function(value) => setState(() => applicant_id = value);

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
        setState(() {
          if (type == 3) {
            if (array.length >= 4) {
              updateList = array.elementAt(4);
            } else if (array.length == 1) {
              updateList = array.elementAt(0);
            }
            widget.scannerList.add(updateList);
          }
          print('list');
          print(widget.scannerList);
          DataResult = widget.scannerList.join('.');
          print('lini1 ${DataResult}');
          concatenate = StringBuffer();
//        DataResult.forEach((item){
//          concatenate.write(item).toString().split(',');
//        });
//        print('Data${concatenate}');
//
        });
//          setScanValues(t ype, DataResult.toString()) ;
        setState(() {
//          dependentIDController.text = DataResult.toString();
        });
      }

      if (result != null && result.rawContent != null) {
        var arr = result.rawContent.toString().split('|');
        if (arr.length >= 4) {
          setScanValues(type, arr.elementAt(4));
        } else if (arr.length == 1) {
          setScanValues(type, arr.elementAt(0));
        }
//        else{
//          print("Return");
//
//        }
      }

      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      ScanResult result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        // result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
        print('result');
        print(scanResult);
      });
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
}
