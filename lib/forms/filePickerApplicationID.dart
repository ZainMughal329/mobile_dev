import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/utils/utils.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/global.dart';

class FileHolderApplicationID extends StatefulWidget {
  int applicant_id;
  String image_name;
  FileHolderApplicationID(this.applicant_id, this.image_name);
  @override
  _FileHolderApplicationIDState createState() =>
      _FileHolderApplicationIDState();
}

class _FileHolderApplicationIDState extends State<FileHolderApplicationID> {
  String? _extension;
  String? profileType;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  List<String> applicant_id_list = <String>[];

  var employment_status;
  var spouse_id;
  var dependent_ids;
  var applicant_id_proof;
  var proof_of_income;
  var account_statement;
  var saps_affidavit;
  var marriage_certificate;

  var attachmentOfId;
  ServicesRequest request = ServicesRequest();

  @override
  void initState() {
    super.initState();
    // getAttachment();
    print('id agye hai');
    _controller.addListener(() => _extension = _controller.text);
    checkInternetAvailability();
  }

  File? _image;
  final picker = ImagePicker();

  var applicant_id_proof_storage;
  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
      applicant_id_proof_storage =
          sharedPreferences.getString('applicant_id_proof');
    });
  }

  void _filePicker() async {
    await request.ifInternetAvailable();
    applicant_id_list = <String>[];
    // File file = await FilePicker.getFile(allowedExtensions: ['jpg','png'],  type: FileType.custom,);
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['jpg','png'],  type: FileType.custom,);
    // List<File> file = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: ['jpg']);
    setState(() {

      Navigator.pop(context, true);
//      _isLoadingSecondary = true;
    });
    if(result!=null)
      {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        setState(() {
          _isLoadingSecondary = true;
          print('state');
          print(_isLoadingSecondary);
        });
        for(var file in files)
          {
            try {
              if (_isLoadingSecondary == true) {
                print(widget.applicant_id);
              }

              Map<String, dynamic> data = {
                "application_id": widget.applicant_id,
                widget.image_name: await MultipartFile.fromFile(
                    file.path,
                    filename: 'applicantID.jpg')
              };
              FormData formData = new FormData.fromMap(data);
              applicant_id_list.add(file.path);

              Map<String, dynamic> map = {
                "application_id": widget.applicant_id,
                widget.image_name: file.path
              };
              LocalStorage.localStorage.saveFormData(map);

              print(formData.toString());

              if (MyConstants.myConst.internet??false) {
                showToastMessage('File Uploading Please wait');
                var dio = Dio(BaseOptions(
                    receiveDataWhenStatusError: true,
                    connectTimeout: Duration(minutes: 3), // 1 minutes
                    receiveTimeout: Duration(minutes: 3) // 1 minuntes
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
                print("Something Something");
                if (response.statusCode == 200) {
                  // jsonResponse = json.decode(response.data);
                  jsonResponse = response.data;
                  print('data');
                  print(
                      "spouse id after affidavit :::: ${jsonResponse['data']['spouse_id']}");

                  showToastMessage(jsonResponse['message']);
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
                  setState(() {
                    _isLoadingSecondary = false;
//            Navigator.pop(context, true);

                    applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
                    String fileName = applicant_id_proof.split('/').last;
                    print('filename');

                    if (fileName.contains('.png') ||
                        fileName.contains('.jpg') ||
                        fileName.contains('.jpeg') ||
                        fileName.contains('.gif')) {
                      print('wiii');
                      applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
                    } else {
                      applicant_id_proof =
                      'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
                    }
                    sharedPreferences.setString(
                        "applicant_id_proof", applicant_id_proof);

                    getAttachment();
                    print(applicant_id_proof);
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

    // if (file != null) {
      // print(file.paths.last);
      // File myFile = File(file.single.path);
      // Utils.createFile(myFile, "GalleryFile");
      // setState(() {
      //   _isLoadingSecondary = true;
      //   print('state');
      //   print(_isLoadingSecondary);
      // });

//       try {
//         if (_isLoadingSecondary == true) {
//           print(widget.applicant_id);
//         }
//
//         Map<String, dynamic> data = {
//           "application_id": widget.applicant_id,
//           widget.image_name: await MultipartFile.fromFile(
//               file.path,
//               filename: 'applicantID.jpg')
//         };
//         FormData formData = new FormData.fromMap(data);
//         applicant_id_list.add(file.path);
//
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           widget.image_name: file.path
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print(formData.toString());
//
//         if (MyConstants.myConst.internet??false) {
//           showToastMessage('File Uploading Please wait');
//           var dio = Dio(BaseOptions(
//               receiveDataWhenStatusError: true,
//               connectTimeout: Duration(minutes: 3), // 1 minutes
//               receiveTimeout: Duration(minutes: 3) // 1 minuntes
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
//           print("Something Something");
//           if (response.statusCode == 200) {
//             // jsonResponse = json.decode(response.data);
//             jsonResponse = response.data;
//             print('data');
//             print(
//                 "spouse id after affidavit :::: ${jsonResponse['data']['spouse_id']}");
//
//             showToastMessage(jsonResponse['message']);
// //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
//             setState(() {
//               _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
//
//               applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
//               String fileName = applicant_id_proof.split('/').last;
//               print('filename');
//
//               if (fileName.contains('.png') ||
//                   fileName.contains('.jpg') ||
//                   fileName.contains('.jpeg') ||
//                   fileName.contains('.gif')) {
//                 print('wiii');
//                 applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
//               } else {
//                 applicant_id_proof =
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
//               }
//               sharedPreferences.setString(
//                   "applicant_id_proof", applicant_id_proof);
//
//               getAttachment();
//               print(applicant_id_proof);
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

  void uploadImage() async {
    await request.ifInternetAvailable();
    applicant_id_list = <String>[];
    File? file;

    Navigator.pop(context, true);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
                  onFile: (onFile) {
                    print(onFile);
                    print(
                        "inside file picker application Id upload image function");
                    Navigator.pop(context);
                    file = onFile;
                  },
                  enableZoom: true,
                  resolutionPreset: ResolutionPreset.medium,
                  cameraSide: CameraSide.all,
                )));
    if (file != null) {
      print("Picture Captured has the path " + file!.path);
    }
    await Utils.createFile(file!, widget.image_name);

    if (file != null) {
      setState(() {
        _isLoadingSecondary = true;
        print('state');
        print(_isLoadingSecondary);
      });

      try {
        setState(() {
          _image = File(file!.path);
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }
        var filePath = file!.path;
        applicant_id_list.add(file!.path);

        Map<String, dynamic> data = {
          "application_id": widget.applicant_id,
          widget.image_name: await MultipartFile.fromFile(filePath,
              filename: 'applicantID.jpg')
        };
        FormData formData = new FormData.fromMap(data);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: file?.path
        };
        LocalStorage.localStorage.saveFormData(map);

        print(formData.toString());

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

          print("response sent");
          Response response = await dio.post(
            '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
            data: formData, // Post with Stream<List<int>>
            options: Options(
                headers: {'uuid': userID, 'Authentication': authToken},
                contentType: "*/*",
                responseType: ResponseType.json),
          );

          print('dataa');
          print("reponse data :::: ${response.data['data']}");
          var jsonResponse = response.data;
          // jsonResponse = json.decode(response.data);
          if (response.statusCode == 200) {
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));

            setState(() {
              _isLoadingSecondary = false;
              applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
              String fileName = applicant_id_proof.split('/').last;
              print("File name is $fileName");

              if (fileName.contains('.png') ||
                  fileName.contains('.jpg') ||
                  fileName.contains('.jpeg') ||
                  fileName.contains('.gif')) {
                print('wiii');
                applicant_id_proof = jsonResponse['data']['applicant_id_proof'];
              } else {
                applicant_id_proof =
                    'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
              }
              sharedPreferences.setString(
                  "applicant_id_proof", applicant_id_proof);
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
          _isLoadingSecondary = false;
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
                          : MyConstants.myConst.internet??false
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
                          MyConstants.myConst.internet??false ? 'Uploading' : "Saved",
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
          applicant_id_proof_storage != null
              ? Container(
                  height: applicant_id_proof_storage != null ? 150 : 0,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: applicant_id_proof_storage != null
                        ? applicant_id_proof_storage
                        : 'http://via.placeholder.com/1x1',
//            errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : applicant_id_list.isNotEmpty
                  ? Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.center,
                      height: 150,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(applicant_id_list.length, (index) {
                            return Center(
                              child: Image.file(
                                File(applicant_id_list[index]),
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
