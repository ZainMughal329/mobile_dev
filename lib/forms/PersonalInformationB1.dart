import 'dart:convert';
import 'dart:developer';

// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/forms/ApplicationStatus.dart';
import 'package:rustenburg/forms/MaritalStatus.dart';
import 'package:rustenburg/forms/PersonalInformationA1.dart';
import 'package:rustenburg/global.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:rustenburg/networkRequest/services_request.dart';

//import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rustenburg/app_color.dart';

//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PersonalInformationB1 extends StatefulWidget {
  int applicant_id;
  final Function func;
  bool previousFormSubmitted;

  PersonalInformationB1(
      this.applicant_id, this.func, this.previousFormSubmitted);

  @override
  _PersonalInformationB1State createState() => _PersonalInformationB1State();
}

class _PersonalInformationB1State extends State<PersonalInformationB1> {
  var maskFormatter;

  void initState() {
    print('id');
    print(widget.applicant_id);
    getRole();
    checkInternetAvailability();
    maskFormatter = new MaskTextInputFormatter(
        mask: '### ### ######## ##### #### ####',
        filter: {"#": RegExp(r'[0-9]')});
    return super.initState();
  }

  ServicesRequest request = ServicesRequest();
  var _translation;
  bool _isLoading = false;
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
  var eskonAccountNumber;
  var contactNumber;
  var telephone_number;
  var formattedString = '';

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
//    role = sharedPreferences.getString('role');

    setState(() {
      emailStorage = sharedPreferences.getString('emailStorage');
      wardNumberStorage = sharedPreferences.getString('wardNumberStorage');
      municipalAccountNumber =
          sharedPreferences.getString('municipalAccountNumber');
      standNumber = sharedPreferences.getString('standNumber');
      serviceLinkedHolder = sharedPreferences.getStringList('serviceLinked');
      eskonAccountNumber = sharedPreferences.getString('eskonAccountNumber');
      contactNumber = sharedPreferences.getString('contactNumber');
      telephone_number = sharedPreferences.getString('telephone_number');

      if (emailStorage != null) {
        emailController = TextEditingController(text: '$emailStorage');
      }
      if (wardNumberStorage != null) {
        wardNumberController =
            TextEditingController(text: '$wardNumberStorage');
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
    });
  }

  bool checkboxValueCity = false;
  List<String> allCities = ['Water', 'Electricity', 'Refuse Removal', 'None'];
  List<String> selectedCities = [];

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

  void formClicked() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailController.text.isNotEmpty) {
      // if (wardNumberController.text.isNotEmpty) {
        if (formattedString.isNotEmpty) {
          if (selectedCities != null) {
            if (eskomAccountNumberController.text.isNotEmpty) {
              if (contectNumberController.text.isNotEmpty) {
                if (telephoneNumberController.text.isNotEmpty) {
                  if (FinancialYearController.text.isNotEmpty) {
                    if (!_isLoading) {
                      submitForm(
                          emailController.text,
                          wardNumberController.text,
                          accountNumberController.text,
                          formattedString,
                          _translation,
                          eskomAccountNumberController.text,
                          contectNumberController.text,
                          telephoneNumberController.text,
                          FinancialYearController.text);
                    }
                  } else {
                    setState(() {
                      _isLoading = false;
                      showToastMessage("Please select financial year ");
                    });
                  }
                } else {
                  setState(() {
                    _isLoading = false;
                    showToastMessage("Please enter telephone number ");
                  });
                }
              } else {
                setState(() {
                  _isLoading = false;
                  showToastMessage("Please enter contact number ");
                });
              }
            } else {
              setState(() {
                _isLoading = false;
                showToastMessage("Please enter eskon account number ");
              });
            }
          } else {
            setState(() {
              _isLoading = false;
              showToastMessage("Please enter service link to stand number");
            });
          }
        } else {
          setState(() {
            _isLoading = false;

            showToastMessage("Please enter  stand/ erf number");
          });
        }
      // }
      // else {
      //   setState(() {
      //     _isLoading = false;
      //     showToastMessage("Please enter ward number");
      //   });
      // }
    } else {
      setState(() {
        _isLoading = false;
      });
      showToastMessage("Please enter email");
    }
  }

  RegExp pattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future<Null> submitForm(
      String email,
      wardNumber,
      municipalAccountNumber,
      standNumber,
      serviceLinked,
      eskonAccountNumber,
      contactNumber,
      telephone_number,
      financial_year) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');

    var applicant_id = sharedPreferences.getInt('applicant_id');
    // checkInternetAvailability();
    await request.ifInternetAvailable();
    print('okay');
    print(userID);
    print('okay');
    Map<String, dynamic> data = {
      'application_id': widget.applicant_id,
      'email': email,
      'ward_number': wardNumber,
//      'account_number': municipalAccountNumber,
      'stand_number': standNumber,
      'services_linked':
          selectedCities.isNotEmpty ? selectedCities : serviceLinkedHolder,
      'eskom_account_number': eskonAccountNumber,
      'cellphone_number': contactNumber,
      'telephone_number': telephone_number,
      'financial_year': financial_year
//      'role': _selectedType
    };
    // checkInternetAvailability();
    LocalStorage.localStorage.saveFormData(data);
    if (MyConstants.myConst.internet) {
      var jsonResponse;
      http.Response response;

      if (widget.previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID,
              'Authentication': authToken
            },
            body: jsonEncode(data));
      } else {
        data = LocalStorage.localStorage
            .getFormData(MyConstants.myConst.currentApplicantId);
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID,
              'Authentication': authToken
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
        sharedPreferences.setStringList("serviceLinked", selectedCities);
        sharedPreferences.setString("eskonAccountNumber", eskonAccountNumber);
        sharedPreferences.setString("contactNumber", contactNumber);
        sharedPreferences.setString("telephone_number", telephone_number);
//      showToastMessage('Some thing Went Wrong try later');

        if (!widget.previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          widget.applicant_id = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data['application_id']);
          widget.applicant_id = data['application_id'];
        }

        setState(() {
          print('done');

          _isLoading = false;
//      print(token);
          showToastMessage('Form Submitted');
          widget.previousFormSubmitted = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new ApplicationStatus(
                  widget.applicant_id, widget.previousFormSubmitted)));
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
    } else {
      setState(() {
        _isLoading = false;
      });
      print("B1 Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new ApplicationStatus(
              widget.applicant_id, widget.previousFormSubmitted)));
    }
  }

  bool _checked = true;
  bool _checkedG = false;
  bool _checkedUn = false;
  bool _checkedEm = false;
  bool _checkedCh = false;
  bool _checkedESM = false;
  bool _checkedDI = false;
  var checkBoxValue;
  Future<Null> _selectDateYear(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      dateFormat: 'yyyy',
      minDateTime: DateTime(1901, 1),
      maxDateTime: DateTime(2100),
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          print(dateTime.year);
//              _dateTime = dateTime;
          FinancialYearController.value =
              TextEditingValue(text: dateTime.year.toString());
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        elevation: .5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.func(widget.applicant_id);
//            Navigator.pushNamed(context, '/personalinformationA1');
//            Navigator.of(context).popAndPushNamed('/personalinformationA1');
            // do something
//            Navigator.of(context).pop(PageRouteBuilder(
//                pageBuilder: (_, __, ___) => PersonalInformationA1(role,widget.applicant_id)));
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
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
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
                /// Text header "Welcome To" (Click to open code)

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 30),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: standNumberController,
//                            autofocus: true,
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      onChanged: (value) {
                        print('value holder');
                        print(value.length - 32);
//                        if (value.length < 33){
                        print('kam hia');
//                            print( 33 - value.length);
//                            var addRemaingZero =  32 - value.length;
//                            print(addRemaingZero);

                        var valueHolder = maskFormatter.getUnmaskedText();

                        print(valueHolder.length);
//                            print(valueHolder.length - 32);
//                            print(valueHolder.length);
                        print(valueHolder.padRight(27, '0'));
                        var zeroList = valueHolder.padRight(27, '0');
                        formattedString = '';
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
                        setState(() {
//                          standNumberController.text = formattedString;
                        });
                        print('new string');
//                            print(formattedString);
//                            standNumberController.value = maskFormatter.updateMask(mask: "### ### ######## ##### #### ####");
//                        }
                      },

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
                          labelText: ' Stand/ ERF number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

//                      keyboardType: TextInputType.text,
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
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return _MyDialog(
                                cities: allCities,
                                selectedCities: selectedCities == null
                                    ? serviceLinkedHolder
                                    : selectedCities,
                                onSelectedCitiesListChanged: (cities) {
                                  setState(() {
                                    selectedCities = cities;
                                    serviceLinkedHolder = cities;
                                  });
                                  print(selectedCities);
                                  print('selectedCities');
                                });
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 0, right: 0),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(5, 5)),
                          border: Border.all(color: Colors.grey)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Services linked to the stand",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'opensans',
                                color: Color(0xff626A76)),
                          ),
                          selectedCities.length != 0
                              ? Row(
                                  children: List.generate(selectedCities.length,
                                      (index) {
                                    return Text(
                                      selectedCities[index].toString() + ",",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'opensans',
                                          color: Color(0xff626A76)),
                                    );
                                  }),
                                )
                              : serviceLinkedHolder != null
                                  ? Row(
                                      children: List.generate(
                                          serviceLinkedHolder.length, (index) {
                                        return Text(
                                          serviceLinkedHolder[index]
                                                  .toString() +
                                              ",",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'opensans',
                                              color: Color(0xff626A76)),
                                        );
                                      }),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'opensans',
                                              color: Color(0xff626A76)),
                                        )
                                      ],
                                    )
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 0),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: wardNumberController,
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
                          labelText: 'Ward Number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),
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
                      controller: eskomAccountNumberController,
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
                          labelText: 'Eskom Account Number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

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
                        controller: emailController,
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
                            labelText: 'Email',
//                          hintText: 'Email' : emailStorage ,
                            labelStyle: new TextStyle(
                                color: const Color(0xff626a76),
                                fontFamily: 'opensans'),
                            focusColor: AppColors.PRIMARY_COLOR,
                            alignLabelWithHint: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(4.0),
                                borderSide:
                                    new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                            fontFamily: 'opensans',
                            color: AppColors.PRIMARY_COLOR,
                            fontSize: 13.0),
                      ),
                    )),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    height: 55,
                    child: new TextFormField(
                      controller: contectNumberController,
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
                          labelText: 'Cell Phone Number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.number,
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
                      controller: telephoneNumberController,
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
                          labelText: 'Telephone Number',
                          labelStyle: new TextStyle(
                              color: const Color(0xff626a76),
                              fontFamily: 'opensans'),
                          focusColor: AppColors.PRIMARY_COLOR,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(4.0),
                              borderSide:
                                  new BorderSide(color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),

                      keyboardType: TextInputType.number,
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
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor:
                            AppColors.PRIMARY_COLOR, //color of the main banner
                        accentColor: AppColors.PRIMARY_COLOR,
                        colorScheme: ColorScheme.light().copyWith(
                          primary: AppColors.PRIMARY_COLOR,
                          secondary: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              if (FocusScope.of(context).isFirstFocus) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              }
                              _selectDateYear(context);
                            },
                            child: AbsorbPointer(
                              child: new TextFormField(
                                controller: FinancialYearController,
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
                                    labelText: 'Financial Year',
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
                                            color: Colors.blue[700])), floatingLabelBehavior: FloatingLabelBehavior.auto),
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
//                  Navigator.of(context).push(PageRouteBuilder(
//                      pageBuilder: (_, __, ___) => PersonalInformationA1()));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
//                alignment: Alignment.bottomRight,
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff4d4d4d),
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
                            child: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.white,
                        )),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    currentFocus.focusedChild.unfocus();
                  }
                  formClicked();
//                      Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> ApplicationStatus()));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
//                alignment: Alignment.bottomRight,
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
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
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
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
          )
        ],
      )),
    );
  }
}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.cities,
    this.selectedCities,
    this.onSelectedCitiesListChanged,
  });

  final List<String> cities;
  final List<String> selectedCities;
  final ValueChanged<List<String>> onSelectedCitiesListChanged;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<String> _tempSelectedCities = [];

  @override
  void initState() {
    _tempSelectedCities = widget.selectedCities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 380,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 30, bottom: 20, left: 20),
                child: Text(
                  'Select Services linked to the stand',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'opensans',
                      color: Color(0xff626A76)),
                )),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  itemCount: widget.cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = widget.cities[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            cityName,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff626A76),
                                fontFamily: ('opensans')),
                          ),
                          activeColor: Color(0xffde626c),
                          value: _tempSelectedCities.contains(cityName),
                          onChanged: (bool value) {
                            if (value) {
                              print(value);
                              print('data');
                              print(value);
                              if (!_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  print('data22');
                                  _tempSelectedCities.add(cityName);
                                });

                                if (_tempSelectedCities.contains('None')) {
                                  setState(() {
                                    print('data23');
                                    _tempSelectedCities.clear();
                                    _tempSelectedCities.add('None');
                                    _tempSelectedCities.add(cityName);
                                    _tempSelectedCities.remove('None');
                                  });
                                }
                              }
                            } else {
                              if (_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  _tempSelectedCities.removeWhere(
                                      (String city) => city == cityName);
                                });
                                if (_tempSelectedCities.contains('None')) {
                                  setState(() {
                                    print(_tempSelectedCities);
                                    _tempSelectedCities.clear();
                                    _tempSelectedCities.add('None');
                                  });
                                }
                              }
                            }
                            widget.onSelectedCitiesListChanged(
                                _tempSelectedCities);
                          }),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
//                        _tempSelectedCities.clear();
//                        _tempSelectedCities.add('None');
                      });
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xffde626c),
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ),
//                  InkWell(
//                    onTap: (){
//                      Navigator.pop(context);
//                    },
//                    child: Text(
//                      'OK',
//                      style: TextStyle(color: Colors.black),
//                    ),
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
