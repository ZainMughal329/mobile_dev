import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/global.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterAndElectricityFormNotifier extends ChangeNotifier {
  TextEditingController waterMeterNumberController = TextEditingController();
  TextEditingController waterMeterReadingController = TextEditingController();
  TextEditingController electricityMeterNumberController =
      TextEditingController();
  TextEditingController electricityMeterReadingsController =
      TextEditingController();

  List<String> waterMeterAttachmentsList = <String>[];

  bool isWaterAttachments = false;
  bool electricityAttachments = false;
  bool propertyAttachments = false;

  waterAttachmentsLoading(bool val) {
    isWaterAttachments = val;
    notifyListeners();
  }

  electricityAttachmentsLoading(bool val) {
    electricityAttachments = val;
    notifyListeners();
  }

  propertyAttachmentsLoading(bool val) {
    propertyAttachments = val;
    notifyListeners();
  }

  Future<void> getImage({
    bool isCamera = true,
    required int applicant_id,
    required String image_name,
    required BuildContext context,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'png'],
      type: FileType.custom,
    );
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      waterAttachmentsLoading(true);
      for(var file in files)
      {
        // try {
          if (isWaterAttachments == true) {
         showToastMessage('Image Uploading Please wait');
            print(applicant_id);
          }
          FormData formData = new FormData.fromMap({
            "application_id": applicant_id,
            image_name: await MultipartFile.fromFile(
                file.path,
                filename: "waterMeter.jpg")
          });
          print("form =====> this is form ${formData}");
          print("form =====> this is id ${applicant_id}");
          waterMeterAttachmentsList.add(file.path);

          Map<String, dynamic> map = {
            "application_id": applicant_id,
            "${image_name}[]": file.path
          };
          LocalStorage.localStorage.saveFormData(map);

          print(formData.toString());

          String? attachment = await uploadImage(formData: formData,imageName: image_name);
          if(attachment!=null)
            {
              sharedPreferences.setString(image_name, attachment!);

            }
           print("attachment is ${attachment}");
        // } catch (e) {
        //   Fluttertoast.showToast(msg: "Something went wrong");
        //   waterAttachmentsLoading(false);
        //   print('dsa');
        //   print(e);
        // }
      }


    }

    notifyListeners();
  }

  Future<String?> uploadImage({required FormData formData,required String imageName}) async{
    print("image => ${imageName}");
    print("length => ${formData.files.length}");
    print("files => ${formData.toString()}");
    if (MyConstants.myConst.internet??false) {
      showToastMessage('File Uploading Please wait');
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 3), // 3 minutes
          receiveTimeout: Duration(minutes: 3) // 3 minuntes
      ));
      dio.interceptors.add(LogInterceptor(responseBody: true));

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      var userID = sharedPreferences.getString('userID');
      var authToken = sharedPreferences.getString('auth-token');
      var jsonResponse;
      Response response = await dio.post(
        '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
        data: formData, // Post with Stream<List<int>>
        options: Options(
            headers: {'uuid': userID, 'Authentication': authToken},
            contentType: "*/*",
            responseType: ResponseType.json),
        // ),
      );
      if (response.statusCode == 200) {
        // jsonResponse = json.decode(response.data);
        var jsonResponse = response.data;
        print('data');
        print("image name ${imageName}");
        print(jsonResponse['data'][imageName]);

        showToastMessage(jsonResponse['message']);



        final attachment = jsonResponse['data'][imageName];
        // String fileName = attachment!.split('/').last;
        // print('filename');
        //
        // if (fileName.contains('.png') ||
        //     fileName.contains('.jpg') ||
        //     fileName.contains('.jpeg') ||
        //     fileName.contains('.gif')) {
        //   print('wiii');
        //   // waterMeterAttachment = jsonResponse['data']['spouse_id'];
          return   jsonResponse['data'][imageName];
        // } else {
        //   // waterMeterAttachment =
        //   // 'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
        //   return 'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
        // }
        // sharedPreferences.setString("spouse_id", waterMeterAttachment!);

        // getAttachment();
      };

      showToastMessage('File Uploaded');
    }
    else {
    }
    waterAttachmentsLoading(false);
  }

}
