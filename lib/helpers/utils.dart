import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:rustenburg/networkRequest/services_request.dart';

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
    //         "/data/user/0/rustenburg.com.rustenburg/cache/CAP697576584.jpg")
    //     .exists());

    final path = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    print(path.path);
    try {
      File newFile = File('${path.path}/$fileName.jpg');
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
    print(path.path);

    files.forEach((file) async {
      try {
        File newFile = File('${path.path}/$fileName$index.jpg');
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
}
