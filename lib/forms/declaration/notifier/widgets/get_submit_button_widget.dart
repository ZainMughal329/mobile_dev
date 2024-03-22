import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/utils/constants.dart';

Widget getSubmitButton(
    {required ByteData img, required dynamic storeSignature,required bool isLoadingSecondary,
      required Function()? onSubmitFunc()}) {
  if (img.buffer.lengthInBytes == 0 && storeSignature == null)
    return Container();
  return InkWell(
    onTap: () {
      onSubmitFunc();
    },
    child: isLoadingSecondary
        ? Padding(
      padding: const EdgeInsets.only(
          top: 0, right: 50, left: 50, bottom: 50),
      child: Container(
        height: 50.0,
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
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    )
        : Padding(
      padding: const EdgeInsets.only(
          top: 0, right: 50, left: 50, bottom: 50),
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
        child: Text(
          MyConstants.myConst.internet ?? false ? 'SUBMIT' : 'SAVE',
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
  );
}
