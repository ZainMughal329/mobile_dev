import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/example.dart';
import 'package:lesedi/forms/PersonalInformationA1.dart';
import 'package:lesedi/Seprator.dart';
import 'package:lesedi/forms/Verifications.dart';
import 'package:lesedi/applicants/allApplicants.dart';
import 'package:lesedi/fieldWorker/fieldWorkerApplicant.dart';
import 'package:lesedi/forms/attachments.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:lesedi/supervisor/supervisorAllApplicants.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lesedi/app_color.dart';
import 'auth/Login.dart';
import 'helpers/local_storage.dart';

class Dashboard extends StatefulWidget {
  var userRole;
  var applicant_id;

  Dashboard(this.userRole, this.applicant_id);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var role;

  @override
  void initState() {
    super.initState();
    print('role');
    getRole();
    print('woo');
    print(widget.userRole);
    LocalStorage.localStorage.getApplicationsList();
  }

  getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    role = sharedPreferences.getString('role');
    print(role);
  }

  Widget? getFieldWorkerApplication(BuildContext context) {
    if (widget.userRole == "field_worker") {
      return InkWell(
          onTap: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            var role = sharedPreferences.getString('role');
            print(role);
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => SuperVisorAllApplicants()));
          },
          child: Container(
//            width: 393.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, top: 40, right: 30),
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color(0xffffffff),
              border: Border.all(color: const Color(0xfff5f5f5), width: 3),
//                  boxShadow: [
//                    BoxShadow(
//                      color: const Color(0x33000000),
//                      offset: Offset(0, 0),
//                      blurRadius: 2,
//                    ),
//                  ],
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 0, right: 0, top: 40),
                      child: MySeparator(
                        color: AppColors.PRIMARY_COLOR,
                      )),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 260,
                      alignment: Alignment.center,
                      height: 44,
                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                          border: Border.all(
//                              color: const Color(0xff009bed),
//                              width: 3
//                          ),
                          color: Colors.white),
                      child: new Text(
                        "THIRD PARTY VERFICATION",
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 17,
                          color: AppColors.PRIMARY_COLOR,
                          letterSpacing: 0.6066000137329102,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    }
  }

  Widget verification(BuildContext context) {
//    if (widget.userRole == "supervisor" || widget.userRole == "reviewer" || widget.userRole == "field_worker" ) {
    return Container(
//            width: 393.0,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 30, top: 40, right: 30),
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xffffffff),
        border: Border.all(color: const Color(0xfff5f5f5), width: 3),
//                  boxShadow: [
//                    BoxShadow(
//                      color: const Color(0x33000000),
//                      offset: Offset(0, 0),
//                      blurRadius: 2,
//                    ),
//                  ],
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 35),
                child: MySeparator(
                  color: AppColors.PRIMARY_COLOR,
                )),
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  height: 44,
                  decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                          border: Border.all(
//                              color: const Color(0xff009bed),
//                              width: 3
//                          ),
                      color: Colors.white),
                  child: widget.userRole == "field_worker"
                      ? Text(
                          "MY APPLICATIONS ",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 17,
                            color: AppColors.PRIMARY_COLOR,
                            letterSpacing: 0.6066000137329102,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          "CHECK VERIFICATION",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 17,
                            color: AppColors.PRIMARY_COLOR,
                            letterSpacing: 0.6066000137329102,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
//    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
//      onWillPop: _onWillPop,

      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
//        elevation: .5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors.PRIMARY_COLOR,
//          leading: IconButton(
//            icon: new Icon(Icons.arrow_back , color: AppColors.PRIMARY_COLOR, ),
//            onPressed: () => Navigator.of(context).pop(null),
//          ) ,

          title: Text(
            'DASHBOARD',
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
              InkWell(
                onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
//                  sharedPreferences.clear();
                  await sharedPreferences.remove('emailStorage');
                  await sharedPreferences.remove('wardNumberStorage');
                  await sharedPreferences.remove('municipalAccountNumber');
                  await sharedPreferences.remove('standNumber');
                  await sharedPreferences.remove('serviceLinked');
                  await sharedPreferences.remove('eskonAccountNumber');
                  await sharedPreferences.remove('contactNumber');
                  await sharedPreferences.remove('grossMonthlyStorage');
                  await sharedPreferences.remove('telephone_number');
                  await sharedPreferences.remove('applicant_id_proof');
                  await sharedPreferences.remove('spouse_id');
                  await sharedPreferences.remove('dependent_idss');
                  await sharedPreferences.remove('proof_of_income');
                  await sharedPreferences.remove('account_statement');
                  await sharedPreferences.remove('saps_affidavit');
                  await sharedPreferences.remove('fileStorage');

//                  Navigator.of(context).pushNamed('/personalinformationA1');
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PersonalInformationA1(
                          widget.userRole, widget.applicant_id)));
                },
                child: Container(
//            width: 393.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 30, top: 40, right: 30),
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x33000000),
                        offset: Offset(0, 0),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 0, right: 0, top: 40),
                            child: MySeparator(
                              color: AppColors.PRIMARY_COLOR,
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 188,
                            alignment: Alignment.center,
                            height: 44,
                            decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                          border: Border.all(
//                              color: const Color(0xff009bed),
//                              width: 3
//                          ),
                                color: Colors.white),
                            child: new Text(
                              "CREATE NEW FORM",
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                color: AppColors.PRIMARY_COLOR,
                                letterSpacing: 0.6066000137329102,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              InkWell(
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    var role = sharedPreferences.getString('role');
                    print(role);
                    if (widget.userRole == 'reviewer' ||
                        role == 'aspiring_reviewer') {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => AllApplicants()));
                    } else if (widget.userRole == 'supervisor' ||
                        role == 'aspiring_supervisor') {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => AllApplicants()));
                    } else if (widget.userRole == 'field_worker') {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              FieldWorkerApplicants()));
                    }
                  },
                  child: Container(
                    child: verification(context),
                  )),

//              getFieldWorkerApplication(context),

              widget.userRole == 'supervisor'
                  ? InkWell(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        var role = sharedPreferences.getString('role');
                        print(role);
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                SuperVisorAllApplicants()));
                      },
                      child: Container(
//            width: 393.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 30, top: 40, right: 30),
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xffffffff),
                          border: Border.all(
                              color: const Color(0xfff5f5f5), width: 3),
//                  boxShadow: [
//                    BoxShadow(
//                      color: const Color(0x33000000),
//                      offset: Offset(0, 0),
//                      blurRadius: 2,
//                    ),
//                  ],
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 0, right: 0, top: 35),
                                  child: MySeparator(
                                    color: AppColors.PRIMARY_COLOR,
                                  )),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 275,
                                  alignment: Alignment.center,
                                  height: 44,
                                  decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                          border: Border.all(
//                              color: const Color(0xff009bed),
//                              width: 3
//                          ),
                                      color: Colors.white),
                                  child: new Text(
                                    "THIRD PARTY VERFICATION",
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR != null
                                          ? AppColors.PRIMARY_COLOR
                                          : Color(0xffDE626C),
                                      letterSpacing: 0.6066000137329102,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : Container(
                      child: Text(''),
                    ),

              InkWell(
                onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setBool('login', false);
                  Navigator.of(context).pushReplacement(
                      PageRouteBuilder(pageBuilder: (_, __, ___) => Login()));
                },
                child: Container(
//            width: 393.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 30, top: 30, right: 30),
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(color: const Color(0xfff5f5f5), width: 3),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 0, right: 0, top: 40),
                            child: MySeparator(
                              color: AppColors.PRIMARY_COLOR != null
                                  ? AppColors.PRIMARY_COLOR
                                  : Color(0xffDE626C),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            height: 44,
                            decoration: BoxDecoration(color: Colors.white),
                            child: new Text(
                              "LOGOUT",
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                color: AppColors.PRIMARY_COLOR != null
                                    ? AppColors.PRIMARY_COLOR
                                    : Color(0xffDE626C),
                                letterSpacing: 0.6066000137329102,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

//            Container(
////            width: 393.0,
//              alignment: Alignment.center,
//              margin: EdgeInsets.only(left: 10,top: 40,right: 10),
//              height: 100.0,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(5.0),
//                color: const Color(0xffffffff),
//                boxShadow: [
//                  BoxShadow(
//                    color: const Color(0x33000000),
//                    offset: Offset(0, 0),
//                    blurRadius: 2,
//                  ),
//                ],
//              ),
//              child:  Container(
//                padding: EdgeInsets.only(top:10 ,bottom:10),
//                child: Stack(
//                  children: <Widget>[
//                    Container(
//                        margin: EdgeInsets.only(left:0,right:0 ,top:40),
//
//                        child: MySeparator(color: Color(0xffde626c),)),
//                    Align(
//                      alignment: Alignment.center,
//                      child: Container(
//                        width: 320,
//                        alignment: Alignment.center,
//                        height: 44,
//                        decoration: BoxDecoration(
////                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
////                          border: Border.all(
////                              color: const Color(0xff009bed),
////                              width: 3
////                          ),
//                            color: Colors.white
//                        ),
//                        child: new Text("NUMBER OF PROPERTY OWNERSHIP",
//                          style: TextStyle(
//                            fontFamily: 'Open Sans',
//                            fontSize: 17,
//                            color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
//                            letterSpacing: 0.6066000137329102,
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
//                      ),
//                    ),
//
//                  ],
//                ),
//              ),
//            ),
//
//
//            Container(
////            width: 393.0,
//              alignment: Alignment.center,
//              margin: EdgeInsets.only(left: 10,top: 40,right: 10,bottom: 40),
//              height: 100.0,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(5.0),
//                color: const Color(0xffffffff),
//                boxShadow: [
//                  BoxShadow(
//                    color: const Color(0x33000000),
//                    offset: Offset(0, 0),
//                    blurRadius: 2,
//                  ),
//                ],
//              ),
//              child:  Container(
//                padding: EdgeInsets.only(top:10 ,bottom:10),
//                child: Stack(
//                  children: <Widget>[
//                    Container(
//                        margin: EdgeInsets.only(left:0,right:0 ,top:40),
//
//                        child: MySeparator(color: Color(0xffde626c),)),
//                    Align(
//                      alignment: Alignment.center,
//                      child: Container(
//                        width:280,
//                        alignment: Alignment.center,
//                        height: 44,
//                        decoration: BoxDecoration(
////                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
////                          border: Border.all(
////                              color: const Color(0xff009bed),
////                              width: 3
////                          ),
//                            color: Colors.white
//                        ),
//                        child: new Text("APPLICANT CONTACT DETAILS",
//                          style: TextStyle(
//                            fontFamily:'Open Sans',
//                            fontSize: 17,
//                            color: AppColors.PRIMARY_COLOR !=null ? AppColors.PRIMARY_COLOR : Color(0xffDE626C),
//                            letterSpacing: 0.6066000137329102,
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
//                      ),
//                    ),
//
//                  ],
//                ),
//              ),
//            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
