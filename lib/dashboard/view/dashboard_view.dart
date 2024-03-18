import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/dashboard/dahboard_notifier/dashboard_notifier.dart';
import 'package:lesedi/dashboard/widgets/verification_widget.dart';
import 'package:lesedi/forms/personal_information_A1/view/personal_information_A1.dart';
import 'package:lesedi/widgets/common_widgets/seprator.dart';
import 'package:lesedi/applicants/view/allApplicants.dart';
import 'package:lesedi/fieldWorker/fieldWorkerApplicant.dart';
import 'package:lesedi/supervisor/supervisorAllApplicants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lesedi/utils/app_color.dart';
import '../../auth/login/view/login_view.dart';
import '../../common_services/local_storage.dart';

class Dashboard extends ConsumerStatefulWidget {
  final String userRole;
  final int applicant_id;
  const Dashboard({required this.applicant_id,required this.userRole,super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final dashBoardProvider = ChangeNotifierProvider<DashboardNotifier>((ref) {
    return DashboardNotifier();
  });
  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(dashBoardProvider).getRole();
      print('role');
      print(widget.userRole);
      LocalStorage.localStorage.getApplicationsList();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors.PRIMARY_COLOR,
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

                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PersonalInformationA1(
                          widget.userRole, widget.applicant_id)));
                },
                child: Container(
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
                    print("role ${role}");
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
                    child: verification(context:context,userRole: widget.userRole),
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
            ],
          ),
        ),
      ),
    );
  }
}
