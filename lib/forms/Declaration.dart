import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rustenburg/Dashboard.dart';
import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/forms/MaritalStatus.dart';
import 'package:rustenburg/forms/attachments.dart';
import 'package:rustenburg/global.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:rustenburg/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rustenburg/app_color.dart';

class Declaration extends StatefulWidget {
  int applicant_id;
  bool previousFormSubmitted;
  Declaration(this.applicant_id, this.previousFormSubmitted);
  @override
  _DeclarationState createState() => _DeclarationState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _DeclarationState extends State<Declaration> {
  var encoded;

  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  DateTime selectedDate = DateTime.now();
  String formattedDate;
  ServicesRequest request = ServicesRequest();
  @override
  void initState() {
    super.initState();
    print('id agye hai');
    getFile();
    checkInternetAvailability();
//    print(widget.custom_requirement_id);
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
  }

  bool _isLoadingSecondary = false;

  var storeSignature;
  File storePath;
  getFile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
      storeSignature = sharedPreferences.getString('fileStorage');

//      print(storePath.path);
      print(storeSignature);
    });
  }

  File file;
  Future _onSubmit() async {
    await request.ifInternetAvailable();
    String url;
//    File img = await image;
    print("OnSubmit Called");
    print("File is ::: $file");
    print("Store Signature ::: $storeSignature");

    if (file != null || storeSignature != null) {
      try {
//         if (_isLoadingSecondary == true) {
// //          showToastMessage('Image Uploading Please wait');
//           print(widget.applicant_id);
//         }
        Map<String, dynamic> data = {
          "application_id": widget.applicant_id,
          "signature_date": selectedDate,
          "signature": await MultipartFile.fromFile(
              storeSignature != null ? storeSignature : file.path,
              filename: 'signature.jpg')
        };
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate);
        print("DateTime ::: $formattedDate");
        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          "signature_date": formattedDate,
          "signature": file.path
        };

        FormData formData;
        LocalStorage.localStorage.saveFormData(map);

        print('form data');

        print(formData.toString());

        if (MyConstants.myConst.internet) {
          setState(() {
            _isLoadingSecondary = true;
            print(widget.applicant_id);
          });
          var dio = Dio(BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: 90 * 1000, // 3 minutes
              receiveTimeout: 90 * 1000 // 3 minuntes
              ));
          dio.interceptors.add(LogInterceptor(responseBody: true));
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var userID = sharedPreferences.getString('userID');
          var authToken = sharedPreferences.getString('auth-token');
          if (widget.previousFormSubmitted) {
            formData = new FormData.fromMap(data);
            url =
                '${MyConstants.myConst.baseUrl}api/v1/users/update_application';
          } else {
            url = '${MyConstants.myConst.baseUrl}api/v1/users/application_form';
            data = await request
                .getFormData(MyConstants.myConst.currentApplicantId);
            formData = FormData.fromMap(data);
          }
          Response response = await dio.post(
            url,
            data: formData, // Post with Stream<List<int>>
            options: Options(
                headers: {'uuid': userID, 'Authentication': authToken},
                contentType: "*/*",
                responseType: ResponseType.json),
          );
          if (response.statusCode == 200) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            var role = sharedPreferences.getString('role');
            var applicant_id = sharedPreferences.getInt('applicant_id');

            if (!widget.previousFormSubmitted) {
              var apid;
              apid = response.data;
              print("appid ::: $apid");
              sharedPreferences.setInt('applicant_id', apid['application_id']);
              applicant_id = apid['application_id'];
            } else {
              sharedPreferences.setInt('applicant_id', data['application_id']);
              applicant_id = data['application_id'];
            }
            LocalStorage.localStorage.clearCurrentApplication();
            MyConstants.myConst.currentApplicantId = null;
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => Dashboard(role, applicant_id)));
            setState(() {
              _isLoadingSecondary = false;
            });

            showToastMessage('Form Submitted');
          }
        } else {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          LocalStorage.localStorage.formSubmitted(false);
          var role = sharedPreferences.getString('role');
          var applicant_id = sharedPreferences.getInt('applicant_id');
          print("Form Saved, Not Submitted");
          MyConstants.myConst.currentApplicantId = null;
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => Dashboard(role, applicant_id)));
        }
      } catch (e) {
        // Fluttertoast.showToast(msg: "Something went wrong");
        setState(() {
          _isLoadingSecondary = false;
        });
        print('At ::: dsa');
        print(e);
      }
    } else {
      print('ss');
    }
  }

  var ImageNew;

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Signature of Applicant'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                Container(
                  height: 300,
                  child: Signature(
                    color: color,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                      debugPrint(
                          '${sign.points.length} points in the signature');
                    },
//                    backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                    strokeWidth: strokeWidth,
                  ),
                ),
                MaterialButton(
                    color: AppColors.PRIMARY_COLOR,
                    onPressed: () async {
                      final sign = _sign.currentState;
                      //retrieve image data, do whatever you want with it (send to server, save locally...)

                      final image = await sign.getData();
                      var data = await image.toByteData(
                          format: ui.ImageByteFormat.png);

//                      print(imageHOlder);
                      print(data);
                      sign.clear();
                      encoded = base64.encode(data.buffer.asUint8List());
                      Uint8List bytes = base64.decode(encoded);
                      String dir =
                          (await getApplicationDocumentsDirectory()).path;
                      String fullPath =
                          '$dir/${DateTime.now().millisecondsSinceEpoch}.png';

                      file = File(fullPath);

                      print(widget.applicant_id);

                      await file.writeAsBytes(bytes);

                      print('path');

                      print(file.path);

                      final result = await ImageGallerySaver.saveImage(bytes);

                      print('result');

                      print(result);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      setState(() {
                        _img = data;
                        ImageNew = _img.buffer.asUint8List();
                        print('path data');
                        print(_img.buffer.asByteData());
//                        prefs.remove('fileStorage');
                        print(_img.buffer.asUint8List());
                        print('path');
                        print(file);
                        prefs.setString("fileStorage", file.path);
                      });
                      Navigator.of(context).pop();
                      print('image');
                      print(data);
                      print(image);
                      debugPrint("onPressed " + encoded);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getSignatureImage(BuildContext context) {
    if (_img.buffer.lengthInBytes == 0 && storeSignature != null) {
      return LimitedBox(
          maxHeight: 40.0, child: Image.file(new File(storeSignature)));
    } else {
      if (_img.buffer.lengthInBytes == 0) {
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
            maxHeight: 40.0, child: Image.memory(_img.buffer.asUint8List()));
      }
    }

//    if (_img.buffer.lengthInBytes  == 0  ){
//      return Container(
//          child: Text('Signature of Applicant',
//            style: TextStyle(
//              fontFamily: 'Open Sans',
//              fontSize: 12,
//              color: const Color(0xff6f6f6f),
//              fontWeight: FontWeight.w700,
//              height: 1.5,
//            ),
//          )
//
//      );
//    }
//    else{ return LimitedBox(maxHeight: 40.0, child: Image.memory(_img.buffer.asUint8List()));}
//  }
  }

  Widget getSubmitButton(BuildContext context) {
    if (_img.buffer.lengthInBytes == 0 && storeSignature == null)
      return Container();
    return InkWell(
      onTap: () {
        _onSubmit();
      },
      child: _isLoadingSecondary
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
                  MyConstants.myConst.internet ? 'SUBMIT' : 'SAVE',
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
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> Attachments(widget.gross_monthly_income,widget.applicant_id)));
            },
          ),
          backgroundColor: AppColors.PRIMARY_COLOR,
          title: Text(
            'DECLARATION',
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
              Container(
                padding:
                    EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
                child: Text(
                  'I consent to and accept that the municipality will use a third party (i.e. Credit Bureau) to conduct vetting to assess my application and I have read the and understand the conditions of the Indigent Policy.',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff6f6f6f),
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
                child: Text(
                  'I declare that the information given is correct and I have declared all information in respect of the status of my spouse and all occupants in my household.',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 12,
                    color: const Color(0xff6f6f6f),
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          _showcontent();
                        },
                        child: Container(
                            height: 40,
                            padding: _img.buffer.lengthInBytes == 0
                                ? EdgeInsets.only(bottom: 10)
                                : EdgeInsets.only(bottom: 0),
                            margin: EdgeInsets.only(right: 30),
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              border: Border(
                                bottom: BorderSide(
                                  //                    <--- top side
                                  color: Color(0xff4D4D4D),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: getSignatureImage(context)),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                            height: 40,
                            padding: EdgeInsets.only(bottom: 10),
                            margin: EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              border: Border(
                                bottom: BorderSide(
                                  //                    <--- top side
                                  color: Color(0xff4D4D4D),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 12,
                                color: const Color(0xff6f6f6f),
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 90.0, bottom: 0),
//                    child: _img.buffer.lengthInBytes == 0 ? Container() : LimitedBox(maxHeight: 120.0, child: Image.memory(_img.buffer.asUint8List())),
                  ),
                  getSubmitButton(context),
                ],
              )
            ],
          ),
        ));
  }
}
