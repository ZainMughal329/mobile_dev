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

class MarriageCertificate extends StatefulWidget {
  int applicant_id;
  String image_name;
  MarriageCertificate(this.applicant_id, this.image_name);
  @override
  _MarriageCertificateState createState() => _MarriageCertificateState();
}

class _MarriageCertificateState extends State<MarriageCertificate> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  String profileType;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  List<String> marriage_id_list = <String>[];

  var employment_status;
  var marriage_id;
  var dependent_ids;
  var applicant_id_proof;
  var proof_of_income;
  var account_statement;
  var saps_affidavit;

  var attachmentOfId;
  ServicesRequest request = ServicesRequest();

  @override
  void initState() {
    super.initState();
    // getAttachment();
    print('id agye hai');
    checkInternetAvailability();
    _controller.addListener(() => _extension = _controller.text);
  }

  File _image;
  final picker = ImagePicker();

  var marriage_id_storage;
  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    role = sharedPreferences.getString('role');

    setState(() {
      marriage_id_storage = sharedPreferences.getString('marriage_certificate');
    });
  }

  void _filePicker() async {
    await request.ifInternetAvailable();
    marriage_id_list = <String>[];
    print('hi');
    // File file = await FilePicker.getFile();
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['jpg']);
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

    if (file != null) {
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
        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
          'marriage_certificate': await MultipartFile.fromFile(
              file.path,
              filename: "MarriageCertificate.jpg")
        });
        marriage_id_list.add(file.path);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: file.path
        };
        LocalStorage.localStorage.saveFormData(map);

        print(formData.toString());

        if (MyConstants.myConst.internet) {
          showToastMessage('File Uploading Please wait');
          var dio = Dio(BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: 60 * 1000, // 3 minutes
              receiveTimeout: 60 * 1000 // 3 minuntes
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
            print(jsonResponse['data']['marriage_certificate']);

            showToastMessage(jsonResponse['message']);
//          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
            setState(() {
              _isLoadingSecondary = false;
//            Navigator.pop(context, true);

              marriage_id = jsonResponse['data']['marriage_certificate'];
              String fileName = marriage_id.split('/').last;
              print('filename');

              if (fileName.contains('.png') ||
                  fileName.contains('.jpg') ||
                  fileName.contains('.jpeg') ||
                  fileName.contains('.gif')) {
                print('wiii');
                marriage_id = jsonResponse['data']['marriage_certificate'];
              } else {
                marriage_id =
                'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
              }
              sharedPreferences.setString("marriage_certificate", marriage_id);

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

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String auth_token = sharedPreferences.get('token');
  }

  void uploadImage() async {
//    setState(() {
//      _isLoadingSecondary = true;
//
//    });
    marriage_id_list = <String>[];

    Navigator.pop(context, true);
    File file;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
              onFile: (onFile) {
                print("inside filePicker spouse id uploadImage function");
                print(onFile);
                file = onFile;
                Navigator.pop(context);
              },
              enableZoom: true,
              resolutionPreset: ResolutionPreset.medium,
              cameraSide: CameraSide.all,
            )));

    if (file != null) {
      setState(() {
        _isLoadingSecondary = true;
        print('state');
        print(_isLoadingSecondary);
      });

      try {
        setState(() {
          _image = File(file.path);
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }
        await request.ifInternetAvailable();
        var filePath = file.path;
        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          widget.image_name: await MultipartFile.fromFile(_image.path,
              filename: "MarriageCertificate.jpg")
        });
        marriage_id_list.add(_image.path);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          widget.image_name: _image.path
        };
        LocalStorage.localStorage.saveFormData(map);

        print(formData.toString());

        if (MyConstants.myConst.internet) {
          showToastMessage('File Uploading Please wait');
          var dio = Dio(BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: 60 * 1000, // 3 minutes
              receiveTimeout: 60 * 1000 // 3 minuntes
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
          var jsonResponse;
          jsonResponse = response.data;
          if (response.statusCode == 200) {
            setState(() {
              _isLoadingSecondary = false;
              marriage_id = jsonResponse['data']['marriage_certificate'];
              sharedPreferences.setString("marriage_certificate", marriage_id);
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
                          : MyConstants.myConst.internet
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
                    MyConstants.myConst.internet ? 'Uploading' : "Saved",
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
            ),
          ),
          marriage_id_storage != null
              ? Container(
            height: marriage_id_storage != null ? 150 : 0,
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: marriage_id_storage != null
                  ? marriage_id_storage
                  : 'http://via.placeholder.com/1x1',
//            height: 150,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )
              : marriage_id_list.isNotEmpty
              ? Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            alignment: Alignment.center,
            height: 150,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children:
                List.generate(marriage_id_list.length, (index) {
                  return Center(
                    child: Image.file(
                      File(marriage_id_list[index]),
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



// import 'dart:convert';
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lesedi/constans/Constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lesedi/helpers/local_storage.dart';
// import 'package:lesedi/networkRequest/services_request.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera_camera/camera_camera.dart';
// import '../global.dart';
//
// class FileHolderMarriageCertificate extends StatefulWidget {
//   int applicant_id;
//   String image_name;
//   FileHolderMarriageCertificate(this.applicant_id, this.image_name);
//   @override
//   _FileHolderMarriageCertificateState createState() => _FileHolderMarriageCertificateState();
// }
//
// class _FileHolderMarriageCertificateState extends State<FileHolderMarriageCertificate> {
//   String _fileName;
//   String _path;
//   Map<String, String> _paths;
//   String _extension;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   bool _hasValidMime = false;
//   FileType _pickingType;
//   String profileType;
//   TextEditingController _controller = new TextEditingController();
//   bool _isLoadingSecondary = false;
//   bool _isLoading = false;
//   List<String> marriage_certificate_list = <String>[];
//
//   var employment_status;
//   var marriage_id;
//   var dependent_ids;
//   var applicant_id_proof;
//   var proof_of_income;
//   var account_statement;
//   var saps_affidavit;
//
//   var attachmentOfId;
//   ServicesRequest request = ServicesRequest();
//
//   @override
//   void initState() {
//     super.initState();
//     print('id agye hai');
//     // getAttachment();
//     _controller.addListener(() => _extension = _controller.text);
//     checkInternetAvailability();
//   }
//
//   List<String> marriageID = List<String>();
//   File _image;
//   final picker = ImagePicker();
//   var marriageCertificate;
//
//   checkInternetAvailability() async {
//     await request.ifInternetAvailable();
//     setState(() {});
//   }
//
//   getAttachment() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//     setState(() {
//       marriageCertificate =
//           sharedPreferences.getStringList('marriage_certificate');
//     });
//   }
//
//   void _filePicker() async {
//     print('hi');
//     marriage_certificate_list = <String>[];
//     await request.ifInternetAvailable();
//
//     Navigator.pop(context, true);
//     setState(() {
//       _isLoadingSecondary = true;
//     });
//     // List<File> listFiles = await FilePicker.getMultiFile();
//     List<File> listFiles = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: ['jpg']);
//     final Map<String, dynamic> _formData = {};
//
//     _formData['application_id'] = widget.applicant_id;
//     var img = [];
//     List<String> img_paths = <String>[];
//     for (int j = 0; j < listFiles.length; j++) {
//       print('files');
//
//       print(listFiles[j]);
//       img.add(await MultipartFile.fromFile(listFiles[j].path,
//           filename: 'MarriageCertificate($j).jpg'));
//       img_paths.add(listFiles[j].path);
//       marriage_certificate_list.add(listFiles[j].path);
//
//       print('_formData');
//       print(_formData);
//     }
//     print(img);
//     _formData['marriage_certificate[]'] = img; //
//     if (listFiles != null) {
//       setState(() {
//         _isLoadingSecondary = true;
//         print('state');
//         print(_isLoadingSecondary);
//       });
//
//       try {
//         if (_isLoadingSecondary == true) {
// //          showToastMessage('Image Uploading Please wait');
//           print(widget.applicant_id);
//         }
//
//         FormData formData = new FormData.fromMap(_formData);
//
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           'marriage_certificate[]': jsonEncode(img_paths) //
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print('daataaaa');
// //
//         print(formData);
//
//         if (MyConstants.myConst.internet) {
//           showToastMessage('File Uploading Please wait');
//           var dio = Dio(BaseOptions(
//               receiveDataWhenStatusError: true,
//               connectTimeout: 60 * 1000, // 3 minutes
//               receiveTimeout: 60 * 1000 // 3 minuntes
//           ));
//           dio.interceptors.add(LogInterceptor(responseBody: true));
//           SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();
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
//             jsonResponse = response.data;
//             // jsonResponse = json.decode(response.data);
//             print('data');
//             print(jsonResponse['data']['marriage_id']);
//
//             showToastMessage(jsonResponse['message']);
//             var marriageList = jsonResponse['data']['marriage_certificate']; //
//             print('marriage certificate');
//             print(marriageList);
//
//             setState(() {
//               print(marriageList);
//               for (int p = 0; p < marriageList.length; p++) {
//                 print('marriage_idsssss');
//                 print(marriageList[p]);
//                 print(marriageID);
//
//                 String fileName = marriageList[p].split('/').last;
//                 print('filename');
// //              print( jsonResponse['data']['content_type'][0].toString() );
// //              if (jsonResponse['data']['content_type'][0].toString() == 'image/jpeg' || jsonResponse['data']['content_type'][0].toString() == 'image/jpg'
// //                  || jsonResponse['data']['content_type'][0].toString() == 'image/png' || jsonResponse['data']['content_type'][0].toString() == 'image/gif'
// //              ){
// //                print('wiii');
// //                dependent_idss.add(dependent_List[p]);
// //
// //
// //              }
//
//                 if (fileName.contains('.png') ||
//                     fileName.contains('.jpg') ||
//                     fileName.contains('.jpeg') ||
//                     fileName.contains('.gif')) {
//                   print('wiii');
//                   marriageID.add(marriageList[p]);
//                 } else {
//                   marriageID.add(
//                       'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//                 }
//               }
//               sharedPreferences.setStringList(
//                   "marriage_certificate", marriageID); //
//
//               _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
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
//   }
//
//   void updateProfileWithResume() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String auth_token = sharedPreferences.get('token');
//   }
//
//   void uploadImage() async {
//     await request.ifInternetAvailable();
//     marriage_certificate_list = <String>[];
//
//     List<String> images_path = <String>[];
//
//     Navigator.pop(context, true);
//     File file;
//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CameraCamera(
//               onFile: (onFile) {
//                 print(
//                     "Inside Marriage Certificate");
//                 print(onFile);
//                 file = onFile;
//                 Navigator.pop(context);
//               },
//               enableZoom: true,
//               resolutionPreset: ResolutionPreset.medium,
//               cameraSide: CameraSide.all,
//             )));
//     print(file.path);
//     print(file);
//
//     if (file != null) {
//       setState(() {
//         _isLoadingSecondary = true;
//         print('state');
//         print(_isLoadingSecondary);
//       });
//
//       try {
//         setState(() {
//           _image = File(file.path);
//         });
//         if (_isLoadingSecondary == true) {
// //          showToastMessage('Image Uploading Please wait');
//           print(widget.applicant_id);
//         }
//         FormData formData = new FormData.fromMap({
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           'marriage_certificate[]': await MultipartFile.fromFile(file.path, //
//               filename: 'MarriageCertificate.jpg')
//         });
//
//         marriage_certificate_list.add(file.path);
//
//         images_path.add(_image.path);
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           'marriage_certificate[]': jsonEncode(images_path) //
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print(formData.toString());
//
//         if (MyConstants.myConst.internet) {
//           showToastMessage('File Uploading Please wait');
//           var dio = Dio(BaseOptions(
//               receiveDataWhenStatusError: true,
//               connectTimeout: 60 * 1000, // 3 minutes
//               receiveTimeout: 60 * 1000 // 3 minuntes
//           ));
//           dio.interceptors.add(LogInterceptor(responseBody: true));
//           SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();
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
//           // var jsonResponse;
//           var jsonResponse = response.data;
//           // jsonResponse = json.decode(response.data);
//           if (response.statusCode == 200) {
//             setState(() {
//               _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
// //            proof_of_income = jsonResponse['data']['proof_of_income'];
// //            sharedPreferences.setString("proof_of_income", proof_of_income);
//
//               var marriageList = jsonResponse['data']['marriage_certificate']; //
//               for (int p = 0; p < marriageList.length; p++) {
//                 print('dependent_id');
//                 marriageID.add(marriageList[p]);
// //              global.occupantImages = dependent_idss;
//                 print(marriageID);
//               }
//               sharedPreferences.setStringList(
//                   "marriage_certificate", marriageID);
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
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
// //        _filePicker();
//
//         showDialog(
//             context: context,
//             builder: (_) => new AlertDialog(
//               title: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Upload File"),
//                   InkWell(
//                       onTap: () => Navigator.pop(context, true),
//                       child: Icon(Icons.clear))
//                 ],
//               ),
//               content: SingleChildScrollView(
//                   child: Container(
//                     child: new Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Divider(),
//                         InkWell(
//                           onTap: () {
//                             _filePicker();
//                           },
//                           child: Container(
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: 20, right: 30, bottom: 0, top: 20),
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 15),
//                                 height: 55.0,
//                                 width: 600.0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Icon(
//                                           Icons.image,
//                                           color: Colors.black,
//                                           size: 20,
//                                         )),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       'Chosse From Gallery',
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           letterSpacing: 0.2,
//                                           fontFamily: "Open Sans",
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ],
//                                 ),
//                                 alignment: FractionalOffset.center,
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: Colors.black38,
//                                           blurRadius: 0.0)
//                                     ],
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     gradient: LinearGradient(colors: <Color>[
//                                       Color(0xFFFFFFFF),
//                                       Color(0xFFFFFFFF)
//                                     ])),
// //                          decoration: BoxDecoration(
// //                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
// //                              borderRadius: BorderRadius.circular(10.0),
// //                              gradient: LinearGradient(
// //                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
//                               ),
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             uploadImage();
//                           },
//                           child: Container(
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: 20, right: 30, bottom: 0, top: 0),
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 15),
//                                 height: 55.0,
// //                        width: 600.0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Icon(
//                                           Icons.camera_enhance,
//                                           color: Colors.black,
//                                           size: 20,
//                                         )),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       'Chosse From Camera',
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           letterSpacing: 0.2,
//                                           fontFamily: "Open Sans",
//                                           fontSize: 14.0,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ],
//                                 ),
//                                 alignment: FractionalOffset.center,
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: Colors.black38,
//                                           blurRadius: 0.0)
//                                     ],
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     gradient: LinearGradient(colors: <Color>[
//                                       Color(0xFFFFFFFF),
//                                       Color(0xFFFFFFFF)
//                                     ])),
// //                          decoration: BoxDecoration(
// //                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
// //                              borderRadius: BorderRadius.circular(10.0),
// //                              gradient: LinearGradient(
// //                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         )
//                       ],
//                     ),
//                   )),
//             ));
//       },
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 0),
//             child: Container(
//               margin: EdgeInsets.only(bottom: 15),
//               height: 55.0,
// //                        width: 600.0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Align(
//                       alignment: Alignment.centerRight,
//                       child: !_isLoadingSecondary
//                           ? Icon(
//                         Icons.file_upload,
//                         color: Colors.black,
//                         size: 20,
//                       )
//                           : MyConstants.myConst.internet
//                           ? Container(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(),
//                       )
//                           : Icon(
//                         Icons.done,
//                         color: Colors.black,
//                         size: 20,
//                       )),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   !_isLoadingSecondary
//                       ? Text(
//                     'Upload',
//                     style: TextStyle(
//                         color: Colors.black,
//                         letterSpacing: 0.2,
//                         fontFamily: "Open Sans",
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w800),
//                   )
//                       : Text(
//                     MyConstants.myConst.internet ? 'Uploading' : "Saved",
//                     style: TextStyle(
//                         color: Colors.black,
//                         letterSpacing: 0.2,
//                         fontFamily: "Open Sans",
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w800),
//                   ),
//                 ],
//               ),
//               alignment: FractionalOffset.center,
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(color: Colors.black38, blurRadius: 0.0)
//                   ],
//                   borderRadius: BorderRadius.circular(10.0),
//                   gradient: LinearGradient(
//                       colors: <Color>[Color(0xFFFFFFFF), Color(0xFFFFFFFF)])),
// //                          decoration: BoxDecoration(
// //                              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
// //                              borderRadius: BorderRadius.circular(10.0),
// //                              gradient: LinearGradient(
// //                                  colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
//             ),
//           ),
//           marriageCertificate != null
//               ? Center(
//             child: Container(
//               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//               height: marriageCertificate != null ? 150 : 0,
//               child: ListView(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   children: List.generate(marriageCertificate.length,
//                           (index) {
//                         return CachedNetworkImage(
//                           placeholder: (context, url) =>
//                               CircularProgressIndicator(),
//                           imageUrl: marriageCertificate[index] != null
//                               ? marriageCertificate[index]
//                               : 'http://via.placeholder.com/1x1',
// //            errorWidget: (context, url, error) => Icon(Icons.error),
//                         );
//                       })),
//             ),
//           )
//               : marriage_certificate_list.isNotEmpty
//               ? Container(
//             padding: EdgeInsets.only(left: 15.0, right: 15.0),
//             alignment: Alignment.center,
//             height: 150,
//             child: ListView(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 children: List.generate(
//                     marriage_certificate_list.length, (index) {
//                   return Center(
//                     child: Image.file(
//                       File(marriage_certificate_list[index]),
//                       width: 100,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 })),
//           )
//               : SizedBox(),
//         ],
//       ),
//     );
//   }
// }
