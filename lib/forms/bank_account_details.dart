import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rustenburg/model/bank_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans/Constants.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import '../networkRequest/services_request.dart';
import 'attachments.dart';
import '../app_color.dart';

class BankAccountDetails extends StatefulWidget {
  int applicant_id;
  String gross_monthly_income;
  bool previousFormSubmitted;

  BankAccountDetails(
      this.applicant_id, this.gross_monthly_income, this.previousFormSubmitted);

  @override
  State<BankAccountDetails> createState() => _BankAccountDetailsState();
}

class _BankAccountDetailsState extends State<BankAccountDetails> {
  bool _isLoading = false;
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
    setState(() {});
  }

  Future<Null> submitForm(
    List<String> bankName,
    List<String> bankAc,
    List<String> branchCode,
  ) async {
    setState(() {
      _isLoading = true;
    });
    print(bankName.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    // checkInternetAvailability();
    await request.ifInternetAvailable();
    // checkInternetAvailability();
    // LocalStorage.localStorage.saveFormData(data);
    if (MyConstants.myConst.internet) {

      BankDetailsModel bankDetailsModel = BankDetailsModel();
      bankDetailsModel.bankDetailsAttributes=[];

      for (int i = 0; i < 3; i++) {
        if (bankName[i].isNotEmpty &&
            bankAc[i].isNotEmpty &&
            branchCode[i].isNotEmpty) {
          bankDetailsModel.bankDetailsAttributes.add(
            BankDetailsAttributes(
                bankNumber: bankName[i],
                bankAccountNumber: bankAc[i],
                branchCode: branchCode[i],
            ),
          );
        }
      }

      bankDetailsModel.applicationId = widget.applicant_id;

      // Map<String, dynamic> data = {
      //   'bank_details_attributes[0][bank_number]': bankNumber,
      //   'bank_details_attributes[0][bank_account_number]': bankAcNo,
      //   'bank_details_attributes[0][branch_code ]': branchCode,
      //   'application_id': widget.applicant_id
      // };
      var jsonResponse;
      http.Response response = await http.post(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID,
            'Authentication': authToken
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
        setState(() {
          print('done');

          _isLoading = false;
          widget.previousFormSubmitted = true;
          showToastMessage('Form Submitted');
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => Attachments(widget.applicant_id,
                  widget.gross_monthly_income, widget.previousFormSubmitted)));
          // previousFormSubmitted = true;
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) => new PersonalInformationB1(
          //         applicant_id, function, previousFormSubmitted)));
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
  }

  // else {
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   print("A1 Navigated from Else");
  //   print("A1 form submission status :::: $previousFormSubmitted");
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => new PersonalInformationB1(
  //           widget.applicant_id, function, previousFormSubmitted)));
  // }
  // }

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
          },
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'Bank Account Details',
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
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                itemCount: counter,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.only(top: 20),
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
                    child: Wrap(
                      children: [
                        Center(
                          child: Text(
                            "Bank Detail No ${index + 1}",
                            style: TextStyle(
                                color: const Color(0xff626a76),
                                fontFamily: 'opensans'),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 20, top: 0),
                          child: Container(
                            height: 55,
                            child: new TextFormField(
                              controller: bankName[index],
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
                                  labelText: 'Bank Name',
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
                                          color: Colors.blue[700])),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                              keyboardType: TextInputType.name,
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
                              controller: accountNoCon[index],
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
                                  labelText: 'Account No',
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
                                          color: Colors.blue[700])),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
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
                              controller: branchCodeCon[index],
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
                                  labelText: 'Branch Code',
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
                                          color: Colors.blue[700])),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                              keyboardType: TextInputType.number,
                              style: new TextStyle(
                                  fontFamily: 'opensans',
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 13.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            MaterialButton(
                color: AppColors.PRIMARY_COLOR,
                onPressed: () async {
                  setState(() {
                    if (counter < 3) {
                      counter = counter + 1;
                    } else {
                      showToastMessage('You have add only three bank details.');
                    }
                    print(counter);
                  });
                },
                child: Text(
                  "Add More",
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              height: 10,
            ),
            // MaterialButton(
            //     color:  const Color(0xff4d4d4d),
            //     onPressed: () async {
            //       setState(() {
            //
            //       });
            //     },
            //     child: Text(
            //       "Remove",
            //       style: TextStyle(color: Colors.white),
            //     )),
            SizedBox(
              height: 90,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
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
                  onTap: () {
                    print("Gesture Detector");
                    // submitForm(checkBoxValue);
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
                              setState(() {
                                _isLoading = true;
                              });
                              submitForm(
                                bankName.map((e) => e.text).toList(),
                                accountNoCon.map((e) => e.text).toList(),
                                branchCodeCon.map((e) => e.text).toList(),

                                // bankAccCon[0].text,
                                // accountNoCon[0].text,
                                // branchCodeCon[0].text,
                                // bankAccCon[1].text,
                                // accountNoCon[1].text,
                                // branchCodeCon[1].text,
                                // bankAccCon[2].text,
                                // accountNoCon[2].text,
                                // branchCodeCon[2].text,
                              );
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         new Attachments(
                              //             widget.applicant_id,
                              //             widget.gross_monthly_income,
                              //             widget.previousFormSubmitted)));
                              // return submitForm(checkBoxValue);
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
        ),
      ),
    );
  }
}
