import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/common_services/services_request.dart';

class Utils {
  static String convertFileToBase64(File file) {
    // conversion to base64 can be done both ways in one line or two
    // String base64String = base64Encode(file.readAsBytesSync());
    print(file);
    final Uint8List bytes = file.readAsBytesSync();
    final String base64String = base64Encode(bytes);

    return base64String;
  }

  static Future<Image> convertFileFromBase64(String bytes) async {
    Uint8List imageBytes = base64Decode(bytes);
    print(imageBytes);

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(imageBytes);

    return Image.memory(imageBytes);
  }
  //
  // static void platformFileToFile(PlatformFile platformFile) {
  //   final File file = File(platformFile.path);
  //   print(file);
  //   convertFileToBase64(file);
  // }

  static void saveFile(File file, String imageName) {
    Map<String, dynamic> data = {imageName: file.path};
    LocalStorage.localStorage.saveFormData(data);
  }

  static void saveListOFile(List<String> paths, String imageName) async {
    Map<String, dynamic> data = {imageName: jsonEncode(paths)};
    LocalStorage.localStorage.saveFormData(data);
  }

  // static void debuggingCheckFile(FilePickerResult file) {
  //   print(file);
  //   print(file.files);
  //   print(file.files.length);
  //   print(file.files.single.path);
  //
  //   file.files.forEach((currentFile) {
  //     print(currentFile.path);
  //   });
  // }

  static Future createFile(File file, String fileName) async {
    getPermission();

    // These lines confirms that file after being taken from
    // camera exists in the path
    // print("Path of Image from camera is " + file.path);
    // print(await File(
    //         "/data/user/0/lesedi.com.lesedi/cache/CAP697576584.jpg")
    //     .exists());

    final path = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    print(path?.path);
    try {
      File newFile = File('${path?.path}/$fileName.jpg');
      newFile = await newFile.create(recursive: true);
      newFile.writeAsBytesSync(file.readAsBytesSync());

      // createTextFile(path.path);

      // saveFile(newFile, newFile.path);
    } catch (e) {
      print("Error is");
      print(e);
    }
  }

  // static void createTextFile(String path) async {
  //   final File file = File('$path/my_file.txt');
  //   String savedData;
  //   savedData = LocalStorage.localStorage.getFormData().toString();
  //   await file.writeAsString(savedData);
  // }

  static Future createListOfFile(List<File> files, String fileName) async {
    getPermission();

    int index = 0;
    List<String> paths = <String>[];
    final path = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    print(path?.path??"");

    files.forEach((file) async {
      try {
        File newFile = File('${path?.path??""}/$fileName$index.jpg');
        newFile = await newFile.create(recursive: true);
        newFile.writeAsBytesSync(file.readAsBytesSync());
        paths.add(newFile.path);

        // saveFile(newFile, newFile.path);
      } catch (e) {
        print("Error is");
        print(e);
      }
    });
    saveListOFile(paths, fileName);
    paths = <String>[];
  }

  static void getPermission() async {
    print("getPermission");
    await Permission.storage.request();
    if (PermissionStatus.granted.isGranted) {
      print("Storage Permission Granted");
    } else {
      print("Storage Permission not granted");
    }
  }

  static void checkFormStatusAndSubmit() {
    if (!LocalStorage.localStorage.getFormSubmissionStatus()) {
      ServicesRequest request = ServicesRequest();
      print("Form Submission Status ::: false");
      request.submitForm();
    } else {
      print("Form Submission Status is ::: True");
    }
  }

  static alertDialog({required BuildContext context,required Function() onCamera,required Function() onGallery})
  {
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
                        onGallery();
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
                        onCamera();
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
  }
}
