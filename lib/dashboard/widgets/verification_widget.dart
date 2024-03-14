import 'package:flutter/material.dart';
import 'package:lesedi/widgets/common_widgets/seprator.dart';
import 'package:lesedi/utils/app_color.dart';

Widget verification({required BuildContext context,required String userRole}) {
  return Container(
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
                    color: Colors.white),
                child: userRole == "field_worker"
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
}