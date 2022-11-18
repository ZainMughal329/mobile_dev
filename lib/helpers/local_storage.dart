import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage localStorage = LocalStorage._internal();
  SharedPreferences prefs;
  Map<String, dynamic> applicationFormData = Map();
  List<String> applications = <String>[];
  factory LocalStorage() {
    return localStorage;
  }

  LocalStorage._internal();

  LocalStorage._();

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> clearSharedPreferences() {
    return prefs.clear();
  }

  // Future<bool> clearFormData(String applicationId) {
  //   List<String> list = prefs.getStringList('applicationIds');
  //   list.where((element) {
  //     if (element == applicationId) {
  //       list.remove(element);
  //     }
  //   });
  //   prefs.setStringList('applicationIds', list);
  //   return prefs.remove(applicationId);
  // }

  String getUserID() {
    return prefs.getString('userID');
  }

  String getAuthToken() {
    return prefs.getString('auth-token');
  }

  void getApplicationsList() {
    // prefs.remove("applicationIds");

    MyConstants.myConst.applicationsList =
        prefs.getStringList('applicationIds') == null
            ? []
            : prefs.getStringList('applicationIds');
    print("Applications List :::: ${MyConstants.myConst.applicationsList}");
  }

  void saveFormData(Map<String, dynamic> applicantInfo) async {
    String applicationId = applicantInfo['id_number'];
    print("Application id_number ::: $applicationId");
    if (applicationId != null) {
      MyConstants.myConst.currentApplicantId = applicationId;
      print("Application ID was not null");
    } else {
      applicationId = MyConstants.myConst.currentApplicantId;
      print("Application ID was null");
    }

    print("stop");
    checkAndupdateApplicantData(applicationId);
    print("Applicants info :: $applicantInfo");
    if (applicationFormData != null) {
      applicationFormData.addAll(applicantInfo);
      print("Application ID ::: $applicationId exists");
    } else {
      applicationFormData = applicantInfo;
    }

    // checkIfFileExists();

    log("Application Data saved :: $applicationFormData");
    print(applicationFormData.length);
    prefs.setString(applicationId, jsonEncode(applicationFormData));
    prefs.setStringList('applicationIds', applications);
    print("Application IDs :::: ${prefs.getStringList('applicationIds')}");
    print("Leaving Local Storage");
  }

  checkIfFileExists() async {
    // removeApplicationsIdList();
    bool fileStatus;
    String filePath =
        "/data/user/0/lesedi.com.lesedi/cache/CAP1939108338.jpg";

    fileStatus = await File(filePath).exists();
    print("Check if previously captured file exists? ::::: $fileStatus ");

    if (fileStatus) {
      File file = File(filePath);
      await Utils.createFile(file, "imgfrmcache");
    } else {
      print("No such file with name report.jpg");
    }
  }

  Map getFormData(String applicationId) {
    print("get form data :::: ${prefs.getString(applicationId)}");
    if (prefs.getString(applicationId) != null) {
      Map formData = jsonDecode(prefs.getString(applicationId));
      print(formData);
      return formData;
    } else {
      print("application data in shared pref null");
      return {};
    }
  }

  // // REMOVE ALL SAVED APPLICATIONS INFORMATIONS
  // Future<void> removeApplicationsIdList() async {
  //   List<String> emptyList = [];
  //   prefs.remove("applicationIds");
  //   prefs.setStringList("applicationIds", emptyList);
  //   MyConstants.myConst.applicationsList = [];
  //   // await _deleteCacheDir();
  // }

  // DELETES CACHE FOLDER
  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  // DELETES PACKAGE FOLDER
  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  void formSubmitted(bool val) {
    prefs.setBool('formSubmitted', val);
  }

  bool getFormSubmissionStatus() {
    return prefs.getBool('formSubmitted') == null
        ? true
        : prefs.getBool('formSubmitted');
  }

  void checkAndupdateApplicantData(String applicationId) {
    // prefs.clear();
    // print("preferences cleared");
    if (prefs.getString(applicationId) != null) {
      applicationFormData = jsonDecode(prefs.getString(applicationId));
      print(applicationFormData);
    } else {
      applications.add(applicationId);
      print("New Application Added with ID ::: $applicationId");
    }
  }

  void clearApplicationsID() {
    prefs.setStringList('applicationIds', []);

    List<String> list = prefs.getStringList('applicationIds');
    applications = [];

    MyConstants.myConst.applicationsList =
        prefs.getStringList('applicationIds');

    print(
        "Applications list cleared ::: ${MyConstants.myConst.applicationsList}");
  }

  void clearCurrentApplication() {
    prefs.remove(MyConstants.myConst.currentApplicantId);

    List<String> applicationIds = MyConstants.myConst.applicationsList;
    applicationIds.remove(MyConstants.myConst.currentApplicantId);
    prefs.setStringList('applicationIds', applicationIds);
    MyConstants.myConst.applicationsList =
        prefs.getStringList('applicationIds');
    applications = MyConstants.myConst.applicationsList;
    print(
        "After removing applicationIds ::::: ${MyConstants.myConst.applicationsList}");
  }
}
