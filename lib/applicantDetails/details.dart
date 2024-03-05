import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/applicants/allApplicants.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/fieldWorker/fieldWorkerApplicant.dart';
import 'package:lesedi/global.dart';
import 'package:lesedi/model/applicantInfo.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/supervisor/supervisorAllApplicants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lesedi/app_color.dart';

//Check

class ApplicantDetails extends StatefulWidget {
  int id;

  ApplicantDetails(this.id);

  @override
  _ApplicantDetailsState createState() => _ApplicantDetailsState();
}

class _ApplicantDetailsState extends State<ApplicantDetails> {
  bool _isLoading = false;
  bool _isLoadingReject = false;
  var role;

  @override
  void initState() {
    super.initState();
    print('daya');
    getApplicantDetails();
    print(widget.id);
    getRole();
  }

  bool _isVisible = true;

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
    print(role);
  }

  reviewedApplicant() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${widget.id}&accepted=true"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);
      setState(() {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  removeReviewedApplicant() async {
    setState(() {
      _isLoadingReject = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=${widget.id}&accepted=false"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);

      setState(() {
        _isLoadingReject = false;
      });
    } else {
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  ApplicantInfo? models;

  String? firstname;
  String? surname;
  String? id_number;
  String? date_of_application;
  String? dob;
  String? age;
  String? address;
  String? department_id_num;
  String? email;
  String? ward_number;
  String? municipal_rates_account_num;
  String? status_number;
  List<String>? service_links;
  String? eskom_accounts;
  String? contact;
  String? application_status;
  String? marital_status;
  String? signature_date;
  String? cellphone_number;
  String? telephone_number;
  String? applicant_id_proof;
  String? spouse_id;
  var proof_of_income;
  var spouse_credit_report;
  var affidavits;
  var houseHold;
  var additional_file;
  var deathCertificate;
  var marriage_certificate;

  var account_statment;
  String? saps_affidavit;
  String? decree_divorce;
  String? signature;
  String? spouse_id_number;
  String? occupant_id;
  var dependent_ids;
  List<OccupantIds> response = [];
  List<BankDetails> bankDetails = [];


  getApplicantDetails() async {
    ApplicantInfo responseM;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.get(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/review?application_id=${widget.id}"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
        });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      Map<String, dynamic> dataHolder = jsonResponse;
      print(jsonResponse);
      var dataSort = dataHolder.values.toList();

      print(dataSort);

      ApplicantInfo models = ApplicantInfo.fromJson(dataHolder);
      responseM = models;
      print('name');
      print(responseM.spouseId);

      setState(() {
        print('done');
        models = responseM;
        if (models != null) {
          _isVisible = !_isVisible;
        }

        print('done');
        firstname = responseM.firstName;
        surname = responseM.surname;
        id_number = responseM.idNumber;
        date_of_application = responseM.dateOfApplication;
        dob = responseM.dob;
        address = responseM.address;
        department_id_num = responseM.grossMonthlyIncome;
        email = responseM.email;
        ward_number = responseM.wardNumber;
        municipal_rates_account_num = responseM.accountNumber;
        status_number = responseM.standNumber;
        service_links = responseM.servicesLinked;
        eskom_accounts = responseM.eskomAccountNumber;
//        contact = responseM.c;

        application_status = responseM.employmentStatus;
        marital_status = responseM.maritalStatus;
        signature_date = responseM.signatureDate;
        cellphone_number = responseM.cellphoneNumber;
        telephone_number = responseM.telephoneNumber;
        spouse_credit_report=responseM.spouseCreditReport;
        applicant_id_proof = responseM.applicantIdProof;
        spouse_id = responseM.spouseId;
        proof_of_income = responseM.proofOfIncomes;
        affidavits = responseM.affidavits;
        houseHold = responseM.houseHoldList;
        deathCertificate = responseM.deathCertificate;
        additional_file = responseM.additionalFile;
        marriage_certificate = responseM.marriageCertificate;
        account_statment = responseM.accountStatement;
        saps_affidavit = responseM.sapsAffidavit;
        decree_divorce = responseM.decreeDivorce;
        dependent_ids = responseM.occupantIds;
        spouse_id_number = responseM.spouseIdNumber;

        occupant_id = responseM.occupantId;
        bankDetails = responseM.bankDetails??[];
        age = responseM.age.toString();

        if (applicant_id_proof != null) {
          String fileName = applicant_id_proof??"".split('/').last;
          print('filename');

          if (fileName.contains('.png') ||
              fileName.contains('.jpg') ||
              fileName.contains('.jpeg') ||
              fileName.contains('.gif')) {
            print('wiii');
            applicant_id_proof = responseM.applicantIdProof;
          } else {
            applicant_id_proof =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }
        if (spouse_id != null) {
          print('agya');
          spouse_id = responseM.spouseId;

          String fileNameSpouse = spouse_id??"".split('/').last;

          print('filename');

          if (fileNameSpouse.contains('.png') ||
              fileNameSpouse.contains('.jpg') ||
              fileNameSpouse.contains('.jpeg') ||
              fileNameSpouse.contains('.gif')) {
            print('wiii');
            spouse_id = responseM.spouseId;
            print('data ${spouse_id}');
          } else {
            spouse_id =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }

        if (decree_divorce != null) {
          print('agya');
          decree_divorce = responseM.decreeDivorce;

          String fileNameSpouse = decree_divorce??"".split('/').last;

          print('filename');

          if (fileNameSpouse.contains('.png') ||
              fileNameSpouse.contains('.jpg') ||
              fileNameSpouse.contains('.jpeg') ||
              fileNameSpouse.contains('.gif')) {
            print('wiii');
            decree_divorce = responseM.decreeDivorce;
            print('data ${decree_divorce}');
          } else {
            decree_divorce =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }

        if (proof_of_income != null) {
          proof_of_income = responseM.proofOfIncomes;

          for (int p = 0; p < proof_of_income.length; p++) {
            print('dependent_idsssss');
            if (proof_of_income[p].contentType == 'image/jpeg' ||
                proof_of_income[p].contentType == 'image/png' ||
                proof_of_income[p].contentType == 'image/jpg' ||
                proof_of_income[p].contentType == 'image/gif') {
              proof_of_income = responseM.proofOfIncomes;

              print('dataa proof');
              print(proof_of_income);
            } else {
//            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
              proof_of_income =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
          }
        }
        if (houseHold != null) {
          houseHold = responseM.houseHoldList;

          for (int p = 0; p < houseHold.length; p++) {
            print('dependent_idsssss');
            if (houseHold[p].contentType == 'image/jpeg' ||
                houseHold[p].contentType == 'image/png' ||
                houseHold[p].contentType == 'image/jpg' ||
                houseHold[p].contentType == 'image/gif') {
              houseHold = responseM.houseHoldList;

              print('dataa proof');
              print(houseHold);
            } else {
//            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
              houseHold =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
          }
        }

        if (deathCertificate != null) {
          deathCertificate = responseM.deathCertificate;

          for (int p = 0; p < deathCertificate.length; p++) {
            print('dependent_idsssss');
            if (deathCertificate[p].contentType == 'image/jpeg' ||
                deathCertificate[p].contentType == 'image/png' ||
                deathCertificate[p].contentType == 'image/jpg' ||
                deathCertificate[p].contentType == 'image/gif') {
              deathCertificate = responseM.deathCertificate;

              print('dataa proof');
              print(deathCertificate);
            } else {
//            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
              deathCertificate =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
          }
        }
        if (affidavits != null) {
          affidavits = responseM.affidavits;

          for (int p = 0; p < affidavits.length; p++) {
            print('dependent_idsssss');
            if (affidavits[p].contentType == 'image/jpeg' ||
                affidavits[p].contentType == 'image/png' ||
                affidavits[p].contentType == 'image/jpg' ||
                affidavits[p].contentType == 'image/gif') {
              affidavits = responseM.affidavits;

              print('dataa proof');
              print(proof_of_income);
            } else {
//            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
              affidavits =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
          }
        }

        if (marriage_certificate != null) {
          print('agya');
          marriage_certificate = responseM.marriageCertificate;

          String fileNameSpouse = marriage_certificate.split('/').last;

          print('filename');

          if (fileNameSpouse.contains('.png') ||
              fileNameSpouse.contains('.jpg') ||
              fileNameSpouse.contains('.jpeg') ||
              fileNameSpouse.contains('.gif')) {
            print('wiii');
            marriage_certificate = responseM.marriageCertificate;
            print('data ${marriage_certificate}');
          } else {
            marriage_certificate =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }

//         if (marriage_certificate != null) {
//           marriage_certificate = responseM.marriageCertificate;
//
//           for (int p = 0; p < affidavits.length; p++) {
//             print('dependent_idsssss');
//             if (marriage_certificate[p].contentType == 'image/jpeg' ||
//                 marriage_certificate[p].contentType == 'image/png' ||
//                 marriage_certificate[p].contentType == 'image/jpg' ||
//                 marriage_certificate[p].contentType == 'image/gif') {
//               marriage_certificate = responseM.marriageCertificate;
//
//               print('dataa proof');
//               print(marriage_certificate);
//             } else {
// //            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
//               marriage_certificate =
//               'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
//             }
//           }
//         }

        if (account_statment != null) {
          account_statment = responseM.accountStatement;

          String fileNameAcc = account_statment.split('/').last;
          print('filename');

          if (fileNameAcc.contains('.png') ||
              fileNameAcc.contains('.jpg') ||
              fileNameAcc.contains('.jpeg') ||
              fileNameAcc.contains('.gif')) {
            print('wiii');
            account_statment = responseM.accountStatement;
          } else {
            account_statment =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }
        if (saps_affidavit != null) {
          saps_affidavit = responseM.sapsAffidavit;

          String fileNameSap = saps_affidavit??"".split('/').last;
          print('filename');

          if (fileNameSap.contains('.png') ||
              fileNameSap.contains('.jpg') ||
              fileNameSap.contains('.jpeg') ||
              fileNameSap.contains('.gif')) {
            print('wiii');
            saps_affidavit = responseM.sapsAffidavit;
          } else {
            saps_affidavit =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
          }
        }

        if (additional_file != null) {
          additional_file = responseM.additionalFile;

          for (int p = 0; p < additional_file.length; p++) {
            print('dependent_idsssss');
            if (additional_file[p].contentType == 'image/jpeg' ||
                additional_file[p].contentType == 'image/png' ||
                additional_file[p].contentType == 'image/jpg' ||
                additional_file[p].contentType == 'image/gif') {
              additional_file = responseM.additionalFile;

              print('dataa proof');
              print(additional_file);
            } else {
//            var item = ['https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png'];
              additional_file =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
          }
        }

//

        if (dependent_ids != null) {
          dependent_ids = responseM.occupantIds;
          for (int p = 0; p < dependent_ids.length; p++) {
            print('dependent_idsssss');
            print(dependent_ids.length);
            if (dependent_ids[p].contentType == 'image/jpeg' ||
                dependent_ids[p].contentType == 'image/png' ||
                dependent_ids[p].contentType == 'image/jpg' ||
                dependent_ids[p].contentType == 'image/gif') {
              if (dependent_ids.length == 1) {
                dependent_ids = responseM.occupantIds;
              } else {
                dependent_ids = responseM.occupantIds;
              }
            } else {
              dependent_ids.add(
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//            print( dependent_ids[0].url);
            }
          }
        }

        signature = responseM.signature;
//    print(applicant_id_proof);
//        print(dependent_ids.length);
      });
    } else {
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  TextStyle _style() {
    return TextStyle(
        letterSpacing: 0.0,
        color: Color(0xff141414),
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w700,
        fontSize: 15.0);
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
        removeReviewedApplicant();
        Navigator.of(context).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to Reject the Application?"),
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
            print(role);
            Navigator.pop(context);
//            if ( role == 'field_worker'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> FieldWorkerApplicants()));
//          }
//            else if (role == 'reviewer'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> AllApplicants()));
//            }
//
//            else if (role == 'supervisor'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> SuperVisorAllApplicants()));
//            }
          },
        ),

        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'VERIFICATIONS',
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
          SizedBox(
            height: 50,
          ),
          Text(
            "PERSONAL INFORMATION",
            style: TextStyle(
                letterSpacing: 0.0,
                color: Color(0xff141414),
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w700,
                fontSize: 18.0),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 40),
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
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 12, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Date of application",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(date_of_application != null
                          ? DateFormat('yMMMMd')
                              .format(DateTime.parse(date_of_application??""))
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Account Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(municipal_rates_account_num != null
                          ? municipal_rates_account_num.toString()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Surname",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(surname??""),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Text("First Name", style: _style()),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        firstname??"",
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Applicant ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(id_number??""),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "DOB",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(dob != null ? dob.toString() : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Age",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(age != null ? age.toString() : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Spouse ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(spouse_id_number != null
                          ? spouse_id_number.toString()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Occupant ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(occupant_id != null ? occupant_id.toString() : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Stand/Erf Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(status_number != null
                          ? status_number.toString()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Services Linked to Stand",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      service_links != null
                          ? Row(
                              children: List.generate(
                                service_links?.length??0,
                                (index) =>
                                    Text(service_links?[index].toString()??"" + ","),
                              ),
                            )
                          : Text(''),

                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Ward Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      //Check
                      Text(ward_number != null ? ward_number.toString() : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

//                          Divider(color: Color(0x29000000),),

//                          Text("Gross Monthly Income", style: _style(),),
//                          SizedBox(height: 4,),
//                          Text(department_id_num!=null?department_id_num.toString():''),
//                          SizedBox(height: 4,),

                      Text(
                        "Eskom Account Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(eskom_accounts != null
                          ? eskom_accounts.toString()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

//                          Divider(color: Color(0x29000000),),
//                          SizedBox(height: 4,),
//
//                          Text("Contact", style: _style(),),
//                          SizedBox(height: 4,),
//                          Text(contact!=null?contact.toString():''),
//                          SizedBox(height: 4,),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Email",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(email != null ? email.toString() : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Cellphone Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(cellphone_number != null
                          ? cellphone_number.toString()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Telephone Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(telephone_number != null
                          ? telephone_number.toString()
                          : ''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Employment Status",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(application_status != null
                          ? application_status??""
                              .replaceAll(new RegExp('[\\W_]+'), ' ')
                              .toLowerCase()
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Marital Status",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(marital_status??""),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Bank Details",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                  bankDetails.isEmpty || bankDetails == null? Text(''): ListView(
                    shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    // physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      bankDetails.length,
                          (index) => Container(
                            child: Column(
                                children: [
                                 bankDetails.length == 1? SizedBox(height: 5,):Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(child: Text("BankDetails ${index+1}",
                                      style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'opensans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                    )),
                                  ),
                                  Row(children:[ Text("Bank Name :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'opensans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),), Text(bankDetails[index].bankAccountNumber??"",
                                      style: TextStyle(
                                          fontFamily: 'opensans',
                                          fontSize: 13,
                                      ),
                                    )]),
                                  SizedBox(height: 3,),
                                  Row(children:[ Text("Account No: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'opensans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),), Text(bankDetails[index].bankNumber??"",
                                    style: TextStyle(
                                      fontFamily: 'opensans',
                                      fontSize: 13,
                                    ),
                                    )]),
                                  SizedBox(height: 3,),
                                  Row(children:[ Text("Branch Code: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'opensans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),), Text(bankDetails[index].branchCode??"",
                                    style: TextStyle(
                                      fontFamily: 'opensans',
                                      fontSize: 13,
                                    ),
                                    )]),
                                ],
                            ),
                          )

//                                        Image.network(
//                                          dependent_ids[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                    ),
                  ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Signature Date",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(signature_date != null
                          ? DateFormat('yMMMMd')
                              .format(DateTime.parse(signature_date??""))
                          : ''),
                      SizedBox(
                        height: 4,
                      ),

                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)
              ],
            ),
          ),
//              Divider(color: Color(0x29000000),),
          SizedBox(
            height: 20,
          ),
          Text(
            "ATTACHMENTS",
            style: TextStyle(
                letterSpacing: 0.0,
                color: Color(0xff141414),
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w700,
                fontSize: 18.0),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 40),
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
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 12, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Applicant ID	',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      applicant_id_proof != null
                          ? Center(
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    applicant_id_proof??""),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                              applicant_id_proof,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Spouse ID	',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      spouse_id != null
                          ? Center(
                              child: Image(
                                image: CachedNetworkImageProvider(spouse_id??""),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                              spouse_id,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Occupant ID',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      dependent_ids != null
                          ? Container(
                              height: 150,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  dependent_ids.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        dependent_ids[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),

//                                        Image.network(
//                                          dependent_ids[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Municipal Statement of Account',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      account_statment != null
                          ? Center(
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    account_statment),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Proof of Income ',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      proof_of_income != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  proof_of_income.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        proof_of_income[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Affidavit SAPS',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      saps_affidavit != null
                          ? Center(
                              child: Image(
                                image:
                                    CachedNetworkImageProvider(saps_affidavit??""),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                                saps_affidavit,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Death Certificate',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      deathCertificate != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  deathCertificate.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        deathCertificate[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Decree Divorce',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      decree_divorce != null
                          ? Center(
                              child: Image(
                                image:
                                    CachedNetworkImageProvider(decree_divorce??""),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                                saps_affidavit,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'House Hold',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      houseHold != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  houseHold.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        houseHold[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),

                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Marriage Certificate',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      marriage_certificate != null
                          ? Center(
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    marriage_certificate),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                                saps_affidavit,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
//                       marriage_certificate != null
//                           ? Container(
//                         height: 150,
//                         margin: EdgeInsets.only(top: 10),
//                         child: ListView(
//                           scrollDirection: Axis.horizontal,
//                           shrinkWrap: true,
//                           children: List.generate(
//                             marriage_certificate.length,
//                                 (index) => Image(
//                               image: CachedNetworkImageProvider(
//                                   marriage_certificate[index].url),
//                               width: 100,
//                               fit: BoxFit.cover,
//                             ),
// //                                        Image.network(
// //                                          proof_of_income[index].url,
// //                                          width: 100,
// //                                          fit: BoxFit.cover,
// //                                        )
//                           ),
//                         ),
//                       )
//                           : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Affidavits',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      affidavits != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  affidavits.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        affidavits[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Additional File',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      additional_file != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  additional_file.length,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(
                                        additional_file[index].url),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Spouse Credit Report ',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      spouse_credit_report != null
                          ? Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: List.generate(
                            spouse_credit_report.length,
                                (index) => Image(
                              image: CachedNetworkImageProvider(
                                  spouse_credit_report[index].url),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
//                                        Image.network(
//                                          proof_of_income[index].url,
//                                          width: 100,
//                                          fit: BoxFit.cover,
//                                        )
                          ),
                        ),
                      )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Signature',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      signature != null
                          ? Center(
                              child: Image(
                                image: CachedNetworkImageProvider(signature??""),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                              signature,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                    ],
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)
              ],
            ),
          ),

          role == 'reviewer'
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          reviewedApplicant();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, right: 50, left: 50, bottom: 50),
                          child: Container(
                            height: 40.0,
                            padding: EdgeInsets.only(top: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1a000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
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
                                : Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      letterSpacing: 0.152,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, right: 50, left: 50, bottom: 50),
                          child: Container(
                            height: 40.0,
                            padding: EdgeInsets.only(top: 2),
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
                            child: _isLoadingReject
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Reject',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      letterSpacing: 0.152,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Text(''),
        ],
      )),
    );
  }
}
