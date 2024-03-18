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

class FileHolderAdditional extends StatefulWidget {
  int applicant_id;
  String image_name;

  FileHolderAdditional(this.applicant_id, this.image_name);

  @override
  _FileHolderAdditionalState createState() => _FileHolderAdditionalState();
}

class _FileHolderAdditionalState extends State<FileHolderAdditional> {
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
  // List<String> additional_file_id = List<String>();
  List<String> additional_file_id = [];
  ServicesRequest request = ServicesRequest();
  List<String> additional_file_List = <String>[];

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

  var additional_certificate;

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
      additional_certificate = sharedPreferences.getStringList('additional_file');
    });
  }

  void _filePicker() async {
    await request.ifInternetAvailable();
    additional_file_List = <String>[];
    print('hi');

    Navigator.pop(context, true);
    setState(() {
      _isLoadingSecondary = true;
    });
    // List<File> listFiles  = await FilePicker.getMultiFile();
    // List<File> listFiles = await FilePicker.getMultiFile(
    //     type: FileType.custom, allowedExtensions: ['jpg']);
    FilePickerResult? listFiles = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg']);
    final Map<String, dynamic> _formData = {};

    _formData['application_id'] = widget.applicant_id;
    if(listFiles!=null){
      List<File> files = listFiles.paths.map((path) => File(path!)).toList();
      var img = [];
      List<String> img_paths = <String>[];
      for (int j = 0; j < files.length; j++) {
        img.add(await MultipartFile.fromFile(files[j].path,
            filename: 'additionalFiles($j)'));
        img_paths.add(files[j].path);
        additional_file_List.add(files[j].path);
        print(_formData);
      }
      _formData['additional_file[]'] = img;
      print('idsss ++++++++');
      print(_formData['additional_file[]']);
      // checkInternetAvailability();
      _isLoadingSecondary = true;

      try {
        if (_isLoadingSecondary == true) {
          print(widget.applicant_id);
        }
        FormData formData = new FormData.fromMap(_formData);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'additional_file[]': jsonEncode(img_paths)
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
              var dependent_List = jsonResponse['data']['additional_file'];
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

                additional_file_id.add(newEntry);
              } else {
                additional_file_id.add(
                    'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
              }
              sharedPreferences.setStringList("additional_file", additional_file_id);

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
    //       filename: 'additionalFiles($j)'));
    //   img_paths.add(listFiles[j].path);
    //   additional_file_List.add(listFiles[j].path);
    //   print(_formData);
    // }

    // _formData['additional_file[]'] = img;
    // print('idsss ++++++++');
    // print(_formData['additional_file[]']);
    // // checkInternetAvailability();

    // if (listFiles != null) {
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
//           'additional_file[]': jsonEncode(img_paths)
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
//               var dependent_List = jsonResponse['data']['additional_file'];
//               String? fileName;
//               print('filename');
//               print(dependent_List);
//               var newEntry;
//               print('yaha aya');
//               for (int p = 0; p < dependent_List.length; p++) {
//                 print('filename');
//                 newEntry = dependent_List[p];
//                 fileName = dependent_List[p].split('/').last;
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
//                 additional_file_id.add(newEntry);
//               } else {
//                 additional_file_id.add(
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//               }
//               sharedPreferences.setStringList("additional_file", additional_file_id);
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
    additional_file_List = <String>[];
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
                print(file);
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
          'additional_file[]': await MultipartFile.fromFile(_image!.path,
              filename: 'household.jpg')
        });

        img_paths.add(_image!.path);
        additional_file_List.add(_image!.path);
        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'additional_file[]': jsonEncode(img_paths)
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
              var dependent_List = jsonResponse['data']['additional_file'];
              var newEntry;
              for (int p = 0; p < dependent_List.length; p++) {
                print('dependent_idsssss');

                newEntry = dependent_List[p];

//              global.occupantImages = dependent_idss;
//              print(additional_file_id);
              }
              additional_file_id.add(newEntry);
              sharedPreferences.setStringList("additional_file", additional_file_id);
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
          (additional_certificate != null && additional_file_List.isEmpty)
              ? Center(
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              alignment: Alignment.center,
              height: additional_certificate != null ? 150 : 0,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(additional_certificate.length, (index) {
                    return CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: additional_certificate[index] != null
                          ? additional_certificate[index]
                          : 'http://via.placeholder.com/1x1',
//            errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  })),
            ),
          )
              : additional_file_List.isNotEmpty
              ? Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            alignment: Alignment.center,
            height: 150,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children:
                List.generate(additional_file_List.length, (index) {
                  return Center(
                    child: Image.file(
                      File(additional_file_List[index]),
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
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lesedi/constans/constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lesedi/helpers/local_storage.dart';
// import 'package:lesedi/networkRequest/services_request.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera_camera/camera_camera.dart';
//
// import '../global.dart';
//
// class FileHolderAdditional extends StatefulWidget {
//   int applicant_id;
//   String image_name;
//   FileHolderAdditional(this.applicant_id, this.image_name);
//   @override
//   _FileHolderAdditionalState createState() => _FileHolderAdditionalState();
// }
//
// class _FileHolderAdditionalState extends State<FileHolderAdditional> {
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
//   List<String> additionalList = <String>[];
//
//   var employment_status;
//   var spouse_id;
//   var dependent_ids;
//   var applicant_id_proof;
//   var proof_of_income;
//   var account_statement;
//   var additional;
//
//   var attachmentOfId;
//   ServicesRequest request = ServicesRequest();
//
//   @override
//   void initState() {
//     super.initState();
//     print('id agye hai');
//     checkInternetAvailability();
//     // getAttachment();
// //    print(widget.custom_requirement_id);
//     _controller.addListener(() => _extension = _controller.text);
//   }
//
//   File _image;
//   final picker = ImagePicker();
//
//   var additionalStorage;
//   checkInternetAvailability() async {
//     await request.ifInternetAvailable();
//     setState(() {});
//   }
//
//   getAttachment() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //    role = sharedPreferences.getString('role');
//
//     setState(() {
//       additionalStorage = sharedPreferences.getString('saps_affidavit');
//     });
//   }
//
//   void _filePicker() async {
//     await request.ifInternetAvailable();
//     additionalList = <String>[];
//     print('hi');
//     // File file = await FilePicker.getFile();
//     List<File> file = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: ['jpg']);
//     print("Affidavit picked file :: ${file}");
//     setState(() {
//       print('true');
//       Navigator.pop(context, true);
//     });
//     if (file.length > 5)
//     {
//       Fluttertoast.showToast(msg: "Can not be select more than 5 images");
//       print("Could select more than 5 images");
//       return;
//     }
//     if (file != null) {
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
//         Map<String, dynamic> data = {
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           widget.image_name: await MultipartFile.fromFile(
//               file.single.path,
//               filename: 'additional.jpg')
//         };
//         FormData formData = new FormData.fromMap(data);
//
//         print("Additional ${file.single.path}");
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           widget.image_name: file.single.path
//         };
//         LocalStorage.localStorage.saveFormData(map);
//         additionalList.add(file.single.path);
//
//         print(formData.toString());
//
//         if (MyConstants.myConst.internet) {
//           showToastMessage('File Uploading Please wait');
//           var dio =
//           Dio(
//               BaseOptions(
//               receiveDataWhenStatusError: true,
//               connectTimeout: 60 * 1000, // 3 minutes
//               receiveTimeout: 60 * 1000 // 3 minuntes
//               )
//           );
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
// //            saps_affidavit = jsonResponse['data']['saps_affidavit'];
// //            sharedPreferences.setString("saps_affidavit", saps_affidavit);
//
//               additional = jsonResponse['data']['saps_affidavit']; //
//               String fileName = additional.split('/').last;
//               print('filename');
//
//               if (fileName.contains('.png') ||
//                   fileName.contains('.jpg') ||
//                   fileName.contains('.jpeg') ||
//                   fileName.contains('.gif')) {
//                 print('wiii');
//                 additional = jsonResponse['data']['saps_affidavit'];
//               } else {
//                 additional =
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png';
//               }
//               sharedPreferences.setString("additional", additional);
//
//               getAttachment();
//             });
//
//             showToastMessage('File Uploaded');
//           }
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Something went wrong");
//         setState(() {
//           _isLoading = false;
//           _isLoadingSecondary = false;
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
//     additionalList = <String>[];
//     await request.ifInternetAvailable();
// //    setState(() {
// //      _isLoadingSecondary = true;
// //
// //    });
//
//     Navigator.pop(context, true);
//     File file;
//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CameraCamera(
//                   onFile: (onFile) {
//                     print("inside file picker affidavit uploadImage function");
//                     print(onFile);
//                     file = onFile;
//                     Navigator.pop(context);
//                   },
//                   enableZoom: true,
//                   resolutionPreset: ResolutionPreset.medium,
//                   cameraSide: CameraSide.all,
//                 )
//             // Camera(
//             //       mode: CameraMode.normal,
//             //       imageMask: CameraFocus.rectangle(
//             //         color: Colors.black.withOpacity(0.5),
//             //       ),
//             //     )
//             ));
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
//
//         Map<String, dynamic> data = {
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           widget.image_name: await MultipartFile.fromFile(_image.path,
//               filename: 'additional.jpg')
//         };
//
//         additionalList.add(_image.path);
//         FormData formData = new FormData.fromMap(data);
//
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           widget.image_name: _image.path
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
//           var jsonResponse;
//           // jsonResponse = json.decode(response.data);
//           jsonResponse = response.data;
//           if (response.statusCode == 200) {
// //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
//
//             setState(() {
//               _isLoadingSecondary = false;
// //            Navigator.pop(context, true);
//
//               additional = jsonResponse['data']['saps_affidavit'];
//               sharedPreferences.setString("additional", additional);
//               getAttachment();
//             });
//
//             showToastMessage('File Uploaded');
//           }
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Something went wrong");
//         setState(() {
//           _isLoading = false;
//           _isLoadingSecondary = false;
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
//                   title: new Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Upload File"),
//                       InkWell(
//                           onTap: () => Navigator.pop(context, true),
//                           child: Icon(Icons.clear))
//                     ],
//                   ),
//                   content: SingleChildScrollView(
//                       child: Container(
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
//                 ));
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
//                               Icons.file_upload,
//                               color: Colors.black,
//                               size: 20,
//                             )
//                           : MyConstants.myConst.internet
//                               ? Container(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : Icon(
//                                   Icons.done,
//                                   color: Colors.black,
//                                   size: 20,
//                                 )),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   !_isLoadingSecondary
//                       ? Text(
//                           'Upload',
//                           style: TextStyle(
//                               color: Colors.black,
//                               letterSpacing: 0.2,
//                               fontFamily: "Open Sans",
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w800),
//                         )
//                       : Text(
//                           MyConstants.myConst.internet ? 'Uploading' : "Saved",
//                           style: TextStyle(
//                               color: Colors.black,
//                               letterSpacing: 0.2,
//                               fontFamily: "Open Sans",
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w800),
//                         ),
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
//           additional != null
//               ? Container(
//                   height: additionalStorage != null ? 150 : 0,
//                   child: CachedNetworkImage(
//                     placeholder: (context, url) => CircularProgressIndicator(),
//                     imageUrl: additionalStorage != null
//                         ? additionalStorage
//                         : 'http://via.placeholder.com/1x1',
// //            errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 )
//               : additionalList.isNotEmpty
//                   ? Container(
//                     padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                       alignment: Alignment.center,
//                       height: 150,
//                       child: ListView(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           children: List.generate(additionalList.length,
//                               (index) {
//                             return Center(
//                               child: Image.file(
//                                 File(additionalList[index]),
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           })),
//                     )
//                   : SizedBox(),
//         ],
//       ),
//     );
//   }
// }
