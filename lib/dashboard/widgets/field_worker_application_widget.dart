import 'package:flutter/material.dart';
import 'package:lesedi/widgets/common_widgets/seprator.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/supervisor/supervisorAllApplicants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget? getFieldWorkerApplication(
    {required BuildContext context, required String userRole}) {
  if (userRole == "field_worker") {
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
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 30, top: 40, right: 30),
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color(0xffffffff),
            border: Border.all(color: const Color(0xfff5f5f5), width: 3),
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
                    decoration: BoxDecoration(color: Colors.white),
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
