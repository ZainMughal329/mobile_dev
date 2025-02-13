import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import '../utils/global.dart';
import 'package:lesedi/utils/globals.dart' as global;

class HouseHold extends StatefulWidget {
  int applicant_id;
  String image_name;

  HouseHold(this.applicant_id, this.image_name);

  @override
  _HouseHoldState createState() => _HouseHoldState();
}

class _HouseHoldState extends State<HouseHold> {
  String? _fileName;
  String? _path;
  Map<String, String>? _paths;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType? _pickingType;
  String? profileType;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  List<String> house_hold_id = [];
  ServicesRequest request = ServicesRequest();
  List<String> household_list = <String>[];

//var
  @override
  void initState() {
    super.initState();
    // getAttachment();
    print('id agye hai');
//    print(widget.custom_requirement_id);
    _controller.addListener(() => _extension = _controller.text);
    checkInternetAvailability();
  }

  var house_hold;

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');
//    global.occupantImages;
//    print(global.occupantImages);
    setState(() {
//      global.occupantImages;
//      print(global.occupantImages);
      house_hold = sharedPreferences.getStringList('household');
    });
  }

  void _filePicker() async {
    await request.ifInternetAvailable();
    household_list = <String>[];
    print('hi');

    Navigator.pop(context, true);
    setState(() {
      _isLoadingSecondary = true;
    });
    // List<File> listFiles  = await FilePicker.getMultiFile();
    // List<File> listFiles = await FilePicker.getMultiFile(
    //     type: FileType.custom, allowedExtensions: ['jpg']);
    FilePickerResult? listFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
      allowMultiple: true,
    );
    final Map<String, dynamic> _formData = {};

    _formData['application_id'] = widget.applicant_id;
    if (listFiles != null) {
      List<File> files = listFiles.paths.map((path) => File(path!)).toList();

      var img = [];
      List<String> img_paths = <String>[];
      for (int j = 0; j < files.length; j++) {
        img.add(await MultipartFile.fromFile(files[j].path,
            filename: 'household($j)'));
        img_paths.add(files[j].path);
        household_list.add(files[j].path);
        print(_formData);
      }
      _formData['household[]'] = img;
      print('idsss ++++++++');
      print(_formData['household[]']);
      _isLoadingSecondary = true;

      try {
        if (_isLoadingSecondary == true) {
          print(widget.applicant_id);
        }
        FormData formData = new FormData.fromMap(_formData);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'household[]': jsonEncode(img_paths)
        };
        LocalStorage.localStorage.saveFormData(map);

        print('daataaaa');
//
        print(formData);
        // checkInternetAvailability();
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
          var userID = sharedPreferences.getString('userID');
          var authToken = sharedPreferences.getString('auth-token');

          Response response = await dio.post(
            '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
            data: formData, // Post with Stream<List<int>>
            options: Options(
                headers: {'uuid': userID, 'Authentication': authToken},
                contentType: "*/*",
                responseType: ResponseType.json),
          );

          print(response.data.toString());
          // var jsonResponse = json.decode(response.data);
          var jsonResponse = response.data;
          print('yaha aya');
          if (response.statusCode == 200) {
            setState(() {
              _isLoadingSecondary = false;
              print('uploading occupant');
              print(jsonResponse);
              print('yaha aya');
              var houseHold_list = jsonResponse['data']['household'];
              String? fileName;
              print('filename');
              print(houseHold_list);
              var newEntry;
              print('yaha aya');
              for (int p = 0; p < houseHold_list.length; p++) {
                print('filename');
                newEntry = houseHold_list[p];
                fileName = houseHold_list[p].split('/').last;

//              global.occupantImages = dependent_idss;
              }

              if (fileName!.contains('.png') ||
                  fileName.contains('.jpg') ||
                  fileName.contains('.jpeg') ||
                  fileName.contains('.gif')) {
//            if (jsonResponse['data']['content_type'][0].toString() == 'image/jpeg' || jsonResponse['data']['content_type'][0].toString() == 'image/jpg'
//                || jsonResponse['data']['content_type'][0].toString() == 'image/png' || jsonResponse['data']['content_type'][0].toString() == 'image/gif'
//            ){
                print('wiii');

                house_hold_id.add(newEntry);
              } else {
                house_hold_id.add(
                    'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
              }
              sharedPreferences.setStringList("household", house_hold_id);

              getAttachment();
            });

            showToastMessage('File Uploaded');
          }
        } else {
          setState(() {});
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
        setState(() {
          _isLoading = false;
        });
        print('dsa');
        print(e);
      }
    }

    // var img = [];
    // List<String> img_paths = <String>[];
    // for (int j = 0; j < listFiles.length; j++) {
    //   img.add(await MultipartFile.fromFile(listFiles[j].path,
    //       filename: 'household($j)'));
    //   img_paths.add(listFiles[j].path);
    //   household_list.add(listFiles[j].path);
    //   print(_formData);
    // }

    // _formData['household[]'] = img;
    // print('idsss ++++++++');
    // print(_formData['household[]']);
    // checkInternetAvailability();

//     if (listFiles != null) {
//       _isLoadingSecondary = true;
//
//       try {
//         if (_isLoadingSecondary == true) {
//           print(widget.applicant_id);
//         }
//         FormData formData = new FormData.fromMap(_formData);
//
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           'household[]': jsonEncode(img_paths)
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print('daataaaa');
// //
//         print(formData);
//         // checkInternetAvailability();
//         if (MyConstants.myConst.internet ?? false) {
//           showToastMessage('File Uploading Please wait');
//           var dio = Dio(BaseOptions(
//               receiveDataWhenStatusError: true,
//               connectTimeout: Duration(minutes: 3), // 3 minutes
//               receiveTimeout: Duration(minutes: 3) // 3 minuntes
//               ));
//           dio.interceptors.add(LogInterceptor(responseBody: true));
//           SharedPreferences sharedPreferences =
//               await SharedPreferences.getInstance();
//           var userID = sharedPreferences.getString('userID');
//           var authToken = sharedPreferences.getString('auth-token');
//
//           Response response = await dio.post(
//             '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
//             data: formData, // Post with Stream<List<int>>
//             options: Options(
//                 headers: {'uuid': userID, 'Authentication': authToken},
//                 contentType: "*/*",
//                 responseType: ResponseType.json),
//           );
//
//           print(response.data.toString());
//           // var jsonResponse = json.decode(response.data);
//           var jsonResponse = response.data;
//           print('yaha aya');
//           if (response.statusCode == 200) {
//             setState(() {
//               _isLoadingSecondary = false;
//               print('uploading occupant');
//               print(jsonResponse);
//               print('yaha aya');
//               var houseHold_list = jsonResponse['data']['household'];
//               String? fileName;
//               print('filename');
//               print(houseHold_list);
//               var newEntry;
//               print('yaha aya');
//               for (int p = 0; p < houseHold_list.length; p++) {
//                 print('filename');
//                 newEntry = houseHold_list[p];
//                 fileName = houseHold_list[p].split('/').last;
//
// //              global.occupantImages = dependent_idss;
//
//               }
//
//               if (fileName!.contains('.png') ||
//                   fileName.contains('.jpg') ||
//                   fileName.contains('.jpeg') ||
//                   fileName.contains('.gif')) {
// //            if (jsonResponse['data']['content_type'][0].toString() == 'image/jpeg' || jsonResponse['data']['content_type'][0].toString() == 'image/jpg'
// //                || jsonResponse['data']['content_type'][0].toString() == 'image/png' || jsonResponse['data']['content_type'][0].toString() == 'image/gif'
// //            ){
//                 print('wiii');
//
//                 house_hold_id.add(newEntry);
//               } else {
//                 house_hold_id.add(
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//               }
//               sharedPreferences.setStringList("household", house_hold_id);
//
//               getAttachment();
//             });
//
//             showToastMessage('File Uploaded');
//           }
//         } else {
//           setState(() {});
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Something went wrong");
//         setState(() {
//           _isLoading = false;
//         });
//         print('dsa');
//         print(e);
//       }
//     }
  }

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? auth_token = sharedPreferences.getString('token');
  }

  File? _image;
  final picker = ImagePicker();

  void uploadImage() async {
    await request.ifInternetAvailable();
    List<String> img_paths = <String>[];
    household_list = <String>[];
    setState(() {
      _isLoadingSecondary = true;
    });
    Navigator.pop(context, true);
    File? file;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
                  onFile: (onFile) {
                    print("Inside house hold file");
                    file = onFile;
                    Navigator.pop(context);
                  },
                  enableZoom: true,
                  resolutionPreset: ResolutionPreset.medium,
                  cameraSide: CameraSide.all,
                )
            // Camera(
            //   mode: CameraMode.normal,
            //   imageMask: CameraFocus.rectangle(
            //     color: Colors.black.withOpacity(0.5),
            //   ),
            // )

            ));
    print(file?.path ?? "");

    if (file != null) {
      try {
        setState(() {
          _image = File(file?.path ?? "");
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }

        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          'household[]': await MultipartFile.fromFile(_image?.path ?? "",
              filename: 'household.jpg')
        });

        img_paths.add(_image?.path ?? "");
        household_list.add(_image?.path ?? "");
        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'household[]': jsonEncode(img_paths)
        };
        LocalStorage.localStorage.saveFormData(map);

        print(formData.toString());

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
          var userID = sharedPreferences.getString('userID');
          var authToken = sharedPreferences.getString('auth-token');

          Response response = await dio.post(
            '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
            data: formData, // Post with Stream<List<int>>
            options: Options(
                headers: {'uuid': userID, 'Authentication': authToken},
                contentType: "*/*",
                responseType: ResponseType.json),
          );
          if (response.statusCode == 200) {
            // var jsonResponse = json.decode(response.data);
            var jsonResponse = response.data;
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
            setState(() {
              _isLoadingSecondary = false;
              var houseHold_list = jsonResponse['data']['household'];
              var newEntry;
              for (int p = 0; p < houseHold_list.length; p++) {
                print('dependent_idsssss');

                newEntry = houseHold_list[p];

//              global.occupantImages = dependent_idss;
//              print(house_hold_id);
              }
              house_hold_id.add(newEntry);
              sharedPreferences.setStringList("household", house_hold_id);
              getAttachment();
            });

            showToastMessage('Form Submitted');
          }
        } else {
          setState(() {});
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
        setState(() {
          _isLoading = false;
        });
        print('dsa');
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
//        _filePicker();
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upload File"),
                      InkWell(
                          onTap: () => Navigator.pop(context, true),
                          child: Icon(Icons.clear))
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          InkWell(
                            onTap: () {
                              _filePicker();
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 30, bottom: 0, top: 20),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  height: 55.0,
                                  width: 600.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.black,
                                            size: 20,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Chosse From Gallery',
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0.2,
                                            fontFamily: "Open Sans",
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 0.0)
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(colors: <Color>[
                                        Color(0xFFFFFFFF),
                                        Color(0xFFFFFFFF)
                                      ])),
//                          decoration: BoxDecoration(
//                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
//                              borderRadius: BorderRadius.circular(10.0),
//                              gradient: LinearGradient(
//                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              uploadImage();

//                        File file = await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                            Camera(
//                              onFile: (File file) => file,
//
//                              mode: CameraMode.normal,
//                              imageMask: CameraFocus.rectangle(
//                                color: Colors.black.withOpacity(0.5),
//                              ),
//                            )
//                        )
//                        );

//                      _onCameraPressed();
//                      setState(() {
//                        _isLoadingSecondary = true;
//
//                      });
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 30, bottom: 0, top: 0),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  height: 55.0,
//                        width: 600.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.camera_enhance,
                                            color: Colors.black,
                                            size: 20,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Chosse From Camera',
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0.2,
                                            fontFamily: "Open Sans",
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 0.0)
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(colors: <Color>[
                                        Color(0xFFFFFFFF),
                                        Color(0xFFFFFFFF)
                                      ])),
//                          decoration: BoxDecoration(
//                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
//                              borderRadius: BorderRadius.circular(10.0),
//                              gradient: LinearGradient(
//                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 0),
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              height: 55.0,
//                        width: 600.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerRight,
                      child: !_isLoadingSecondary
                          ? Icon(
                              Icons.file_upload,
                              color: Colors.black,
                              size: 20,
                            )
                          : MyConstants.myConst.internet ?? false
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.done,
                                  color: Colors.black,
                                  size: 20,
                                )),
                  SizedBox(
                    width: 10,
                  ),
                  !_isLoadingSecondary
                      ? Text(
                          'Upload',
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.2,
                              fontFamily: "Open Sans",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800),
                        )
                      : Text(
                          MyConstants.myConst.internet ?? false
                              ? 'Uploading'
                              : "Saved",
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.2,
                              fontFamily: "Open Sans",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800),
                        ),
                ],
              ),
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black38, blurRadius: 0.0)
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xFFFFFFFF), Color(0xFFFFFFFF)])),
//                          decoration: BoxDecoration(
//                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
//                              borderRadius: BorderRadius.circular(10.0),
//                              gradient: LinearGradient(
//                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
            ),
          ),
          (house_hold != null && household_list.isEmpty)
              ? Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    alignment: Alignment.center,
                    height: house_hold != null ? 150 : 0,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(house_hold.length, (index) {
                          return CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: house_hold[index] != null
                                ? house_hold[index]
                                : 'http://via.placeholder.com/1x1',
//            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        })),
                  ),
                )
              : household_list.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.center,
                      height: 150,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(household_list.length, (index) {
                            return Center(
                              child: Image.file(
                                File(household_list[index]),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          })),
                    )
                  : SizedBox(),
        ],
      ),
    );
  }
}
