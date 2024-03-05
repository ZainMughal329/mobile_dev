import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';

import '../global.dart';

class FileHolderAccountStatement extends StatefulWidget {
  int applicant_id;
  String image_name;
  FileHolderAccountStatement(this.applicant_id, this.image_name);
  @override
  _FileHolderAccountStatementState createState() =>
      _FileHolderAccountStatementState();
}

class _FileHolderAccountStatementState
    extends State<FileHolderAccountStatement> {
  String? _fileName;
  String? _path;
  Map<String, String>?_paths;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType? _pickingType;
  String? profileType;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  ServicesRequest request = ServicesRequest();
  List<String> account_statement_list = <String>[];

  var employment_status;
  var spouse_id;
  var dependent_ids;
  var applicant_id_proof;
  var proof_of_income;
  var account_statement;
  var saps_affidavit;
  var attachmentOfId;

  @override
  void initState() {
    super.initState();
    // getAttachment();
    print('id agye hai');
//    print(widget.custom_requirement_id);
    checkInternetAvailability();
    _controller.addListener(() => _extension = _controller.text);
  }

  File? _image;
  final picker = ImagePicker();

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  var account_statement_storage;
  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
      account_statement_storage =
          sharedPreferences.getString('account_statement');
    });
  }

  void _filePicker() async {
    print('hi');
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['jpg','png'],  type: FileType.custom,);
    // List<File> file = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: ['jpg']);
    setState(() {
      print('true');
      Navigator.pop(context, true);
    });
    await request.ifInternetAvailable();
    account_statement_list = <String>[];

    // if (file != null) {
    if (result != null) {
      setState(() {
        _isLoadingSecondary = true;
        print('state');
        print(_isLoadingSecondary);
      });

      try {
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }

        ///---------******** new implementation ***************-------///////
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var file in files) {
          FormData formData = new FormData.fromMap({
            "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
            widget.image_name: await MultipartFile.fromFile(
                file.path,
                filename: 'accountStatement.jpg')
          });
          account_statement_list.add(file.path);
          print("Account Statement file ::: ${file.path}");
          Map<String, dynamic> map = {
            "application_id": widget.applicant_id,
            widget.image_name: file.path
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
            var jsonResponse;
            Response response = await dio.post(
              '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
              data: formData, // Post with Stream<List<int>>
              options: Options(
                  headers: {'uuid': userID, 'Authentication': authToken},
                  contentType: "*/*",
                  responseType: ResponseType.json),
            );
            if (response.statusCode == 200) {
              // jsonResponse = json.decode(response.data);
              jsonResponse = response.data;
              print('data');
              print(jsonResponse['data']['spouse_id']);

              showToastMessage(jsonResponse['message']);
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
              setState(() {
                _isLoadingSecondary = false;
//            Navigator.pop(context, true);

                account_statement = jsonResponse['data']['account_statement'];
                String fileName = account_statement.split('/').last;
                print('filename');

                if (fileName.contains('.png') ||
                    fileName.contains('.jpg') ||
                    fileName.contains('.jpeg') ||
                    fileName.contains('.gif')) {
                  print('wiii');
                  account_statement = jsonResponse['data']['account_statement'];
                } else {
                  account_statement =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
                }
                sharedPreferences.setString(
                    "account_statement", account_statement);

                getAttachment();
                print("reached else :::::");
              });

              showToastMessage('File Uploaded');
            }
          } else {
            setState(() {});
          }
        }

        ///---------******** new implementation ***************-------///////



//         FormData formData = new FormData.fromMap({
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           widget.image_name: await MultipartFile.fromFile(
//               file.path,
//               filename: 'accountStatement.jpg')
//         });
//
//         account_statement_list.add(file.path);
//         print("Account Statement file ::: ${file.path}");
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           widget.image_name: file.path
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print(formData.toString());
//
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
//           var jsonResponse;
//           Response response = await dio.post(
//             '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
//             data: formData, // Post with Stream<List<int>>
//             options: Options(
//                 headers: {'uuid': userID, 'Authentication': authToken},
//                 contentType: "*/*",
//                 responseType: ResponseType.json),
//           );
//           if (response.statusCode == 200) {
//             // jsonResponse = json.decode(response.data);
//             jsonResponse = response.data;
//             print('data');
//             print(jsonResponse['data']['spouse_id']);
//
//             showToastMessage(jsonResponse['message']);
// //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
//             setState(() {
//               _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
//
//               account_statement = jsonResponse['data']['account_statement'];
//               String fileName = account_statement.split('/').last;
//               print('filename');
//
//               if (fileName.contains('.png') ||
//                   fileName.contains('.jpg') ||
//                   fileName.contains('.jpeg') ||
//                   fileName.contains('.gif')) {
//                 print('wiii');
//                 account_statement = jsonResponse['data']['account_statement'];
//               } else {
//                 account_statement =
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
//               }
//               sharedPreferences.setString(
//                   "account_statement", account_statement);
//
//               getAttachment();
//               print("reached else :::::");
//             });
//
//             showToastMessage('File Uploaded');
//           }
//         } else {
//           setState(() {});
//         }
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
        setState(() {
          _isLoading = false;
          _isLoadingSecondary = false;
        });
        print('dsa');
        print(e);
      }
    }
  }

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? auth_token = sharedPreferences.getString('token');
  }

  void uploadImage() async {
//    setState(() {
//      _isLoadingSecondary = true;
//
//    });
    account_statement_list = <String>[];
    Navigator.pop(context, true);
    File? file;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
                  onFile: (onFile) {
                    print(onFile);
                    print("inside file picker account Statement");
                    file = onFile;
                    Navigator.pop(context);
                  },
                  enableZoom: true,
                  resolutionPreset: ResolutionPreset.medium,
                  cameraSide: CameraSide.all,
                )
            // Camera(
            //       mode: CameraMode.normal,
            //       imageMask: CameraFocus.rectangle(
            //         color: Colors.black.withOpacity(0.5),
            //       ),
            //     )
            ));
    print(file?.path);
    print(file);
    await request.ifInternetAvailable();
    if (file != null) {
      setState(() {
        _isLoadingSecondary = true;
        print('state');
        print(_isLoadingSecondary);
      });

      try {
        setState(() {
          _image = File(file?.path??"");
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }
        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          widget.image_name: await MultipartFile.fromFile(_image?.path??"",
              filename: 'accountStatement.jpg')
        });
        account_statement_list.add(_image?.path??"");

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: _image?.path??""
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
          // var jsonResponse;
          // jsonResponse = json.decode(response.data);
          var jsonResponse = response.data;
          if (response.statusCode == 200) {
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));

            setState(() {
              _isLoadingSecondary = false;
//            Navigator.pop(context, true);
              account_statement = jsonResponse['data']['account_statement'];
              sharedPreferences.setString(
                  "account_statement", account_statement);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  )),
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
                          MyConstants.myConst.internet ?? false ? 'Uploading' : "Saved",
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
          account_statement_storage != null
              ? Container(
                  height: account_statement_storage != null ? 150 : 0,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: account_statement_storage != null
                        ? account_statement_storage
                        : 'http://via.placeholder.com/1x1',
//            height: 250,
//            errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : account_statement_list.isNotEmpty
                  ? Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.center,
                      height: 150,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(account_statement_list.length,
                              (index) {
                            return Center(
                              child: Image.file(
                                File(account_statement_list[index]),
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
