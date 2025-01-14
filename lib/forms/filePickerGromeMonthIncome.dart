import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';

import '../utils/global.dart';

class FileHolderGrossMonth extends StatefulWidget {
  int applicant_id;
  String image_name;

  FileHolderGrossMonth(this.applicant_id, this.image_name);

  @override
  _FileHolderGrossMonthState createState() => _FileHolderGrossMonthState();
}

class _FileHolderGrossMonthState extends State<FileHolderGrossMonth> {
  String? _extension;
  TextEditingController _controller = new TextEditingController();
  bool _isLoadingSecondary = false;
  bool _isLoading = false;
  List<String> gross_monthly_income_list = <String>[];

  var attachmentOfId;
  ServicesRequest request = ServicesRequest();

  @override
  void initState() {
    super.initState();
    print('id agye hai');
    print("Init State");
    // getAttachment();
    _controller.addListener(() => _extension = _controller.text);
    checkInternetAvailability();
  }

  // List<String> dependent_idss = List<String>();
  List<String> dependent_idss = [];
  File? _image;
  final picker = ImagePicker();
  var proof_of_income_storage;

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    setState(() {});
  }

  getAttachment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      proof_of_income_storage =
          sharedPreferences.getStringList('proof_of_income');
    });
  }

  void _filePicker() async {
    print('hi');
    gross_monthly_income_list = <String>[];
    print(gross_monthly_income_list);
    // await request.ifInternetAvailable();

    // Navigator.pop(context, true);
    setState(() {
      _isLoadingSecondary = true;
    });
    // List<File> listFiles = await FilePicker.getMultiFile();
    // List<File> listFiles = await FilePicker.getMultiFile(
    //     type: FileType.custom, allowedExtensions: ['jpg']);
    FilePickerResult? listFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
      allowMultiple: true,
    );

    if (listFiles != null) {
      List<File> files = listFiles.paths.map((path) => File(path!)).toList();
      print(files.length);
      final Map<String, dynamic> _formData = {};
      _formData['application_id'] = widget.applicant_id;
      var img = [];
      print(img);
      List<String> img_paths = <String>[];
      for (int j = 0; j < files.length; j++) {
        print('files');
        print(files[j]);
        img.add(await MultipartFile.fromFile(files[j].path,
            filename: 'ProofIncomes($j).jpg'));
        img_paths.add(files[j].path);
        gross_monthly_income_list.add(files[j].path);

        print('_formData');
        print(_formData);
      }
      print(img);
      _formData['proof_of_incomes[]'] = img;
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

        FormData formData = new FormData.fromMap(_formData);

        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'proof_of_incomes[]': jsonEncode(img_paths)
        };
        LocalStorage.localStorage.saveFormData(map);

        print('daataaaa');
//
        print(formData);

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
            jsonResponse = response.data;
            // jsonResponse = json.decode(response.data);
            print('data');
            print(jsonResponse['data']['spouse_id']);

            showToastMessage(jsonResponse['message']);
            var dependent_List = jsonResponse['data']['proof_of_incomes'];
            print('data proof of income');
            print(dependent_List);

            setState(() {
              print(dependent_List);
              for (int p = 0; p < dependent_List.length; p++) {
                print('dependent_idsssss');
                print(dependent_List[p]);
                print(dependent_idss);

                String fileName = dependent_List[p].split('/').last;
                print('filename');
//              print( jsonResponse['data']['content_type'][0].toString() );
//              if (jsonResponse['data']['content_type'][0].toString() == 'image/jpeg' || jsonResponse['data']['content_type'][0].toString() == 'image/jpg'
//                  || jsonResponse['data']['content_type'][0].toString() == 'image/png' || jsonResponse['data']['content_type'][0].toString() == 'image/gif'
//              ){
//                print('wiii');
//                dependent_idss.add(dependent_List[p]);
//
//
//              }

                if (fileName.contains('.png') ||
                    fileName.contains('.jpg') ||
                    fileName.contains('.jpeg') ||
                    fileName.contains('.gif')) {
                  print('wiii');
                  dependent_idss.add(dependent_List[p]);
                } else {
                  dependent_idss.add(
                      'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
                }
              }
              sharedPreferences.setStringList(
                  "proof_of_income", dependent_idss);

              _isLoadingSecondary = false;
//            Navigator.pop(context, true);

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

    // final Map<String, dynamic> _formData = {};
    //
    // _formData['application_id'] = widget.applicant_id;
    // var img = [];
    // print(img);
    // List<String> img_paths = <String>[];
    // for (int j = 0; j < listFiles.length; j++) {
    //   print('files');
    //   print(listFiles[j]);
    //   img.add(await MultipartFile.fromFile(listFiles[j].path,
    //       filename: 'ProofIncomes($j).jpg'));
    //   img_paths.add(listFiles[j].path);
    //   gross_monthly_income_list.add(listFiles[j].path);
    //
    //   print('_formData');
    //   print(_formData);
    // }
    // print(img);
    // _formData['proof_of_incomes[]'] = img;
    // if (listFiles != null) {
    // setState(() {
    //   _isLoadingSecondary = true;
    //   print('state');
    //   print(_isLoadingSecondary);
    // });

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
//           'proof_of_incomes[]': jsonEncode(img_paths)
//         };
//         LocalStorage.localStorage.saveFormData(map);
//
//         print('daataaaa');
// //
//         print(formData);
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
//             jsonResponse = response.data;
//             // jsonResponse = json.decode(response.data);
//             print('data');
//             print(jsonResponse['data']['spouse_id']);
//
//             showToastMessage(jsonResponse['message']);
//             var dependent_List = jsonResponse['data']['proof_of_incomes'];
//             print('data proof of income');
//             print(dependent_List);
//
//             setState(() {
//               print(dependent_List);
//               for (int p = 0; p < dependent_List.length; p++) {
//                 print('dependent_idsssss');
//                 print(dependent_List[p]);
//                 print(dependent_idss);
//
//                 String fileName = dependent_List[p].split('/').last;
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
//                   dependent_idss.add(dependent_List[p]);
//                 } else {
//                   dependent_idss.add(
//                       'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//                 }
//               }
//               sharedPreferences.setStringList(
//                   "proof_of_income", dependent_idss);
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
  }

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? auth_token = sharedPreferences.getString('token');
  }

  void uploadImage() async {
    await request.ifInternetAvailable();
    gross_monthly_income_list = <String>[];

    List<String> images_path = <String>[];

    Navigator.pop(context, true);
    File? file;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraCamera(
                  onFile: (onFile) {
                    print(
                        "inside filePicker Grome Month Income uploadImage function");
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
          _image = File(file!.path);
        });
        if (_isLoadingSecondary == true) {
//          showToastMessage('Image Uploading Please wait');
          print(widget.applicant_id);
        }
        FormData formData = new FormData.fromMap({
          "application_id": widget.applicant_id,
//          "signature_date": selectedDate,
          'proof_of_incomes[]': await MultipartFile.fromFile(file!.path,
              filename: 'ProofOfIncomes.jpg')
        });

        gross_monthly_income_list.add(file!.path);

        images_path.add(_image!.path);
        Map<String, dynamic> map = {
          "application_id": widget.applicant_id,
          'proof_of_incomes[]': jsonEncode(images_path)
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
          var jsonResponse = response.data;
          // jsonResponse = json.decode(response.data);
          if (response.statusCode == 200) {
            setState(() {
              _isLoadingSecondary = false;
//            Navigator.pop(context, true);
//            proof_of_income = jsonResponse['data']['proof_of_income'];
//            sharedPreferences.setString("proof_of_income", proof_of_income);

              var dependent_List = jsonResponse['data']['proof_of_incomes'];
              for (int p = 0; p < dependent_List.length; p++) {
                print('dependent_idsssss');
                dependent_idss.add(dependent_List[p]);
//              global.occupantImages = dependent_idss;
                print(dependent_idss);
              }
              sharedPreferences.setStringList(
                  "proof_of_income", dependent_idss);

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
                            Navigator.pop(context, true);
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
          proof_of_income_storage != null
              ? Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    height: proof_of_income_storage != null ? 150 : 0,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(proof_of_income_storage.length,
                            (index) {
                          return CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: proof_of_income_storage[index] != null
                                ? proof_of_income_storage[index]
                                : 'http://via.placeholder.com/1x1',
//            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        })),
                  ),
                )
              : gross_monthly_income_list.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.center,
                      height: 150,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              gross_monthly_income_list.length, (index) {
                            return Center(
                              child: Image.file(
                                File(gross_monthly_income_list[index]),
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
