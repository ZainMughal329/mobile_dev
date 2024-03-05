import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';

import '../global.dart';

class FileHolder extends StatefulWidget {
  int applicant_id;
  String image_name;
  FileHolder(this.applicant_id, this.image_name);
  @override
  _FileHolderState createState() => _FileHolderState();
}

class _FileHolderState extends State<FileHolder> {
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
    print('id agye hai');
//    print(widget.custom_requirement_id);
    _controller.addListener(() => _extension = _controller.text);
  }

  File? _image;
  final picker = ImagePicker();

  var dependant_ids_storage;
  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
      dependant_ids_storage = sharedPreferences.getString('dependent_ids');
    });
  }

  void _filePicker() async {
    print('hi');
    // File file = await FilePicker.getFile();
    // List<File> file = await FilePicker.getMultiFile();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      print('true');
      Navigator.pop(context, true);
//      _isLoadingSecondary = true;
    });
//    print(file);
//    if (!mounted) return;
//    setState(() {
////      _fileHolder =  file;
//    });
if(result!=null)
  {
    List<File> files = result.paths.map((path) => File(path!)).toList();

  setState(() {
      _isLoadingSecondary = true;
      print('state');
      print(_isLoadingSecondary);
    });

    for (var file in files) {

      try {
        showToastMessage('File Uploading Please wait');
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }

        Map<String, dynamic> data = {
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          widget.image_name:
          await MultipartFile.fromFile(file.path)
        };

        FormData formData = new FormData.fromMap(data);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: file.path
        };
        LocalStorage.localStorage.saveFormData(map);

        print(formData.toString());

        var dio = Dio(BaseOptions(
          connectTimeout: Duration(minutes: 3),
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
            headers: {
              HttpHeaders.userAgentHeader: "dio",
              HttpHeaders.contentTypeHeader: ContentType.text,
              'uuid': userID,
              'Authentication': authToken
            },
            contentType: 'image/png',
            responseType: ResponseType.plain,
          ),
        );
        if (response.statusCode == 200) {
          jsonResponse = json.decode(response.data);
          print('data');

          showToastMessage(jsonResponse['message']);
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
          setState(() {
            _isLoadingSecondary = false;
//            Navigator.pop(context, true);
//            saps_affidavit = jsonResponse['data']['saps_affidavit'];
//            sharedPreferences.setString("saps_affidavit", saps_affidavit);

            dependent_ids = jsonResponse['data']['dependent_ids'];
            String fileName = dependent_ids.split('/').last;
            print('filename');

            if (fileName.contains('.png') ||
                fileName.contains('.jpg') ||
                fileName.contains('.jpeg') ||
                fileName.contains('.gif')) {
              print('wiii');
              dependent_ids = jsonResponse['data']['dependent_ids'];
            } else {
              saps_affidavit =
              'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
            sharedPreferences.setString("dependent_ids", dependent_ids);

            getAttachment();
          });
          showToastMessage('File Uploaded');
        }
      } catch (e) {
        print('dsa');
        print(e);
      }

    }

  }
//     if (file != null) {
//       setState(() {
//         _isLoadingSecondary = true;
//         print('state');
//         print(_isLoadingSecondary);
//       });
//
//       try {
//         showToastMessage('File Uploading Please wait');
//         if (_isLoadingSecondary == true) {
// //          showToastMessage('Image Uploading Please wait');
//           print(widget.applicant_id);
//         }
//
//         Map<String, dynamic> data = {
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           widget.image_name:
//               await MultipartFile.fromFile(file.single.path)
//         };
//
//         FormData formData = new FormData.fromMap(data);
//
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           widget.image_name: file.single.path
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print(formData.toString());
//
//         var dio = Dio(BaseOptions(
//           connectTimeout: Duration(minutes: 3),
//         ));
//         dio.interceptors.add(LogInterceptor(responseBody: true));
//         SharedPreferences sharedPreferences =
//             await SharedPreferences.getInstance();
//         var userID = sharedPreferences.getString('userID');
//         var authToken = sharedPreferences.getString('auth-token');
//         var jsonResponse;
//         Response response = await dio.post(
//           '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
//           data: formData, // Post with Stream<List<int>>
//           options: Options(
//             headers: {
//               HttpHeaders.userAgentHeader: "dio",
//               HttpHeaders.contentTypeHeader: ContentType.text,
//               'uuid': userID,
//               'Authentication': authToken
//             },
//             contentType: 'image/png',
//             responseType: ResponseType.plain,
//           ),
//         );
//         if (response.statusCode == 200) {
//           jsonResponse = json.decode(response.data);
//           print('data');
//
//           showToastMessage(jsonResponse['message']);
// //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
//           setState(() {
//             _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
// //            saps_affidavit = jsonResponse['data']['saps_affidavit'];
// //            sharedPreferences.setString("saps_affidavit", saps_affidavit);
//
//             dependent_ids = jsonResponse['data']['dependent_ids'];
//             String fileName = dependent_ids.split('/').last;
//             print('filename');
//
//             if (fileName.contains('.png') ||
//                 fileName.contains('.jpg') ||
//                 fileName.contains('.jpeg') ||
//                 fileName.contains('.gif')) {
//               print('wiii');
//               dependent_ids = jsonResponse['data']['dependent_ids'];
//             } else {
//               saps_affidavit =
//                   'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
//             }
//             sharedPreferences.setString("dependent_ids", dependent_ids);
//
//             getAttachment();
//           });
//           showToastMessage('File Uploaded');
//         }
//       } catch (e) {
//         print('dsa');
//         print(e);
//       }
//     }
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

    Navigator.pop(context, true);
    File? file;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
                  onFile: (onFile) {
                    print("inside file picker uploadImage function");
                    print(onFile);
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

    if (file != null) {
      setState(() {
        _isLoadingSecondary = true;
        print('state');
        print(_isLoadingSecondary);
      });

      showToastMessage('File Uploading Please wait');
      try {
        setState(() {
          _image = File(file!.path);
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }

        Map<String, dynamic> data = {
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          widget.image_name: await MultipartFile.fromFile(_image?.path??"")
        };

        FormData formData = new FormData.fromMap(data);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: _image?.path
        };
        LocalStorage.localStorage.saveFormData(map);
        // LocalStorage.localStorage.saveFormData(data);

        print(formData.toString());

        var dio = Dio(BaseOptions(
          connectTimeout: Duration(minutes: 3),
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
            headers: {
              HttpHeaders.userAgentHeader: "dio",
              HttpHeaders.contentTypeHeader: ContentType.text,
              'uuid': userID,
              'Authentication': authToken
            },
            contentType: 'image/png',
            responseType: ResponseType.plain,
          ),
        );
        var jsonResponse;
        jsonResponse = json.decode(response.data);
        if (response.statusCode == 200) {
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
          setState(() {
            _isLoadingSecondary = false;
//            Navigator.pop(context, true);
//            saps_affidavit = jsonResponse['data']['saps_affidavit'];
//            sharedPreferences.setString("saps_affidavit", saps_affidavit);

            dependent_ids = jsonResponse['data']['dependent_ids'];
            String fileName = dependent_ids.split('/').last;
            print('filename');

            if (fileName.contains('.png') ||
                fileName.contains('.jpg') ||
                fileName.contains('.jpeg') ||
                fileName.contains('.gif')) {
              print('wiii');
              dependent_ids = jsonResponse['data']['dependent_ids'];
            } else {
              dependent_ids =
                  'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
            }
            sharedPreferences.setString("dependent_ids", dependent_ids);

            getAttachment();
          });
          showToastMessage('File Uploaded');
        }
      } catch (e) {
        print('dsa');
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       _filePicker();

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
                          : Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
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
                          'uploading',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              child: Image.network(
                attachmentOfId != null ? attachmentOfId : '',
                width: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
