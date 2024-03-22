import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeclarationNotifier extends ChangeNotifier {

  ServicesRequest request = ServicesRequest();

  var encoded;
  ByteData img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final signature = GlobalKey<SignatureState>();
  DateTime selectedDate = DateTime.now();
  String? formattedDate;
  bool isLoadingSecondary = false;
  var storeSignature;
  File? storePath;
  var ImageNew;
  File? file;

  setLoading(bool val) {
    isLoadingSecondary = val;
    notifyListeners();
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
        selectedDate = picked;
        print(selectedDate);
        notifyListeners();
  }

  Future onSubmit(applicant_id,previousFormSubmitted,context) async {
    await request.ifInternetAvailable();
    String url;
    print("OnSubmit Called");
    print("File is ::: $file");
    print("Store Signature ::: $storeSignature");

    if (file != null || storeSignature != null) {
      try {
        Map<String, dynamic>? data = {
          "application_id": applicant_id,
          "signature_date": selectedDate,
          "signature": await MultipartFile.fromFile(
              storeSignature != null ? storeSignature : file?.path,
              filename: 'signature.jpg')
        };
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate);
        print("DateTime ::: $formattedDate");
        Map<String, dynamic> map = {
          "application_id": applicant_id,
          "signature_date": formattedDate,
          "signature": file?.path
        };

        FormData? formData;
        LocalStorage.localStorage.saveFormData(map);

        print('form data');

        print(formData??"");

        if (MyConstants.myConst.internet ?? false) {
          setLoading(true);
          var dio = Dio(BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: Duration(minutes: 3), // 3 minutes
              receiveTimeout: Duration(minutes: 3)// 3 minuntes
          ));
          dio.interceptors.add(LogInterceptor(responseBody: true));
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          var userID = sharedPreferences.getString('userID');
          var authToken = sharedPreferences.getString('auth-token');
          if (previousFormSubmitted) {
            formData = new FormData.fromMap(data);
            url =
            '${MyConstants.myConst.baseUrl}api/v1/users/update_application';
          } else {
            url = '${MyConstants.myConst.baseUrl}api/v1/users/application_form';
            data = await request
                .getFormData(MyConstants.myConst.currentApplicantId??"");
            formData = FormData.fromMap(data!);
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

            if (!previousFormSubmitted) {
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
                pageBuilder: (_, __, ___) => Dashboard(userRole: role??"",applicant_id:  applicant_id??0)));
            setLoading(false);


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
              pageBuilder: (_, __, ___) => Dashboard(userRole: role??"",applicant_id:  applicant_id??0)));
        }
      } catch (e) {
        setLoading(false);

        print('At ::: dsa');
        print(e);
      }
    } else {
      print('ss');
    }
  }

  void showContent({required BuildContext context,required int applicant_id}) {
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
                    key: signature,
                    onSign: () {
                      final sign = signature.currentState;
                      debugPrint(
                          '${sign?.points.length} points in the signature');
                    },
//                    backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                    strokeWidth: strokeWidth,
                  ),
                ),
                MaterialButton(
                    color: AppColors.PRIMARY_COLOR,
                    onPressed: () async {
                      final sign = signature.currentState;
                      //retrieve image data, do whatever you want with it (send to server, save locally...)

                      final image = await sign?.getData();
                      var data = await image?.toByteData(
                          format: ui.ImageByteFormat.png);

//                      print(imageHOlder);
                      print(data);
                      sign?.clear();
                      encoded = base64.encode(data!.buffer.asUint8List());
                      Uint8List bytes = base64.decode(encoded);
                      String dir =
                          (await getApplicationDocumentsDirectory()).path;
                      String fullPath =
                          '$dir/${DateTime.now().millisecondsSinceEpoch}.png';

                      file = File(fullPath);

                      print(applicant_id);

                      await file?.writeAsBytes(bytes);

                      print('path');

                      print(file?.path);

                      final result = await ImageGallerySaver.saveImage(bytes);

                      print('result');

                      print(result);
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();


                        img = data;
                        ImageNew = img.buffer.asUint8List();
                        print('path data');
                        print(img.buffer.asByteData());
                        print(img.buffer.asUint8List());
                        print('path');
                        print(file);
                        prefs.setString("fileStorage", file?.path??"");
                      notifyListeners();
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
  getFile() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      storeSignature = sharedPreferences.getString('fileStorage');

      print(storeSignature);
    notifyListeners();
  }
  init(){
    getFile();
    checkInternetAvailability();
  }
}
