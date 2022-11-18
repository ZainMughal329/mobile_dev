import 'package:flutter/material.dart';
import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/forms/ApplicationStatus.dart';
import 'package:rustenburg/forms/MaritalStatus.dart';
import 'package:rustenburg/forms/deathCertificate.dart';
import 'package:rustenburg/forms/filePickerAdditionalFile.dart';
import 'package:rustenburg/forms/filePickerSapsAffidavit.dart';
import 'package:rustenburg/forms/filePickerAffidavits.dart';
import 'package:rustenburg/forms/filePickerDegreeDivorce.dart';
import 'package:rustenburg/forms/filePickerGromeMonthIncome.dart';
import 'package:rustenburg/forms/filePickerSpouseID.dart';
import 'package:rustenburg/forms/filerPickerAccountStatment.dart';
import 'package:rustenburg/forms/household.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:camera/camera.dart';
import 'package:rustenburg/helpers/utils.dart';
import 'package:rustenburg/networkRequest/services_request.dart';

import '../Dashboard.dart';
import 'Declaration.dart';
import 'occupantID.dart';
import 'filePicker.dart';

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:rustenburg/app_color.dart';
import '../global.dart';
import 'filePickerApplicationID.dart';
import 'filePickerMarriageCertificate.dart';
import 'filePickerSpouseReport.dart';

class Attachments extends StatefulWidget {
  int applicant_id;
  String gross_monthly_income;
  bool previousFormSubmitted;
  Attachments(
      this.applicant_id, this.gross_monthly_income, this.previousFormSubmitted);
  @override
  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  String profileType;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  int applicant_id;

  var employment_status;
  var spouse_id;
  var dependent_ids;
  var applicant_id_proof;
  var proof_of_income;
  var account_statement;
  var saps_affidavit;

  var attachmentOfId;

  @override
  void initState() {
    super.initState();
    print('id agye hai');
    print(widget.gross_monthly_income);
    _controller.addListener(() => _extension = _controller.text);
    checkInternetAvailability();
  }

  File _image;
  final picker = ImagePicker();
  ServicesRequest request = ServicesRequest();

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String auth_token = sharedPreferences.get('token');
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
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
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'ATTACHMENTS',
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
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Applicant ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)
                FileHolderApplicationID(
                    widget.applicant_id, 'applicant_id_proof'),

                Divider(),

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Spouse ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                FileHolderSpouseID(widget.applicant_id, 'spouse_id'),

                Divider(),

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Occupant ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

//                  FileHolder(widget.applicant_id,'dependent_ids[]'),

                OccupantID(widget.applicant_id, 'occupant_ids'),

                Divider(),

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Gross Monthly Income (R) ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                FileHolderGrossMonth(widget.applicant_id, 'proof_of_incomes'),

                Divider(),

                Padding(
                  padding: widget.gross_monthly_income.isNotEmpty
                      ? EdgeInsets.only(
                          left: 30, right: 30, bottom: 20, top: 20)
                      : EdgeInsets.only(
                          left: 30, right: 30, bottom: 20, top: 0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Municipal Statement of account ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
//                / Text header "Welcome To" (Click to open code)
                FileHolderAccountStatement(
                    widget.applicant_id, 'account_statement'),

                Divider(),

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Affidavit SAPS ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                FileHolderAsapsAffidavit(widget.applicant_id, 'saps_affidavit'),

                Divider(),

//
//                    Divider(),
//

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Household ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                HouseHold(widget.applicant_id, 'household'),

                Divider(),

                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Death Certificate ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                DeathCertificate(widget.applicant_id, 'death_certificate'),

                Divider(),
                Padding(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Marriage Certificate',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                MarriageCertificate(
                    widget.applicant_id, 'marriage_certificate'),

                Divider(),
                Padding(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Decree Divorce',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                DecreeDivorce(
                    widget.applicant_id, 'degree_divorce'),

                Divider(),
                Padding(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Affidavits',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                Affidavits(
                    widget.applicant_id, 'affidavits'),

                Divider(),
                Padding(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Additional File',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                FileHolderAdditional(
                    widget.applicant_id, 'additional'),

                Divider(),
                Padding(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Spouse credit report',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)

                FilePickerSpouseCreditReport(
                    widget.applicant_id, 'spouse_reports'),

                Divider(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                // await checkFormStatus();
                print("Applicant ID :::: ${widget.applicant_id}");
                print(
                    "Previous Form Submitted ::: ${widget.previousFormSubmitted}");

                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Declaration(
                        widget.applicant_id, widget.previousFormSubmitted)));
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
                    child: Align(
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
          ),
        ],
      )),
    );
  }

  Future<bool> checkFormStatus() async {
    await request.ifInternetAvailable();
    if (MyConstants.myConst.internet) {
      applicant_id =
          await request.singleFormSubmission(widget.previousFormSubmitted);
      if (applicant_id == null) {
        setState(() {
          _isLoading = false;
          widget.previousFormSubmitted = false;
        });
        return true;
      } else {
        setState(() {
          _isLoading = false;
          widget.previousFormSubmitted = true;
          widget.applicant_id = applicant_id;
          LocalStorage.localStorage.clearCurrentApplication();
        });
        return true;
      }
    } else {
      return false;
    }
  }
}