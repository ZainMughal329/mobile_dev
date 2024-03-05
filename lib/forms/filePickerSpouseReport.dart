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
import 'package:lesedi/constans/Constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import '../global.dart';
import 'package:lesedi/globals.dart' as global;

class FilePickerSpouseCreditReport extends StatefulWidget {
  int applicant_id;
  String image_name;

  FilePickerSpouseCreditReport(this.applicant_id, this.image_name);

  @override
  _FilePickerSpouseCreditReportState createState() =>
      _FilePickerSpouseCreditReportState();
}

class _FilePickerSpouseCreditReportState
    extends State<FilePickerSpouseCreditReport> {
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

  // List<String> spouse_file_id = List<String>();
  List<String> spouse_file_id = [];
  ServicesRequest request = ServicesRequest();
  List<String> spouseCreditList = <String>[];

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

  var spouse__certificate;

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      spouse__certificate = sharedPreferences.getStringList('spouse_reports');
    });
  }

  void _filePicker() async {
    await request.ifInternetAvailable();
    spouseCreditList = <String>[];

    Navigator.pop(context, true);

    // List<File> listFiles = await FilePicker.getMultiFile(
    //     type: FileType.custom, allowedExtensions: ['jpg']);
    FilePickerResult? listFiles = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg']);
    if (listFiles != null) {
      List<File> files = listFiles.paths.map((path) => File(path!)).toList();
      if (files.length > 3) {
        showToastMessage("You can not upload more than three files.");
        setState(() {
          _isLoadingSecondary = false;
        });
        return;
      } else {
        final Map<String, dynamic> _formData = {};

        _formData['application_id'] = widget.applicant_id;
        var img = [];
        List<String> img_paths = <String>[];
        for (int j = 0; j < files.length; j++) {
          img.add(await MultipartFile.fromFile(files[j].path,
              filename: 'spouse_reports($j)'));
          img_paths.add(files[j].path);
          spouseCreditList.add(files[j].path);

          print(_formData);
        }
        _formData['spouse_reports[]'] = img;

        print(_formData['spouse_reports[]']);
        try {
          if (_isLoadingSecondary == true) {
            print(widget.applicant_id);
          }
          FormData formData = new FormData.fromMap(_formData);

          Map<String, dynamic> map = {
            "application_id": widget.applicant_id,
            'spouse_reports': jsonEncode(img_paths)
          };
          print(map);
          print(jsonEncode(img_paths));
          LocalStorage.localStorage.saveFormData(map);
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
              print("Status Code of this Spouse Credit is :" +
                  response.statusCode.toString());
              setState(() {
                _isLoadingSecondary = false;
                print('uploading occupant');
                print(jsonResponse);
                print('yaha aya');
                var dependent_List = jsonResponse['data']['spouse_reports'];
                String? fileName;
                print('filename');
                print(dependent_List);
                var newEntry;
                print('yaha aya');
                for (int p = 0; p < dependent_List.length; p++) {
                  print('filename');
                  newEntry = dependent_List[p];
                  fileName = dependent_List[p].split('/').last;

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

                  spouse_file_id.add(newEntry);
                } else {
                  spouse_file_id.add(
                      'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
                }
                sharedPreferences.setStringList(
                    "spouse_reports", spouse_file_id);

                getAttachment();
              });

              showToastMessage('File Uploaded');
            }
          } else {
            setState(() {});
          }
        } catch (e) {
          // Fluttertoast.showToast(msg: "Something went wrong");
          setState(() {
            _isLoading = false;
          });
          print('dsa');
          print(e);
        }

      }
    }
    // if(listFiles.length >3)
    // {
    //   showToastMessage("You can not upload more than three files.");
    //   setState(() {
    //     _isLoadingSecondary = false;
    //   });
    //   return;
    // }
    // else {
      // final Map<String, dynamic> _formData = {};
      //
      // _formData['application_id'] = widget.applicant_id;
      //
      // var img = [];
      // List<String> img_paths = <String>[];
      // for (int j = 0; j < listFiles.length; j++) {
      //   img.add(await MultipartFile.fromFile(listFiles[j].path,
      //       filename: 'spouse_reports($j)'));
      //   img_paths.add(listFiles[j].path);
      //   spouseCreditList.add(listFiles[j].path);
      //
      //   print(_formData);
      // }

      // _formData['spouse_reports[]'] = img;
      //
      // print(_formData['spouse_reports[]']);
      // checkInternetAvailability();

//       if (listFiles != null) {
//         setState(() {
//           _isLoadingSecondary = true;
//         });
//
//         try {
//           if (_isLoadingSecondary == true) {
//             print(widget.applicant_id);
//           }
//           FormData formData = new FormData.fromMap(_formData);
//
//           Map<String, dynamic> map = {
//             "application_id": widget.applicant_id,
//             'spouse_reports': jsonEncode(img_paths)
//           };
//           print(map);
//           print(jsonEncode(img_paths));
//           LocalStorage.localStorage.saveFormData(map);
//           // checkInternetAvailability();
//           if (MyConstants.myConst.internet ?? false) {
//             showToastMessage('File Uploading Please wait');
//             var dio = Dio(BaseOptions(
//                 receiveDataWhenStatusError: true,
//                 connectTimeout: Duration(minutes: 3), // 3 minutes
//                 receiveTimeout: Duration(minutes: 3) // 3 minuntes
//                 ));
//             dio.interceptors.add(LogInterceptor(responseBody: true));
//             SharedPreferences sharedPreferences =
//                 await SharedPreferences.getInstance();
//             var userID = sharedPreferences.getString('userID');
//             var authToken = sharedPreferences.getString('auth-token');
//
//             Response response = await dio.post(
//               '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
//               data: formData, // Post with Stream<List<int>>
//               options: Options(
//                   headers: {'uuid': userID, 'Authentication': authToken},
//                   contentType: "*/*",
//                   responseType: ResponseType.json),
//             );
//
//             print(response.data.toString());
//             // var jsonResponse = json.decode(response.data);
//             var jsonResponse = response.data;
//             print('yaha aya');
//             if (response.statusCode == 200) {
//               print("Status Code of this Spouse Credit is :" +
//                   response.statusCode.toString());
//               setState(() {
//                 _isLoadingSecondary = false;
//                 print('uploading occupant');
//                 print(jsonResponse);
//                 print('yaha aya');
//                 var dependent_List = jsonResponse['data']['spouse_reports'];
//                 String? fileName;
//                 print('filename');
//                 print(dependent_List);
//                 var newEntry;
//                 print('yaha aya');
//                 for (int p = 0; p < dependent_List.length; p++) {
//                   print('filename');
//                   newEntry = dependent_List[p];
//                   fileName = dependent_List[p].split('/').last;
//
// //              global.occupantImages = dependent_idss;
//                 }
//
//                 if (fileName!.contains('.png') ||
//                     fileName.contains('.jpg') ||
//                     fileName.contains('.jpeg') ||
//                     fileName.contains('.gif')) {
// //            if (jsonResponse['data']['content_type'][0].toString() == 'image/jpeg' || jsonResponse['data']['content_type'][0].toString() == 'image/jpg'
// //                || jsonResponse['data']['content_type'][0].toString() == 'image/png' || jsonResponse['data']['content_type'][0].toString() == 'image/gif'
// //            ){
//                   print('wiii');
//
//                   spouse_file_id.add(newEntry);
//                 } else {
//                   spouse_file_id.add(
//                       'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//                 }
//                 sharedPreferences.setStringList(
//                     "spouse_reports", spouse_file_id);
//
//                 getAttachment();
//               });
//
//               showToastMessage('File Uploaded');
//             }
//           } else {
//             setState(() {});
//           }
//         } catch (e) {
//           // Fluttertoast.showToast(msg: "Something went wrong");
//           setState(() {
//             _isLoading = false;
//           });
//           print('dsa');
//           print(e);
//         }
//       }
    // }
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
    spouseCreditList = <String>[];
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

    if (file != null) {
      setState(() {
        _isLoadingSecondary = true;
      });
      try {
        setState(() {
          _image = File(file!.path);
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }

        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          'spouse_reports[]': await MultipartFile.fromFile(_image?.path ?? "",
              filename: 'spouse_reports.jpg')
        });

        img_paths.add(_image?.path ?? "");
        spouseCreditList.add(_image?.path ?? "");
        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'spouse_reports[]': jsonEncode(img_paths)
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
              var dependent_List = jsonResponse['data']['spouse_reports'];
              var newEntry;
              for (int p = 0; p < dependent_List.length; p++) {
                print('dependent_idsssss');

                newEntry = dependent_List[p];

//              global.occupantImages = dependent_idss;
//              print(spouse_file_id);
              }
              spouse_file_id.add(newEntry);
              sharedPreferences.setStringList("spouse_reports", spouse_file_id);
              getAttachment();
            });

            showToastMessage('Form Submitted');
          }
        } else {
          setState(() {});
        }
      } catch (e) {
        // Fluttertoast.showToast(msg: "Something went wrong");
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
          (spouse__certificate != null && spouseCreditList.isEmpty)
              ? Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    alignment: Alignment.center,
                    height: spouse__certificate != null ? 150 : 0,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(spouse__certificate.length, (index) {
                          return CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: spouse__certificate[index] != null
                                ? spouse__certificate[index]
                                : 'http://via.placeholder.com/1x1',
//            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        })),
                  ),
                )
              : spouseCreditList.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.center,
                      height: 150,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(spouseCreditList.length, (index) {
                            return Center(
                              child: Image.file(
                                File(spouseCreditList[index]),
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
