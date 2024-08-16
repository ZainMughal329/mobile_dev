// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:camera_camera/camera_camera.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lesedi/utils/constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lesedi/common_services/local_storage.dart';
// import 'package:lesedi/common_services/services_request.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mime/mime.dart';
// import '../utils/global.dart';
// import 'package:lesedi/utils/globals.dart' as global;
//
// class OccupantID extends StatefulWidget {
//   int applicant_id;
//   String image_name;
//
//   OccupantID(this.applicant_id, this.image_name);
//
//   @override
//   _OccupantIDState createState() => _OccupantIDState();
// }
//
// class _OccupantIDState extends State<OccupantID> {
//   String? _extension;
//   String? profileType;
//   TextEditingController _controller = new TextEditingController();
//   bool _isLoadingSecondary = false;
//   bool _isLoading = false;
//
//   // List<String> dependent_idss = List<String>();
//   List<String> dependent_idss = [];
//   ServicesRequest request = ServicesRequest();
//   List<String> occupant_ids_list = <String>[];
//
// //var
//   @override
//   void initState() {
//     super.initState();
//     print('id agye hai');
//     _controller.addListener(() => _extension = _controller.text);
//     checkInternetAvailability();
//   }
//
//   checkInternetAvailability() async {
//     await request.ifInternetAvailable();
//     setState(() {});
//   }
//
//   var dependant_id_storage;
//
//   void dummy(List<DummyImageModel> dummyImageData) {
//     Map<String, dynamic> occupantIdsWithImages = {};
//
//     for (var imageData in dummyImageData) {
//       List<Map<String, dynamic>> imgMap = [];
//
//       for (var img in imageData.images) {
//         imgMap.add({"url": img, "content_type": "image/png"});
//       }
//
//       occupantIdsWithImages[imageData.id] = imgMap;
//     }
//
//     // Here is the JSON structure you wanted
//     Map<String, dynamic> jsonData = {
//       "occupant_ids_with_images": occupantIdsWithImages
//     };
//
//
//
//
//     // Convert the jsonData map to a JSON string
//     String jsonString = jsonEncode(jsonData);
//
//     // Now you can send jsonString to your API or use it as needed
//     print(jsonString);
//   }
//
//
//
//
//
//
// // You can use occupationBody as needed here
//
//
//   getAttachment() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //    role = sharedPreferences.getString('role');
//     global.occupantImages;
//     print(global.occupantImages);
//     setState(() {
// //      global.occupantImages;
//       print(global.occupantImages);
//       dependant_id_storage = sharedPreferences.getStringList('dependent_idss');
//       print(dependant_id_storage);
//     });
//   }
//
//   void _filePicker() async {
//     await request.ifInternetAvailable();
//     occupant_ids_list = <String>[];
//     // List<File> listFiles = await FilePicker.getMultiFile(
//     //     type: FileType.custom, allowedExtensions: ['jpg','png']);
//     FilePickerResult? listFiles = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png'],
//       allowMultiple: true,
//     );
//     Navigator.pop(context, true);
//     setState(() {
//       _isLoadingSecondary = true;
//     });
//     // List<File> listFiles = await FilePicker.getMultiFile();
//     final Map<String, dynamic> _formData = {};
//     _formData['application_id'] = widget.applicant_id;
//     var img = [];
//     List<String> img_paths = <String>[];
//     occupant_ids_list = [];
//
//     if (listFiles != null) {
//       List<File> files = listFiles.paths.map((path) => File(path!)).toList();
//
//       for (int j = 0; j < files.length; j++) {
//         img.add(await MultipartFile.fromFile(files[j].path,
//             filename: 'occupantId($j).jpg'));
//         img_paths.add(files[j].path);
//         occupant_ids_list.add(files[j].path);
//         print(_formData);
//       }
//     }
//
//     _formData['occupant_ids[]'] = img;
//
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
//           'application_id': widget.applicant_id,
//           'occupant_ids[]': jsonEncode(img_paths)
//         };
//
//         LocalStorage.localStorage.saveFormData(map);
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
//           // var jsonResponse = json.decode(response.data);
//           var jsonResponse = response.data;
//           if (response.statusCode == 200) {
//             setState(() {
//               _isLoadingSecondary = false;
//               var newEntry;
//               dependent_idss = [];
//               sharedPreferences.setStringList("dependent_idss", dependent_idss);
//               var occupant_List = jsonResponse['data']['occupant_ids'];
//               print(occupant_List);
//               for (int p = 0; p < occupant_List.length; p++) {
//                 // newEntry = occupant_List[p];
//                 setState(() {
//                   dependent_idss.add(occupant_List[p]);
//                 });
//
// //              global.occupantImages = dependent_idss;
//               }
//               print(jsonResponse['data']['content_type'][0].toString());
//               if (jsonResponse['data']['content_type'][0].toString() ==
//                       'image/jpeg' ||
//                   jsonResponse['data']['content_type'][0].toString() ==
//                       'image/jpg' ||
//                   jsonResponse['data']['content_type'][0].toString() ==
//                       'image/png' ||
//                   jsonResponse['data']['content_type'][0].toString() ==
//                       'image/gif') {
//                 print('wiii');
// //                  dependent_idss.add(occupant_List[p]);
// //                 dependent_idss.add(newEntry);
//                 print(dependent_idss);
//               } else {
//                 dependent_idss.add(
//                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
//               }
//               sharedPreferences.setStringList("dependent_idss", dependent_idss);
//
//               getAttachment();
//             });
//
//             showToastMessage('File Uploaded');
//             print("Check Occupant ID Files" + occupant_ids_list.toString());
//           }
//         } else {
//           setState(() {});
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Something went wrong");
//         setState(() {
//           _isLoading = false;
//           _isLoadingSecondary = false;
//         });
//         print(e);
//       }
//     }
//   }
//
//   void updateProfileWithResume() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? auth_token = sharedPreferences.getString('token');
//   }
//
//   File? _image;
//   final picker = ImagePicker();
//
//   void uploadImage() async {
//     await request.ifInternetAvailable();
//     occupant_ids_list = <String>[];
//     List<String> img_paths = <String>[];
//     setState(() {
//       _isLoadingSecondary = true;
//     });
//     Navigator.pop(context, true);
//     File? file;
//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CameraCamera(
//                   onFile: (onFile) {
//                     print("inside death dependent id uploadImage function");
//                     print(onFile);
//                     file = onFile;
//                     Navigator.pop(context);
//                   },
//                   enableZoom: true,
//                   resolutionPreset: ResolutionPreset.medium,
//                   cameraSide: CameraSide.all,
//                 )));
//     print(file?.path ?? "");
//     print(file);
//
//     if (file != null) {
//       try {
//         setState(() {
//           _image = File(file?.path ?? "");
//         });
//         if (_isLoadingSecondary == true) {
// //          showToastMessage('Image Uploading Please wait');
//           print(widget.applicant_id);
//         }
//
//         occupant_ids_list.add(file?.path ?? "");
//         Map<String, dynamic> data = {
//           "application_id": widget.applicant_id,
// //          "signature_date": selectedDate,
//           'occupant_ids[]': await MultipartFile.fromFile(file?.path ?? "",
//               filename: 'occupantID.jpg')
//         };
//
//         FormData formData = new FormData.fromMap(data);
//
//         img_paths.add(_image?.path ?? "");
//         Map<String, dynamic> map = {
//           "application_id": widget.applicant_id,
//           'occupant_ids[]': jsonEncode(img_paths)
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
//
//           Response response = await dio.post(
//             '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
//             data: formData, // Post with Stream<List<int>>
//             options: Options(
//                 headers: {'uuid': userID, 'Authentication': authToken},
//                 contentType: "*/*",
//                 responseType: ResponseType.json),
//           );
//           if (response.statusCode == 200) {
//             // var jsonResponse = json.decode(response.data);
//             var jsonResponse = response.data;
// //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
//             setState(() {
//               _isLoadingSecondary = false;
//               var occupant_List = jsonResponse['data']['occupant_ids'];
//               var newEntry;
//               for (int p = 0; p < occupant_List.length; p++) {
//                 print('dependent_idsssss');
// //              dependent_idss.add(occupant_List[p]);
//                 newEntry = occupant_List[p];
// //              global.occupantImages = dependent_idss;
//                 print(dependent_idss);
//               }
//               dependent_idss.add(newEntry);
//               sharedPreferences.setStringList("dependent_idss", dependent_idss);
//               getAttachment();
//             });
//
//             showToastMessage('Form Submitted');
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
//                     child: Container(
//                       child: new Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Divider(),
//                           InkWell(
//                             onTap: () {
//                               _filePicker();
//                             },
//                             child: Container(
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 20, right: 30, bottom: 0, top: 20),
//                                 child: Container(
//                                   margin: EdgeInsets.only(bottom: 15),
//                                   height: 55.0,
//                                   width: 600.0,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Icon(
//                                             Icons.image,
//                                             color: Colors.black,
//                                             size: 20,
//                                           )),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         'Chosse From Gallery',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             letterSpacing: 0.2,
//                                             fontFamily: "Open Sans",
//                                             fontSize: 14.0,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ],
//                                   ),
//                                   alignment: FractionalOffset.center,
//                                   decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black38,
//                                             blurRadius: 0.0)
//                                       ],
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       gradient: LinearGradient(colors: <Color>[
//                                         Color(0xFFFFFFFF),
//                                         Color(0xFFFFFFFF)
//                                       ])),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               uploadImage();
//                             },
//                             child: Container(
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 20, right: 30, bottom: 0, top: 0),
//                                 child: Container(
//                                   margin: EdgeInsets.only(bottom: 15),
//                                   height: 55.0,
// //                        width: 600.0,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Icon(
//                                             Icons.camera_enhance,
//                                             color: Colors.black,
//                                             size: 20,
//                                           )),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         'Chosse From Camera',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             letterSpacing: 0.2,
//                                             fontFamily: "Open Sans",
//                                             fontSize: 14.0,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ],
//                                   ),
//                                   alignment: FractionalOffset.center,
//                                   decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black38,
//                                             blurRadius: 0.0)
//                                       ],
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       gradient: LinearGradient(colors: <Color>[
//                                         Color(0xFFFFFFFF),
//                                         Color(0xFFFFFFFF)
//                                       ])),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
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
//                           : MyConstants.myConst.internet ?? false
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
//                           MyConstants.myConst.internet ?? false
//                               ? 'Uploading'
//                               : "Saved",
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
//             ),
//           ),
//           dependant_id_storage != null
//               ? Center(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                     alignment: Alignment.center,
//                     height: dependant_id_storage != null ? 150 : 0,
//                     child: ListView(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.horizontal,
//                         children:
//                             List.generate(dependant_id_storage.length, (index) {
//                           return CachedNetworkImage(
//                             placeholder: (context, url) =>
//                                 CircularProgressIndicator(),
//                             imageUrl: dependant_id_storage[index] != null
//                                 ? dependant_id_storage[index]
//                                 : 'http://via.placeholder.com/1x1',
// //            errorWidget: (context, url, error) => Icon(Icons.error),
//                           );
//                         })),
//                   ),
//                 )
//               : occupant_ids_list.isNotEmpty
//                   ? Container(
//                       padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                       alignment: Alignment.center,
//                       height: 150,
//                       child: ListView(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           children:
//                               List.generate(occupant_ids_list.length, (index) {
//                             return Center(
//                               child: Image.file(
//                                 File(occupant_ids_list[index]),
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           })),
//                     )
//                   : SizedBox()
//         ],
//       ),
//     );
//   }
// }
//
// class DummyImageModel {
//   String id;
//   List<String> images;
//
//   DummyImageModel(this.images, this.id);
// }

// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:camera_camera/camera_camera.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lesedi/forms/personal_information_A1/notifier/personal_information_notifier.dart';
// import 'package:lesedi/utils/constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lesedi/common_services/local_storage.dart';
// import 'package:lesedi/common_services/services_request.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mime/mime.dart';
// import '../utils/global.dart';
// import 'package:lesedi/utils/globals.dart' as global;
//
// class OccupantID extends ConsumerStatefulWidget {
//   DummyImageModel imageData;
//   int applicant_id;
//   String image_name;
//
//   OccupantID(this.applicant_id, this.image_name, this.imageData);
//
//   @override
//   ConsumerState<OccupantID> createState() => _OccupantIDState();
// }
//
// class _OccupantIDState extends ConsumerState<OccupantID> {
//   final occupantProvider =
//   ChangeNotifierProvider<PersonalInformationNotifier>((ref) {
//     return PersonalInformationNotifier();
//   });
//   String? _extension;
//   String? profileType;
//   TextEditingController _controller = new TextEditingController();
//   bool _isLoadingSecondary = false;
//   bool _isLoading = false;
//
//   // List<String> dependent_idss = List<String>();
//   List<String> dependent_idss = [];
//   ServicesRequest request = ServicesRequest();
// List<DummyImageModel> occupantData=[];
//   List<String> occupant_ids_list = [];
//
// //var
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       final notifier = ref.read(occupantProvider);
//       await notifier.loadOccupantIds();
//       setState(() {
//         occupant_ids_list = notifier.occupantIds; // Update the list
//       });
//     });
//     super.initState();
//     print('id agye hai');
//     _controller.addListener(() => _extension = _controller.text);
//     checkInternetAvailability();
//   }
//
//   checkInternetAvailability() async {
//     await request.ifInternetAvailable();
//     setState(() {});
//   }
//
//   var dependant_id_storage;
//
//   void dummy(List<DummyImageModel> dummyImageData) {
//     Map<String, dynamic> occupantIdsWithImages = {};
//
//     for (var imageData in dummyImageData) {
//       List<Map<String, dynamic>> imgMap = [];
//
//       for (var img in imageData.images) {
//         imgMap.add({"url": img, "content_type": "image/png"});
//       }
//
//       occupantIdsWithImages[imageData.id] = imgMap;
//     }
//
//     // Here is the JSON structure you wanted
//     Map<String, dynamic> jsonData = {
//       "occupant_ids_with_images": occupantIdsWithImages
//     };
//
//
//
//
//     // Convert the jsonData map to a JSON string
//     String jsonString = jsonEncode(jsonData);
//
//     // Now you can send jsonString to your API or use it as needed
//     print(jsonString);
//   }
//
//
//
//
//
//
// // You can use occupationBody as needed here
//
//
//   getAttachment() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //    role = sharedPreferences.getString('role');
//     global.occupantImages;
//     print(global.occupantImages);
//     setState(() {
// //      global.occupantImages;
//       print(global.occupantImages);
//       dependant_id_storage = sharedPreferences.getStringList('dependent_idss');
//       print(dependant_id_storage);
//     });
//   }
//
//
//
//   Future<File?> imageOptionClick(ImageSource source) async {
//     final _picker = ImagePicker();
//     final pickedFile = await _picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       return  File(pickedFile.path);
//
//     }
//     return null;
//   }
//
//   Future<void> setOccupantImages(ImageSource source,DummyImageModel imageModel) async {
//   final imgFile= await imageOptionClick(source);
//
//   if(imgFile!=null){
//     imageModel.images.add("value");
//     /// dummyImageData.img.add()
//   }
// }
//
//
// //   void _filePicker() async {
// //     await request.ifInternetAvailable();
// //     final occupant_ids_list = <String>[];
// //     // List<File> listFiles = await FilePicker.getMultiFile(
// //     //     type: FileType.custom, allowedExtensions: ['jpg','png']);
// //     FilePickerResult? listFiles = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['jpg', 'png'],
// //       allowMultiple: true,
// //     );
// //     Navigator.pop(context, true);
// //     setState(() {
// //       _isLoadingSecondary = true;
// //     });
// //     // List<File> listFiles = await FilePicker.getMultiFile();
// //     final Map<String, dynamic> _formData = {};
// //     _formData['application_id'] = widget.applicant_id;
// //     var img = [];
// //     List<String> img_paths = <String>[];
// //     occupant_ids_list = [];
// //
// //     if (listFiles != null) {
// //       List<File> files = listFiles.paths.map((path) => File(path!)).toList();
// //
// //       for (int j = 0; j < files.length; j++) {
// //         img.add(await MultipartFile.fromFile(files[j].path,
// //             filename: 'occupantId($j).jpg'));
// //         img_paths.add(files[j].path);
// //         occupant_ids_list.add(files[j].path);
// //
// //         print(_formData);
// //       }
// //     }
// //
// //     _formData['occupant_ids[]'] = img;
// //
// //     if (listFiles != null) {
// //       _isLoadingSecondary = true;
// //
// //       try {
// //         if (_isLoadingSecondary == true) {
// //           print(widget.applicant_id);
// //         }
// //         FormData formData = new FormData.fromMap(_formData);
// //
// //         Map<String, dynamic> map = {
// //           'application_id': widget.applicant_id,
// //           'occupant_ids[]': jsonEncode(img_paths)
// //         };
// //
// //         LocalStorage.localStorage.saveFormData(map);
// //
// //         if (MyConstants.myConst.internet ?? false) {
// //           showToastMessage('File Uploading Please wait');
// //           var dio = Dio(BaseOptions(
// //               receiveDataWhenStatusError: true,
// //               connectTimeout: Duration(minutes: 3), // 3 minutes
// //               receiveTimeout: Duration(minutes: 3) // 3 minuntes
// //           ));
// //           dio.interceptors.add(LogInterceptor(responseBody: true));
// //           SharedPreferences sharedPreferences =
// //           await SharedPreferences.getInstance();
// //           var userID = sharedPreferences.getString('userID');
// //           var authToken = sharedPreferences.getString('auth-token');
// //
// //           Response response = await dio.post(
// //             '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
// //             data: formData, // Post with Stream<List<int>>
// //             options: Options(
// //                 headers: {'uuid': userID, 'Authentication': authToken},
// //                 contentType: "*/*",
// //                 responseType: ResponseType.json),
// //           );
// //
// //           // var jsonResponse = json.decode(response.data);
// //           var jsonResponse = response.data;
// //           if (response.statusCode == 200) {
// //             setState(() {
// //               _isLoadingSecondary = false;
// //               var newEntry;
// //               dependent_idss = [];
// //               sharedPreferences.setStringList("dependent_idss", dependent_idss);
// //               var occupant_List = jsonResponse['data']['occupant_ids'];
// //               print(occupant_List);
// //               for (int p = 0; p < occupant_List.length; p++) {
// //                 // newEntry = occupant_List[p];
// //                 setState(() {
// //                   dependent_idss.add(occupant_List[p]);
// //                 });
// //
// // //              global.occupantImages = dependent_idss;
// //               }
// //               print(jsonResponse['data']['content_type'][0].toString());
// //               if (jsonResponse['data']['content_type'][0].toString() ==
// //                   'image/jpeg' ||
// //                   jsonResponse['data']['content_type'][0].toString() ==
// //                       'image/jpg' ||
// //                   jsonResponse['data']['content_type'][0].toString() ==
// //                       'image/png' ||
// //                   jsonResponse['data']['content_type'][0].toString() ==
// //                       'image/gif') {
// //                 print('wiii');
// // //                  dependent_idss.add(occupant_List[p]);
// // //                 dependent_idss.add(newEntry);
// //                 print(dependent_idss);
// //               } else {
// //                 dependent_idss.add(
// //                     'https://pngimage.net/wp-content/uploads/2018/06/files-icon-png-2.png');
// //               }
// //               sharedPreferences.setStringList("dependent_idss", dependent_idss);
// //
// //               getAttachment();
// //             });
// //
// //             showToastMessage('File Uploaded');
// //             print("Check Occupant ID Files" + occupant_ids_list.toString());
// //           }
// //         } else {
// //           setState(() {});
// //         }
// //       } catch (e) {
// //         Fluttertoast.showToast(msg: "Something went wrong");
// //         setState(() {
// //           _isLoading = false;
// //           _isLoadingSecondary = false;
// //         });
// //         print(e);
// //       }
// //     }
// //   }
//
//   void updateProfileWithResume() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? auth_token = sharedPreferences.getString('token');
//   }
//
//   File? _image;
//   final picker = ImagePicker();
//
// //   void uploadImage() async {
// //     await request.ifInternetAvailable();
// //     occupant_ids_list = <String>[];
// //     List<String> img_paths = <String>[];
// //     setState(() {
// //       _isLoadingSecondary = true;
// //     });
// //     Navigator.pop(context, true);
// //     File? file;
// //     await Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //             builder: (context) => CameraCamera(
// //               onFile: (onFile) {
// //                 print("inside death dependent id uploadImage function");
// //                 print(onFile);
// //                 file = onFile;
// //                 Navigator.pop(context);
// //               },
// //               enableZoom: true,
// //               resolutionPreset: ResolutionPreset.medium,
// //               cameraSide: CameraSide.all,
// //             )));
// //     print(file?.path ?? "");
// //     print(file);
// //
// //     if (file != null) {
// //       try {
// //         setState(() {
// //           _image = File(file?.path ?? "");
// //         });
// //         if (_isLoadingSecondary == true) {
// // //          showToastMessage('Image Uploading Please wait');
// //           print(widget.applicant_id);
// //         }
// //
// //
// //         occupant_ids_list.add(file?.path ?? "");
// //         Map<String, dynamic> data = {
// //           "application_id": widget.applicant_id,
// // //          "signature_date": selectedDate,
// //           'occupant_ids[]': await MultipartFile.fromFile(file?.path ?? "",
// //               filename: 'occupantID.jpg')
// //         };
// //
// //         FormData formData = new FormData.fromMap(data);
// //
// //         img_paths.add(_image?.path ?? "");
// //         Map<String, dynamic> map = {
// //           "application_id": widget.applicant_id,
// //           'occupant_ids[]': jsonEncode(img_paths)
// //         };
// //         LocalStorage.localStorage.saveFormData(map);
// //
// //         print(formData.toString());
// //
// //         if (MyConstants.myConst.internet ?? false) {
// //           showToastMessage('File Uploading Please wait');
// //           var dio = Dio(BaseOptions(
// //               receiveDataWhenStatusError: true,
// //               connectTimeout: Duration(minutes: 3), // 3 minutes
// //               receiveTimeout: Duration(minutes: 3) // 3 minuntes
// //           ));
// //           dio.interceptors.add(LogInterceptor(responseBody: true));
// //           SharedPreferences sharedPreferences =
// //           await SharedPreferences.getInstance();
// //           var userID = sharedPreferences.getString('userID');
// //           var authToken = sharedPreferences.getString('auth-token');
// //
// //           Response response = await dio.post(
// //             '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
// //             data: formData, // Post with Stream<List<int>>
// //             options: Options(
// //                 headers: {'uuid': userID, 'Authentication': authToken},
// //                 contentType: "*/*",
// //                 responseType: ResponseType.json),
// //           );
// //           if (response.statusCode == 200) {
// //             // var jsonResponse = json.decode(response.data);
// //             var jsonResponse = response.data;
// // //          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> D()));
// //             setState(() {
// //               _isLoadingSecondary = false;
// //               var occupant_List = jsonResponse['data']['occupant_ids'];
// //               var newEntry;
// //               for (int p = 0; p < occupant_List.length; p++) {
// //                 print('dependent_idsssss');
// // //              dependent_idss.add(occupant_List[p]);
// //                 newEntry = occupant_List[p];
// // //              global.occupantImages = dependent_idss;
// //                 print(dependent_idss);
// //               }
// //               dependent_idss.add(newEntry);
// //               sharedPreferences.setStringList("dependent_idss", dependent_idss);
// //               getAttachment();
// //             });
// //
// //             showToastMessage('Form Submitted');
// //           }
// //         } else {
// //           setState(() {});
// //         }
// //       } catch (e) {
// //         Fluttertoast.showToast(msg: "Something went wrong");
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         print('dsa');
// //         print(e);
// //       }
// //     }
// //   }
//
//   @override
//   Widget build(BuildContext context) {
//     final occupantNotifier = ref.watch(occupantProvider);
//     return InkWell(
//       onTap: () {
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
//                 child: Container(
//                   child: new Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Divider(),
//                       InkWell(
//                         onTap: () {
//                           setOccupantImages(ImageSource.gallery, DummyImageModel([], ''));
//                         },
//                         child: Container(
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20, right: 30, bottom: 0, top: 20),
//                             child: Container(
//                               margin: EdgeInsets.only(bottom: 15),
//                               height: 55.0,
//                               width: 600.0,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Icon(
//                                         Icons.image,
//                                         color: Colors.black,
//                                         size: 20,
//                                       )),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     'Chosse From Gallery',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         letterSpacing: 0.2,
//                                         fontFamily: "Open Sans",
//                                         fontSize: 14.0,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                 ],
//                               ),
//                               alignment: FractionalOffset.center,
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black38,
//                                         blurRadius: 0.0)
//                                   ],
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   gradient: LinearGradient(colors: <Color>[
//                                     Color(0xFFFFFFFF),
//                                     Color(0xFFFFFFFF)
//                                   ])),
//                             ),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           setOccupantImages(ImageSource.camera, DummyImageModel([], ''));
//                         },
//                         child: Container(
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20, right: 30, bottom: 0, top: 0),
//                             child: Container(
//                               margin: EdgeInsets.only(bottom: 15),
//                               height: 55.0,
// //                        width: 600.0,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Icon(
//                                         Icons.camera_enhance,
//                                         color: Colors.black,
//                                         size: 20,
//                                       )),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     'Chosse From Camera',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         letterSpacing: 0.2,
//                                         fontFamily: "Open Sans",
//                                         fontSize: 14.0,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                 ],
//                               ),
//                               alignment: FractionalOffset.center,
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black38,
//                                         blurRadius: 0.0)
//                                   ],
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   gradient: LinearGradient(colors: <Color>[
//                                     Color(0xFFFFFFFF),
//                                     Color(0xFFFFFFFF)
//                                   ])),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
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
//                           : MyConstants.myConst.internet ?? false
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
//                     MyConstants.myConst.internet ?? false
//                         ? 'Uploading'
//                         : "Saved",
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
//             ),
//           ),
//           dependant_id_storage != null
//               ? Center(
//             child: Container(
//               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//               alignment: Alignment.center,
//               height: dependant_id_storage != null ? 150 : 0,
//               child: ListView(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   children:
//                   List.generate(dependant_id_storage.length, (index) {
//                     return CachedNetworkImage(
//                       placeholder: (context, url) =>
//                           CircularProgressIndicator(),
//                       imageUrl: dependant_id_storage[index] != null
//                           ? dependant_id_storage[index]
//                           : 'http://via.placeholder.com/1x1',
// //            errorWidget: (context, url, error) => Icon(Icons.error),
//                     );
//                   })),
//             ),
//           )
//               : occupant_ids_list.isNotEmpty
//               ? Container(
//             padding: EdgeInsets.only(left: 15.0, right: 15.0),
//             alignment: Alignment.center,
//             height: 150,
//             child: ListView(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 children:
//                 List.generate(occupant_ids_list.length, (index) {
//                   return Center(
//                     child: Image.file(
//                       File(occupant_ids_list[index]),
//                       width: 100,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 })),
//           )
//               : SizedBox()
//         ],
//       ),
//     );
//   }
// }
//
// class DummyImageModel {
//   String id;
//   List<String> images;
//
//   DummyImageModel(this.images, this.id);
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/attachments/view/occupants/occupant_viewmodel.dart';
import 'package:lesedi/forms/personal_information_A1/notifier/personal_information_notifier.dart';

import 'package:image_picker/image_picker.dart';

class OccupantID extends ConsumerStatefulWidget {
  final int applicant_id;
  final String image_name;

  OccupantID(this.applicant_id, this.image_name);

  @override
  ConsumerState<OccupantID> createState() => _OccupantIDState();
}

class _OccupantIDState extends ConsumerState<OccupantID> {
  final personalInformationNotifier =
      ChangeNotifierProvider<PersonalInformationNotifier>((ref) {
    return PersonalInformationNotifier();
  });

  final occupantViewModelProvider =
      ChangeNotifierProvider<OccupantViewModel>((ref) {
    return OccupantViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref
          .read(occupantViewModelProvider)
          .initMethod(ref.read(personalInformationNotifier).occupantIds);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final occupantViewModel = ref.watch(occupantViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (occupantViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: occupantViewModel.occupantData.length,
                  itemBuilder: (context, index) {
                    final occupationData =
                        occupantViewModel.occupantData[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(occupationData.id),
                            trailing: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title:
                                        Text('Upload File for Occupant id: ${occupationData.id}'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text('Choose from Gallery'),
                                            onTap: () {
                                              occupantViewModel
                                                  .setOccupantImages(
                                                      ImageSource.gallery,
                                                      index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text('Choose from Camera'),
                                            onTap: () {
                                              occupantViewModel
                                                  .setOccupantImages(
                                                      ImageSource.camera,
                                                      index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Upload'),
                            ),
                          ),
                          Padding(
                            // Add padding around images
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: List.generate(
                                  occupationData.selectedImages.length,
                                  (imageIndex) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Image.file(
                                            width: 50, height: 50,
                                            occupationData
                                                .selectedImages[imageIndex],
                                            fit: BoxFit
                                                .contain, // Ensure images fit within the container
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                occupantViewModel.setLoading(true);
                try {
                  await occupantViewModel.postOccupation(widget.applicant_id.toString());
                  // Wait for postOccupation to complete
                  // You might want to navigate or show a success message here
                } finally {
                  occupantViewModel.setLoading(false);
                }
              },
              child: Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}
