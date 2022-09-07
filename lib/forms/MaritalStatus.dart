import 'dart:convert';

import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/forms/attachments.dart';
import 'package:rustenburg/forms/bank_account_details.dart';
import 'package:rustenburg/global.dart';
import 'package:flutter/material.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:rustenburg/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rustenburg/app_color.dart';

class MaritalStatus extends StatefulWidget {
  int applicant_id;
  String gross_monthly_income;
  bool previousFormSubmitted;

  MaritalStatus(
      this.applicant_id, this.gross_monthly_income, this.previousFormSubmitted);

  @override
  _MaritalStatusState createState() => _MaritalStatusState();
}

class _MaritalStatusState extends State<MaritalStatus> {
  bool _isLoading = false;
  bool _checked = true;
  bool _checkedG = false;
  bool _checkedUn = false;
  bool _checkedEm = false;
  bool _checkedCh = false;
  bool _checkedESM = false;
  bool _checkedDI = false;

  String checkBoxValue = 'married';
  ServicesRequest request = ServicesRequest();

  @override
  void initState() {
    super.initState();
    print('id agye marital');
    getCheckValues();
    print(widget.gross_monthly_income);
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
      if (_checked == null) {
        _checked = true;
        _checked = sharedPreferences.getBool('_checkedM');
      }
      if (_checkedUn == null) {
        _checkedUn = false;
        _checkedUn = sharedPreferences.getBool('_checkedUnM');
      }
      if (_checkedG == null) {
        _checkedG = false;
        _checkedG = sharedPreferences.getBool('_checkedGM');
      }
      if (_checkedEm == null) {
        _checkedEm = false;
        _checkedEm = sharedPreferences.getBool('_checkedEmM');
      }
      if (_checkedCh == null) {
        _checkedCh = false;
        _checkedCh = sharedPreferences.getBool('_checkedChM');
      }
      if (_checkedESM == null) {
        _checkedESM = false;
        _checkedESM = sharedPreferences.getBool('_checkedESMM');
      }
      if (_checkedDI == null) {
        _checkedDI = false;
        _checkedDI = sharedPreferences.getBool('_checkedDIM');
      }

//      _checkedG=sharedPreferences.getBool('_checkedGM');
//      _checkedUn=sharedPreferences.getBool('_checkedUnM');
//      _checkedEm=sharedPreferences.getBool('_checkedEmM');
//      _checkedCh=sharedPreferences.getBool('_checkedCh');
//      _checkedESM=sharedPreferences.getBool('_checkedESMM');
//      _checkedDI=sharedPreferences.getBool('_checkedDIM');
    });
  }

  Future<Null> submitForm(checkBoxValue) async {
    await request.ifInternetAvailable();
    print("Widget.previousFormSubmitted :::: ${widget.previousFormSubmitted}");
    print("Widget.applicantId :::: ${widget.applicant_id}");
    print("Widget.grossMonthlyIncome :::: ${widget.gross_monthly_income}");
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var applicant_id = sharedPreferences.getInt('applicant_id');
    print('okay');
    print(applicant_id);
    print('okay');
    Map<String, dynamic> data = {
      'application_id': applicant_id,
      'marital_status': checkBoxValue
//      'role': _selectedType
    };
    LocalStorage.localStorage.saveFormData(data);
    var jsonResponse;
    http.Response response;
    if (MyConstants.myConst.internet) {
      if (widget.previousFormSubmitted) {
        response = await http.post(
            Uri.parse(
                "${MyConstants.myConst.baseUrl}api/v1/users/update_application?application_id=${widget.applicant_id}&marital_status=$checkBoxValue"),
            headers: {
              'Content-Type': 'application/json',
              'uuid': userID,
              'Authentication': authToken
            });
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
        print('sss');
        LocalStorage.localStorage.clearCurrentApplication();
        jsonResponse = jsonDecode(response.body);
        print('income');
        print(jsonResponse['gross_monthly_income']);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('_checkedM', _checked);
        await prefs.setBool('_checkedGM', _checkedG);
        await prefs.setBool('_checkedUnM', _checkedUn);
        await prefs.setBool('_checkedEmM', _checkedEm);
        await prefs.setBool('_checkedChM', _checkedCh);
        await prefs.setBool('_checkedESMM', _checkedESM);
        await prefs.setBool('_checkedDIM', _checkedDI);

        if (!widget.previousFormSubmitted) {
          var apid;
          apid = jsonDecode(response.body);
          sharedPreferences.setInt('applicant_id', apid['application_id']);
          widget.applicant_id = apid['application_id'];
        } else {
          sharedPreferences.setInt('applicant_id', data['application_id']);
          widget.applicant_id = data['application_id'];
        }

//      showToastMessage('Some thing Went Wrong try later');
        // sharedPreferences.setInt('applicant_id', data['application_id']);
        setState(() {
          print('done');

          _isLoading = false;
//      print(token);
          showToastMessage('Form Submitted');
          widget.previousFormSubmitted = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => new BankAccountDetails(
                  widget.applicant_id,
                  widget.gross_monthly_income,
                  widget.previousFormSubmitted
              )
              // new Attachments(
              //     widget.applicant_id,
              //     widget.gross_monthly_income,
              //     widget.previousFormSubmitted)
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
    } else {
      setState(() {
        _isLoading = false;
      });
      print("Marital Status Navigated from Else");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new Attachments(
              widget.applicant_id,
              widget.gross_monthly_income,
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
//            Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> MaritalStatus(widget.applicant_id)));
          },
        ),

        backgroundColor: Color(0xffde626c),
        title: Text(
          'MARITAL STATUS',
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
                          'Married',
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
                        onChanged: (bool value) {
                          setState(() {
                            _checked = value;
                            _checkedG = false;
                            _checkedUn = false;
                            _checkedCh = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            checkBoxValue = 'married';
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
                          'Single',
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
                        onChanged: (bool value) {
                          setState(() {
                            _checkedG = value;
                            _checked = false;
                            _checkedUn = false;
                            _checkedCh = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            checkBoxValue = 'single';
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

//                    Padding(
//                      padding: const EdgeInsets.only(
//                          left: 0.0, right: 20, bottom: 0, top: 0),
//                      child: Container(
//                          height: 50,
//                          child: CheckboxListTile(
//                            checkColor: Color(0xffffffff),
//                            activeColor: Color(0xffde626c),
//                            title: Text('Customary Marriage' ,
//                              style: TextStyle(
//                                fontFamily: 'Open Sans',
//                                fontSize: 12,
//                                color: const Color(0xff6f6f6f),
//                                fontWeight: FontWeight.w700,
//                                height: 1.5,
//                              ),),
//                            value: _checkedUn,
//                            controlAffinity: ListTileControlAffinity.leading,
//                            onChanged: (bool value){
//                              setState(() {
//                                _checkedG = false;
//                                _checked = false;
//                                _checkedCh = false;
//                                _checkedEm = false;
//                                _checkedESM = false;
//                                _checkedDI = false;
//                                _checkedUn = value;
//                                checkBoxValue = 'customary_marriage';
//                              });
//                            },
//                          )
//                      ),
//                    ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Widowed',
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
                        onChanged: (bool value) {
                          setState(() {
                            _checkedCh = value;
                            _checkedG = false;
                            _checked = false;
                            _checkedEm = false;
                            _checkedESM = false;
                            _checkedDI = false;
                            _checkedUn = false;
                            checkBoxValue = 'widowed';
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

//                    Padding(
//                      padding: const EdgeInsets.only(
//                          left: 0.0, right: 20, bottom: 0, top: 0),
//                      child: Container(
//                          height: 50,
//                          child: CheckboxListTile(
//                            checkColor: Color(0xffffffff),
//                            activeColor: Color(0xffde626c),
//                            title: Text('Living Together' ,
//                              style: TextStyle(
//                                fontFamily: 'Open Sans',
//                                fontSize: 12,
//                                color: const Color(0xff6f6f6f),
//                                fontWeight: FontWeight.w700,
//                                height: 1.5,
//                              ),),
//                            value: _checkedEm,
//                            controlAffinity: ListTileControlAffinity.leading,
//                            onChanged: (bool value){
//                              setState(() {
//                                _checkedCh = false;
//                                _checkedG = false;
//                                _checked = false;
//                                _checkedESM = false;
//                                _checkedDI = false;
//                                _checkedUn = false;
//                                _checkedEm = value;
//                                checkBoxValue = 'living_together';
//                              });
//                            },
//                          )
//                      ),
//                    ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Divorced',
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
                        onChanged: (bool value) {
                          setState(() {
                            _checkedCh = false;
                            _checkedG = false;
                            _checked = false;
                            _checkedDI = false;
                            _checkedUn = false;
                            _checkedEm = false;
                            _checkedESM = value;
                            checkBoxValue = 'divorced';
                          });
                        },
                      )),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(top: 5),

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

//                    Padding(
//                      padding: const EdgeInsets.only(
//                          left: 0.0, right: 20, bottom: 20, top: 0),
//                      child: Container(
//                          height: 50,
//                          child: CheckboxListTile(
//                            checkColor: Color(0xffffffff),
//                            activeColor: Color(0xffde626c),
//                            title: Text('ID of Spouse if not single' ,
//                              style: TextStyle(
//                                fontFamily: 'Open Sans',
//                                fontSize: 12,
//                                color: const Color(0xff6f6f6f),
//                                fontWeight: FontWeight.w700,
//                                height: 1.5,
//                              ),),
//                            value: _checkedDI,
//                            controlAffinity: ListTileControlAffinity.leading,
//                            onChanged: (bool value){
//                              setState(() {
//                                _checkedCh = false;
//                                _checkedG = false;
//                                _checked = false;
//                                _checkedUn = false;
//                                _checkedEm = false;
//                                _checkedESM = false;
//                                _checkedDI = value;
//                                checkBoxValue = 'spouse_id';
//                              });
//                            },
//                          )
//                      ),
//                    ),

//                    Padding(
//                      padding: EdgeInsets.only(top:5),
//                      child: Container(
//                        margin: EdgeInsets.only(left: 20,right: 20),
//                        decoration: BoxDecoration(
//                          color: const Color(0xffffffff),
//                          border: Border(
//
//                            bottom: BorderSide( //                    <--- top side
//                              color: Color(0xffEEEEEE),
//                              width: 1.0,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
              ],
            ),
          ),

          SizedBox(height: 90,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  //    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> ApplicationStatus(widget.applicant_id)));
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
                onTap: (){
                  print("Gesture Detector");
                  submitForm(checkBoxValue);
                },
              // onTap: (){
              //     // {
              //        // Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> Declaration(widget.applicant_id)));
              //
              //     // if (_isLoading) {
              //     //   submitForm(checkBoxValue);
              //     // }
              //   },
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
                        child: InkWell(
                          onTap: () {
                            print("INK Well");
                            return submitForm(checkBoxValue);
                          },
                          child: Container(
                              child: _isLoading
                                  ? Container(
                                      height: 20,
                                      width: 20,
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
                        ),
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
