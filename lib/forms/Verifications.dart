import 'dart:convert';

import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/applicants/view/allApplicants.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:lesedi/model/applicant_info_model.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/supervisor/view/supervisorAllApplicants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/verifications_listing_model.dart';
import 'package:lesedi/utils/app_color.dart';

class Verifications extends StatefulWidget {

  int id;
  Verifications(this.id);

  @override
  _VerificationsState createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {

  @override
  void initState() {
    super.initState();
    print('details');
    getApplicantDetails();
    print(widget.id);
    checkInternetAvailability();

  }




  bool? verificationIdsWithThirdPartyHomeAffairs;
  bool? verificationOfEmploymentStatusAndSalaryBracketWithExperian;
  bool? verificationOfTheEmployerOfApplicantWithDoLOrExperian;
  bool? verificationOfApplicantCreditStatusWithExperian;
  bool? verificationOfApplicantCIPCDirectorshipWithCIPC;
  bool? verificationOfApplicationIDValidation;


  String? home_affairs;
  String? employment_status_and_salary;
  String? employer_by_dol_or_experian;
  String? credit_status_by_experian;
  String? cipc;
  String? id_veri;




  bool? home_affairs_value;
  bool? employment_status_and_salary_value;
  bool? employer_by_dol_or_experian_value;
  bool? credit_status_by_experian_value;
  bool? cipc_value;
  bool? id_validation;

  ServicesRequest request = ServicesRequest();



//  Map<String, dynamic> values = {
//    'foo': true,
//    'bar': false,
//  };



  var jsonResponse;


Future<void> checkInternetAvailability() async {
    setState(() async {
      await request.ifInternetAvailable();
    });
  }
  getApplicantDetails() async{
    print('datat values');
//    print(values);

    verificationListing responseM ;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');

    http.Response response = await http
        .get(Uri.parse("${MyConstants.myConst.baseUrl}api/v1/users/application_verifications?application_id=${widget.id}"),
        headers: {
          'Content-Type': 'application/json',
          'uuid' : userID??"",
          'Authentication' : authToken??""
        }
    );
    print(response);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);

      Map<String,dynamic>  dataHolder = jsonResponse;
      print('jsonResponse');
      print(jsonResponse);
      var dataSort =  dataHolder.keys.toList();

      print(dataSort);

      verificationListing models = verificationListing.fromJson(dataHolder);
      responseM = models;
      print('name');
      print(responseM);

      setState(() {
        print('done');
        verificationIdsWithThirdPartyHomeAffairs = responseM.salaryIncomeIndicator;
        verificationOfEmploymentStatusAndSalaryBracketWithExperian = responseM.employmentStatus;
        verificationOfTheEmployerOfApplicantWithDoLOrExperian = responseM.employerName;
        verificationOfApplicantCreditStatusWithExperian = responseM.creditStatus;
        verificationOfApplicantCIPCDirectorshipWithCIPC = responseM.cIPCDirectorship;
        verificationOfApplicationIDValidation= responseM.iDValidation;
        print('done1');
        print(verificationIdsWithThirdPartyHomeAffairs);
        print('done2');
        print(verificationOfEmploymentStatusAndSalaryBracketWithExperian);
        print('done3');
        print(verificationOfTheEmployerOfApplicantWithDoLOrExperian);
        print('done4');
        print(verificationOfApplicantCreditStatusWithExperian);
        print('done5');
        print(verificationOfApplicantCIPCDirectorshipWithCIPC);


          if(home_affairs_value == null){
            home_affairs_value  = verificationIdsWithThirdPartyHomeAffairs;
          }
          if(employment_status_and_salary_value == null){
            employment_status_and_salary_value  = verificationOfEmploymentStatusAndSalaryBracketWithExperian;
          }
          if (employer_by_dol_or_experian_value == null){
            employer_by_dol_or_experian_value = verificationOfTheEmployerOfApplicantWithDoLOrExperian;
          }
          if (credit_status_by_experian_value == null){
            credit_status_by_experian_value = verificationOfApplicantCreditStatusWithExperian;
          }
          if (cipc_value == null){
            cipc_value = verificationOfApplicantCIPCDirectorshipWithCIPC;
          }
        if (id_validation == null){
          id_validation = verificationOfApplicationIDValidation;
        }

      });
    }
    else{
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(jsonResponse['message'].toString().replaceAll("[\\[\\](){}]",""));
      });
    }
  }




  bool _isLoading = false;
  Future<Null> submitForm() async {
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
    Map data = {
//      'applicant_id': ${widget.id},
//      home_affairs : home_affairs_value,
//      employment_status_and_salary: employment_status_and_salary_value,
//      employer_by_dol_or_experian :employer_by_dol_or_experian_value,
//      credit_status_by_experian:credit_status_by_experian_value,
//      cipc:cipc_value
//      'role': _selectedType
    };
    var jsonResponse;
    String url = '${MyConstants.myConst.baseUrl}api/v1/users/verify_application?application_id=${widget.id}&salary_indicator=$home_affairs_value&employment_status=$employment_status_and_salary_value&employer_name=$employer_by_dol_or_experian_value&credit_status=$credit_status_by_experian_value&Cipc_directorship=$cipc_value&id_validation=$id_validation';
//    String urlTesting = '${MyConstants.myConst.baseUrl}api/v1/users/verify_application?application_id=${widget.id}&home_affairs=$home_affairs_value&employment_status_and_salary=$employment_status_and_salary_value&employer_by_dol_or_experian=false&credit_status_by_experian=false&cipc=false';
    print(url);
    http.Response response = await http
        .post(Uri.parse(url),
        headers: {
//          'Content-Type': 'application/json',
          'uuid' : userID??"",
          'Authentication' : authToken??""
        },
//        body: data
    );
  print('data');
    print(response);

    print(response.body);
    print(data);
    if (response.statusCode == 200) {
      print('sss');
      jsonResponse = jsonDecode(response.body);

//      showToastMessage('Some thing Went Wrong try later');
//      sharedPreferences.setInt('applicant_id', jsonResponse['applicant_id']);
      setState(() {
        print('done');

        _isLoading = false;
//      print(token);
        showToastMessage('Form Submitted');

      });
    }
    else{
      setState(() {
        _isLoading = false;
        jsonResponse = json.decode(response.body);
        print('data');
//        print(jsonResponse);
        showToastMessage(jsonResponse['message']);
      });
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        elevation: .5,
        centerTitle: true,
        leading:  IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
            Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> SuperVisorAllApplicants()));

          },
        ),

        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text('VERIFICATIONS' ,
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 30,right: 30 , top: 50, bottom: 40),
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

                    Container(
//                      height: 400,
                      padding: EdgeInsets.only(top:30,bottom: 30,left: 0,right: 0),
                      child:  jsonResponse!=null ? ListView(
                        shrinkWrap: true,
                        children: jsonResponse.keys.map<Widget>((String key) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              border: Border(

                                bottom: BorderSide( //                    <--- top side
                                  color: Color(0xffEEEEEE),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: new CheckboxListTile(
                              checkColor: Color(0xffffffff),
                              activeColor: AppColors.PRIMARY_COLOR,
                              dense: false,
                              title: new Text(key , style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 12,
                                color: const Color(0xff6f6f6f),
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              )),
                              value: jsonResponse[key],
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? value) {
                                setState(() {
                                  jsonResponse[key] = value;
                                  print(value);
                                  print(key);
                                  if (key =='Salary/Income Indicator'){
                                    key = 'salary_indicator';
                                    print('key');
                                    print(key);
                                    home_affairs = key;
                                    if(home_affairs_value == null){
                                      home_affairs_value  = verificationIdsWithThirdPartyHomeAffairs;
                                    }
                                    home_affairs_value = value;
                                    print('value');
                                    print(home_affairs_value);
                                  }
                                  else if(key == 'Employment Status'){
                                    key = 'employment_status';


                                    employment_status_and_salary = key;
                                    if(employment_status_and_salary_value == null){
                                      employment_status_and_salary_value  = verificationOfEmploymentStatusAndSalaryBracketWithExperian;
                                    }
                                    employment_status_and_salary_value = value;
                                  }
                                  else if(key == 'Employer Name'){
                                    key = 'employer_name';

                                    if (employer_by_dol_or_experian_value == null){
                                      employer_by_dol_or_experian_value = verificationOfTheEmployerOfApplicantWithDoLOrExperian;
                                    }

                                    employer_by_dol_or_experian = key;
                                    employer_by_dol_or_experian_value = value;
                                  }
                                  else if(key == 'Credit Status'){
                                    key = 'credit_status';
                                    if (credit_status_by_experian_value == null){
                                      credit_status_by_experian_value = verificationOfApplicantCreditStatusWithExperian;
                                    }
                                    credit_status_by_experian = key;
                                    credit_status_by_experian_value = value;
                                  }
                                  else if(key == 'CIPC Directorship'){
                                    key = 'Cipc_directorship';
                                    if (cipc_value == null){
                                      cipc_value = verificationOfApplicantCIPCDirectorshipWithCIPC;
                                    }
                                    cipc = key;
                                    cipc_value = value;
                                  }
                                  else if(key == 'ID Validation '){
                                    key = 'id_validation';
                                    if (id_validation == null){
                                      id_validation = verificationOfApplicationIDValidation;
                                    }
                                    id_veri = key;
                                    id_validation = value;
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                      :Container(child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffde626c)),),)
                      ,
                    ),





                  ],
                ),
              ),

              InkWell(
                onTap: (){
                  submitForm();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top:0,right: 50, left: 50,bottom: 50),
                  child: Container(
                    height: 50.0,
//                          padding: EdgeInsets.only(top:4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.PRIMARY_COLOR,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x1a000000),
                          offset: Offset(0, 6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: _isLoading ? Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ) : Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 16,
                        color: const Color(0xffffffff),
                        letterSpacing: 0.152,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    ,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top:10),
              ),

            ],
          )
      ),
    );
  }
}



