import 'dart:convert';

import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/forms/MaritalStatus.dart';
import 'package:lesedi/forms/PersonalInformationB1.dart';
import 'package:lesedi/forms/attachments.dart';
import 'package:lesedi/global.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/networkRequest/services_request.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lesedi/app_color.dart';

class ApplicationStatus extends StatefulWidget {
  int applicant_id;
  bool previousFormSubmitted;

  ApplicationStatus(this.applicant_id, this.previousFormSubmitted);

  @override
  _ApplicationStatusState createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends State<ApplicationStatus> {
  bool _isLoading = false;
  bool? _checked = true;
  bool? _checkedG = false;
  bool? _checkedUn = false;
  bool? _checkedEm = false;
  bool? _checkedCh = false;
  bool? _checkedESM = false;
  bool? _checkedDI = false;
  bool? _checkedGMI = false;

  var grossMonthlyStorage;
  var remarksStorage;
  ServicesRequest request = ServicesRequest();

  String checkBoxValue = 'pensioner';

  @override
  void initState() {
    super.initState();
    print('daya');
    getCheckValues();
    print(widget.applicant_id);
    checkInternetAvailability();
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getCheckValues() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
//
      if (_checked == null) {
        _checked = true;
        _checked = sharedPreferences.getBool('_checked');
      }

      if (_checkedG == null) {
        _checkedG = false;
        _checkedG = sharedPreferences.getBool('_checkedG');
      }

      if (_checkedUn == null) {
        _checkedUn = false;
        _checkedUn = sharedPreferences.getBool('_checkedUn');
      }
      if (_checkedEm == null) {
        _checkedEm = false;
        _checkedEm = sharedPreferences.getBool('_checkedEm');
      }
      if (_checkedCh == null) {
        _checkedCh = false;
        _checkedCh = sharedPreferences.getBool('_checkedCh');
      }
      if (_checkedESM == null) {
        _checkedESM = false;
        _checkedESM = sharedPreferences.getBool('_checkedESM');
      }
      if (_checkedDI == null) {
        _checkedDI = false;
        _checkedDI = sharedPreferences.getBool('_checkedDI');
      }

      if (_checkedGMI == null) {
        _checkedGMI = false;
        _checkedGMI = sharedPreferences.getBool('_checkedGMI');
      }

      grossMonthlyStorage = sharedPreferences.getString('grossMonthlyStorage');

      if (grossMonthlyStorage != null) {
        grossMonthlyController =
            TextEditingController(text: '$grossMonthlyStorage');
      }
      if (remarksStorage != null) {
        remarksController = TextEditingController(text: '$remarksStorage');
      }
    });
  }

  TextEditingController grossMonthlyController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  Future<Null> submitForm(checkBoxValue) async {
    setState(() {
      _isLoading = true;
    });
    print("Previous Form Submitted ::::: ${widget.previousFormSubmitted}");
    await request.ifInternetAvailable();
    // checkInternetAvailability();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    // print('okay');
    print("Applicant ID is ::: $applicant_id");
    print("Widget Applicant ID is ::: ${widget.applicant_id}");
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
      if (widget.previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application?application_id=${widget.applicant_id}&employment_status=$checkBoxValue&gross_monthly_income=${grossMonthlyController.text}"),
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

        await prefs.setBool('_checked', _checked!);
        await prefs.setBool('_checkedG', _checkedG!);
        await prefs.setBool('_checkedUn', _checkedUn!);
        await prefs.setBool('_checkedEm', _checkedEm!);
        await prefs.setBool('_checkedCh', _checkedCh!);
        await prefs.setBool('_checkedDI', _checkedDI!);
        await prefs.setBool('_checkedGMI', _checkedGMI!);
        sharedPreferences.setString(
            "grossMonthlyStorage", grossMonthlyController.text);
        if (!widget.previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          widget.applicant_id = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data?['application_id']);
          widget.applicant_id = data?['application_id'];
        }

        // print('data');

//      showToastMessage('Some thing Went Wrong try later');
        // sharedPreferences.setInt('applicant_id', data['application_id']);
        setState(() {
          print('done');

          _isLoading = false;
//      print(token);
          showToastMessage('Form Submitted');
          widget.previousFormSubmitted = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new MaritalStatus(
                  widget.applicant_id,
                  grossMonthlyController.text,
                  widget.previousFormSubmitted)));
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
      print("ApplicationStatus Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new MaritalStatus(
              widget.applicant_id,
              grossMonthlyController.text,
              widget.previousFormSubmitted)));
    }
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
            // do something
            Navigator.pop(context);
//            Navigator.pop(context , '/personalinformationB1');
//            Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> PersonalInformationB1()));
          },
        ),
        backgroundColor: Color(0xffde626c),
        title: Text(
          'EMPLOYMENT STATUS',
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
            margin: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 40),
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

//                / Text header "Welcome To" (Click to open code)

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 10),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        dense: false,
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Pensioner',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checked,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checked = value;
                            _checkedG = false;
                            _checkedUn = false;
                            _checkedCh = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedGMI = false;
                            _checkedDI = false;

                            checkBoxValue = 'pensioner';
                            print(checkBoxValue);
                            print(_checked);
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Grantee',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedG,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedG = value;
                            _checked = false;
                            _checkedUn = false;
                            _checkedCh = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedGMI = false;
                            _checkedDI = false;
                            checkBoxValue = 'grantee';
                            print(checkBoxValue);
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Unemployed',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedUn,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedG = false;
                            _checked = false;
                            _checkedCh = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            _checkedUn = value;
                            _checkedGMI = false;
                            checkBoxValue = 'unemployed';
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Childheaded Houshold',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedCh,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedCh = value;
                            _checkedG = false;
                            _checked = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            _checkedUn = false;
                            _checkedGMI = false;
                            checkBoxValue = 'childheaded_household';
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Employed',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedEm,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedCh = false;
                            _checkedG = false;
                            _checked = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            _checkedUn = false;
                            _checkedEm = value;
                            _checkedGMI = false;
                            checkBoxValue = 'employed';
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Employed by Government ',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedESM,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedCh = false;
                            _checkedG = false;
                            _checked = false;
                            _checkedDI = false;
                            _checkedUn = false;
                            _checkedEm = false;
                            _checkedESM = value;
                            _checkedGMI = false;
                            checkBoxValue = 'employ_by_government';
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Director',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: _checkedDI,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedCh = false;
                            _checkedG = false;
                            _checked = false;
                            _checkedUn = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = value;
                            _checkedGMI = false;
                            checkBoxValue = 'director';
                          });
                        },
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(' Household Gross Monthly Income (R)'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: new TextFormField(
                      controller: grossMonthlyController,
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
                          labelText: 'Gross Monthly Income (R)',
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

                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                          fontFamily: 'opensans',
                          color: AppColors.PRIMARY_COLOR != null
                              ? AppColors.PRIMARY_COLOR
                              : Color(0xffDE626C),
                          fontSize: 13.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Remarks'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: new TextFormField(
                      controller: remarksController,
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
                          labelText: 'Remarks',
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
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
//                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> PersonalInformationB1(widget.applicant_id)));
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
                    currentFocus.focusedChild?.unfocus();
                  }
                     // Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> MaritalStatus(1,"",false)));
                  if (!_isLoading) {
                    submitForm(checkBoxValue);
                  }
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
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
