import 'dart:io';
import 'package:flutter/cupertino.dart';

Widget getSignatureImage(img, storeSignature) {
  if (img.buffer.lengthInBytes == 0 && storeSignature != null) {
    return LimitedBox(
        maxHeight: 40.0, child: Image.file(new File(storeSignature)));
  } else {
    if (img.buffer.lengthInBytes == 0) {
      return Container(
          child: Text(
        'Signature of Applicant',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontSize: 12,
          color: const Color(0xff6f6f6f),
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ));
    } else {
      return LimitedBox(
          maxHeight: 40.0, child: Image.memory(img.buffer.asUint8List()));
    }
  }
}
