import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/forms/declaration/view/declaration_view.dart';
import 'package:lesedi/utils/global.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterAndElectricityFormNotifier extends ChangeNotifier {
  TextEditingController waterMeterNumberController = TextEditingController();
  TextEditingController waterMeterReadingController = TextEditingController();
  TextEditingController electricityMeterNumberController =
      TextEditingController();
  TextEditingController electricityMeterReadingsController =
      TextEditingController();

  List<String> waterMeterAttachmentsList = [];
  List<String> electricMeterAttachmentsList = [];
  List<String> propertyAttachmentsList = [];

  ServicesRequest request = ServicesRequest();

  bool isWaterAttachments = false;
  bool isElectricityAttachments = false;
  bool isPropertyAttachments = false;
  bool isFormLoading = false;

  waterAttachmentsLoading(bool val) {
    isWaterAttachments = val;
    notifyListeners();
  }

  electricityAttachmentsLoading(bool val) {
    isElectricityAttachments = val;
    notifyListeners();
  }

  propertyAttachmentsLoading(bool val) {
    isPropertyAttachments = val;
    notifyListeners();
  }

  formLoading(bool val) {
    isFormLoading = val;
    notifyListeners();
  }

  Future<void> getWaterAttachments({
    bool isCamera = true,
    required int applicant_id,
    required String image_name,
    required BuildContext context,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile> imageList = <XFile>[];
    if (isCamera) {
      XFile? img = await imagePicker.pickImage(source: ImageSource.camera);
      if (img != null) {
        imageList.add(img);
      }
    } else {
      imageList = await imagePicker.pickMultiImage();
    }

    if (imageList.isNotEmpty) {
      List<File> files = imageList.map((path) => File(path.path)).toList();
      waterAttachmentsLoading(true);
      for (var file in files) {
        try {
          if (isWaterAttachments == true) {
            showToastMessage('Image Uploading Please wait');
            print(applicant_id);
          }
          FormData formData = new FormData.fromMap({
            "application_id": applicant_id,
            "${image_name}[]": await MultipartFile.fromFile(file.path,
                filename: file.path.split("/").last)
          });
          print("form =====> this is form ${formData}");
          print("form =====> this is id ${applicant_id}");

          Map<String, dynamic> map = {
            "application_id": applicant_id,
            "${image_name}": file.path
          };
          LocalStorage.localStorage.saveFormData(map);

          print(formData.toString());

          List<dynamic>? attachment =
              await uploadImage(formData: formData, imageName: image_name);
          waterAttachmentsLoading(false);
          print("attachments ==. ${attachment}");

          if (attachment != null) {
            // waterMeterAttachment=attachment[0];
            waterMeterAttachmentsList.add(file.path);

            // waterMeterAttachmentsList.add(attachment);
            print(
                "waterMeterAttachmentsList ${waterMeterAttachmentsList.length}");

            //     sharedPreferences.setString(image_name, attachment);
            //
          }
          print("attachment is ${attachment}");
        } on SocketException catch (e) {
          Fluttertoast.showToast(msg: "Internet not available");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } on FormatException catch (e) {
          Fluttertoast.showToast(msg: "Something went wrong");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } catch (e) {
          Fluttertoast.showToast(msg: "Something went wrong");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        }
      }
    }
    notifyListeners();
  }


  Future<void> getElectricAttachments({
    bool isCamera = true,
    required int applicant_id,
    required String image_name,
    required BuildContext context,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile> imageList = <XFile>[];
    if (isCamera) {
      XFile? img = await imagePicker.pickImage(source: ImageSource.camera);
      if (img != null) {
        imageList.add(img);
      }
    } else {
      imageList = await imagePicker.pickMultiImage();
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (imageList.isNotEmpty) {
      List<File> files = imageList.map((path) => File(path.path)).toList();
      electricityAttachmentsLoading(true);
      for (var file in files) {
        try {
          if (isElectricityAttachments == true) {
            showToastMessage('Image Uploading Please wait');
            print(applicant_id);
          }
          FormData formData = new FormData.fromMap({
            "application_id": applicant_id,
            "${image_name}[]": await MultipartFile.fromFile(file.path,
                filename: file.path.split("/").last)
          });
          print("form =====> this is form ${formData}");
          print("form =====> this is id ${applicant_id}");

          Map<String, dynamic> map = {
            "application_id": applicant_id,
            "${image_name}": file.path
          };
          LocalStorage.localStorage.saveFormData(map);

          print(formData.toString());

          List<dynamic>? attachment =
              await uploadImage(formData: formData, imageName: image_name);
          electricityAttachmentsLoading(false);
          print("attachments ==. ${attachment}");

          if (attachment != null) {
            // waterMeterAttachment=attachment[0];
            electricMeterAttachmentsList.add(file.path);

            // waterMeterAttachmentsList.add(attachment);
            print(
                "electricMeterAttachmentsList ${electricMeterAttachmentsList.length}");

            //     sharedPreferences.setString(image_name, attachment);
            //
          }
          print("attachment is ${attachment}");
        } on SocketException catch (e) {
          Fluttertoast.showToast(msg: "Internet not available");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } on FormatException catch (e) {
          Fluttertoast.showToast(msg: "Bad Request");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } catch (e) {
          Fluttertoast.showToast(msg: "Something went wrong");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getPropertyAttachments({
    bool isCamera = true,
    required int applicant_id,
    required String image_name,
    required BuildContext context,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile> imageList = <XFile>[];
    if (isCamera) {
      XFile? img = await imagePicker.pickImage(source: ImageSource.camera);
      if (img != null) {
        imageList.add(img);
      }
    } else {
      imageList = await imagePicker.pickMultiImage();
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (imageList.isNotEmpty) {
      List<File> files = imageList.map((path) => File(path.path)).toList();
      propertyAttachmentsLoading(true);
      for (var file in files) {
        try {
          if (isPropertyAttachments == true) {
            showToastMessage('Image Uploading Please wait');
            print(applicant_id);
          }
          FormData formData = new FormData.fromMap({
            "application_id": applicant_id,
            "${image_name}[]": await MultipartFile.fromFile(file.path,
                filename: file.path.split("/").last)
          });
          print("form =====> this is form ${formData}");
          print("form =====> this is id ${applicant_id}");

          Map<String, dynamic> map = {
            "application_id": applicant_id,
            "${image_name}": file.path
          };
          LocalStorage.localStorage.saveFormData(map);

          print(formData.toString());

          List<dynamic>? attachment =
              await uploadImage(formData: formData, imageName: image_name);
          propertyAttachmentsLoading(false);
          print("attachments ==. ${attachment}");

          if (attachment != null) {
            // waterMeterAttachment=attachment[0];
            propertyAttachmentsList.add(file.path);

            // waterMeterAttachmentsList.add(attachment);
            print(
                "electricMeterAttachmentsList ${propertyAttachmentsList.length}");

            //     sharedPreferences.setString(image_name, attachment);
            //
          }
          print("attachment is ${attachment}");
        } on SocketException catch (e) {
          Fluttertoast.showToast(msg: "Internet not available");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } on FormatException catch (e) {
          Fluttertoast.showToast(msg: "Bad Request");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        } catch (e) {
          Fluttertoast.showToast(msg: "Something went wrong");
          electricityAttachmentsLoading(false);
          print('dsa');
          print(e);
        }
      }
    }
    notifyListeners();
  }

  Future<dynamic> uploadImage(
      {required FormData formData, required String imageName}) async {
    print("image => ${imageName}");
    print("length => ${formData.files.length}");
    print("files => ${formData.toString()}");
    if (MyConstants.myConst.internet ?? false) {
      showToastMessage('File Uploading Please wait');
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 3), // 3 minutes
          receiveTimeout: Duration(minutes: 3) // 3 minuntes
          ));
      dio.interceptors.add(LogInterceptor(responseBody: true));

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var userID = await sharedPreferences.getString('userID');
      var authToken = await sharedPreferences.getString('auth-token');
      print("token ${authToken}");
      print("user ID ${userID}");
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

        log("this is response ${jsonResponse['data']}");
        showToastMessage(jsonResponse['message']);
        notifyListeners();
        return jsonResponse['data'][imageName];
        // sharedPreferences.setString("spouse_id", waterMeterAttachment!);

        // getAttachment();
      }

      showToastMessage('File Uploaded');
    } else {}
  }

  Future submitForm({
    required BuildContext context,
    int? applicantId,
    required bool previousFormSubmitted,
  }) async {

    /// <<<-------------------------validating form------------------------>>>>
    if (waterMeterNumberController.text.isEmpty ||
    waterMeterReadingController.text.isEmpty ||
    electricityMeterNumberController.text.isEmpty ||
    electricityMeterNumberController.text.isEmpty  ){

      showToastMessage("Please fill all fields");
      return;
    }
    formLoading(true);


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    // checkInternetAvailability();
    await request.ifInternetAvailable();
    print('okay');
    print(userID);
    print('okay');
    Map<String, dynamic>? data = {
      "application_id": applicantId,
      'water_meter_number': waterMeterNumberController.text,
      'water_meter_reading': waterMeterReadingController.text,
      'electricity_meter_number': electricityMeterNumberController.text,
      'electricity_meter_reading': electricityMeterReadingsController.text,
    };

    LocalStorage.localStorage.saveFormData(data);

    /// <<<-------------------------will be called when internet is available------------------------>>>>

    if (MyConstants.myConst.internet ?? false) {

      try{
        var jsonResponse;
        http.Response response;

        /// <<<-------------------------will work if previous form is submitted------------------------>>>>
        if(previousFormSubmitted){
        response = await http.post(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
          },

            body: jsonEncode(data)
        );}
        /// <<<-------------------------will work if previous form is not submitted------------------------>>>>
        else
          {
            data = LocalStorage.localStorage
                .getFormData(MyConstants.myConst.currentApplicantId??"");
            response = await http.post(
                Uri.parse(
                    "${MyConstants.myConst.baseUrl}api/v1/users/application_form"),
                headers: {
                  'Content-Type': 'application/json',
                  'uuid': userID ?? "",
                  'Authentication': authToken ?? ""
                },
                body: jsonEncode(data));
          }

        print(response.headers);

        print(response.body);
        if (response.statusCode == 200) {
          jsonResponse = jsonDecode(response.body);

          if (!previousFormSubmitted) {
            Map<dynamic,dynamic> appId={};
            appId = jsonDecode(response.body);
            sharedPreferences.setInt('applicant_id', appId['application_id']);
            applicantId = appId['application_id'];
          } else {
            sharedPreferences.setInt('applicant_id', data?['application_id']);
            applicantId = data?['application_id'];
          }

          previousFormSubmitted = true;
          showToastMessage('Form Submitted');
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => Declaration(
                  applicantId!, previousFormSubmitted)));
          formLoading(false);
        } else {
          formLoading(false);
          jsonResponse = json.decode(response.body);
          showToastMessage(jsonResponse['message']);

        }
      }
      on SocketException catch (e) {
        Fluttertoast.showToast(msg: "Internet not available");
        formLoading(false);
        print('dsa');
        print(e);
      } on FormatException catch (e) {
        Fluttertoast.showToast(msg: "Bad Request");
        formLoading(false);
        print('dsa');
        print(e);
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
        formLoading(false);
        print('dsa');
        print(e);
      }

    }
    else {
      formLoading(false);
      print("B1 Navigated from Else");
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => Declaration(
              applicantId!, previousFormSubmitted)));
    }
  }


//   Future submitForm({
//     required BuildContext context,
//     int? applicantId,
//     required bool previousFormSubmitted,
//   }) async {
//     if (
//     waterMeterNumberController.text.isEmpty ||
//     waterMeterReadingController.text.isEmpty ||
//     electricityMeterNumberController.text.isEmpty ||
//     electricityMeterNumberController.text.isEmpty  ){
//
//       showToastMessage("Please fill all fields");
//       return;
//     }
//     formLoading(true);
//
//
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userID = sharedPreferences.getString('userID');
//     var authToken = sharedPreferences.getString('auth-token');
//     // checkInternetAvailability();
//     await request.ifInternetAvailable();
//     print('okay');
//     print(userID);
//     print('okay');
//     Map<String, dynamic> data = {
//       "application_id": applicantId,
//       'water_meter_number': waterMeterNumberController.text,
//       'water_meter_reading': waterMeterReadingController.text,
//       'electricity_meter_number': electricityMeterNumberController.text,
//       'electricity_meter_reading': electricityMeterReadingsController.text,
//     };
//
//     if (MyConstants.myConst.internet ?? false) {
//
//       try{
//         var jsonResponse;
//         http.Response response = await http.post(
//           Uri.parse(
//               "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
//           headers: {
//             'Content-Type': 'application/json',
//             'uuid': userID ?? "",
//             'Authentication': authToken ?? ""
//           },
//
//             body: jsonEncode(data)
//         );
//
//         print(response.headers);
//
//         print(response.body);
//         // print(data);
//         if (response.statusCode == 200) {
//           jsonResponse = jsonDecode(response.body);
//           // sharedPreferences.setInt('applicant_id', data['application_id']);
//           // LocalStorage.localStorage.clearCurrentApplication();
//
//           previousFormSubmitted = true;
//           LocalStorage.localStorage.saveFormData(data);
//
//           showToastMessage('Form Submitted');
//
//           Navigator.of(context).push(PageRouteBuilder(
//               pageBuilder: (_, __, ___) => Declaration(
//                   applicantId!, previousFormSubmitted)));
//           formLoading(false);
//         } else {
//           formLoading(false);
//           jsonResponse = json.decode(response.body);
//           print('data');
// //        print(jsonResponse);
//           showToastMessage(jsonResponse['message']);
//
//         }
//       }
//       on SocketException catch (e) {
//         Fluttertoast.showToast(msg: "Internet not available");
//         formLoading(false);
//         print('dsa');
//         print(e);
//       } on FormatException catch (e) {
//         Fluttertoast.showToast(msg: "Bad Request");
//         formLoading(false);
//         print('dsa');
//         print(e);
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Something went wrong");
//         formLoading(false);
//         print('dsa');
//         print(e);
//       }
//
//     }
//   }
}
