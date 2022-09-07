import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rustenburg/constans/Constants.dart';
import 'package:rustenburg/helpers/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServicesRequest {
  bool ready = false;
  Map myMap = Map();
  Map tempMap = Map();
  FormData tempformData;
  Future<bool> submitForm() async {
    LocalStorage.localStorage.checkIfFileExists();
    ServicesRequest request = ServicesRequest();
    LocalStorage.localStorage.getApplicationsList();
    bool ready = false;

    await request.ifInternetAvailable();
    var dio = Dio(BaseOptions(
      connectTimeout: 90 * 1000,
    ));
    dio.interceptors.add(LogInterceptor(responseBody: true));

    FormData formData;
    List<bool> submissions = <bool>[];
    Map tempMap;
    var pathList;

    String userID = LocalStorage.localStorage.getUserID();
    String authToken = LocalStorage.localStorage.getAuthToken();

    // MyConstants.myConst.internet = true;
    if (MyConstants.myConst.internet) {
      if (MyConstants.myConst.applicationsList == null) {
        print("list is empty");
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        print(sharedPreferences.getStringList('applicationIds'));
        pathList = sharedPreferences.getStringList('applicationIds');
        MyConstants.myConst.applicationsList.forEach((id) {
          submissions.add(false);
        });
        print(
            "application id list :::: ${MyConstants.myConst.applicationsList}");
        if (MyConstants.myConst.applicationsList.isNotEmpty) {
          // MyConstants.myConst.applicationsList.removeAt(0);
          // MyConstants.myConst.applicationsList.removeAt(0);
          // MyConstants.myConst.applicationsList.removeAt(0);
          await Future.forEach(MyConstants.myConst.applicationsList,
              (appId) async {
            myMap = await getFormData(appId);
            if (myMap != null) {
              tempMap = myMap;
              log("Map key value pairings are " + myMap.toString());
              if (myMap != null || myMap.isNotEmpty) {
                FormData formData = new FormData.fromMap(myMap);
                log(myMap.toString());
                log("Only Services Linked :::: ${myMap['services_linked']}");
                // tempMap = myMap['services_linked'];

                log("FormData fields " + formData.fields.toString());
                log("FormData files " + formData.files.toString());
                try {
                  print("Inside try Response");
                  Response response = await dio.post(
                    '${MyConstants.myConst.baseUrl}api/v1/users/application_form',
                    data: formData,
                    // data: tempformData,
                    options: Options(
                      headers: {'uuid': userID, 'Authentication': authToken},
                      contentType: "*/*",
                      responseType: ResponseType.json,
                    ),
                  );
                  if (response.statusCode == 200) {
                    print("Response Data is ::: ${response.data}");

                    int applicant_id = response.data['application_id'];
                    tempMap = {
                      'application_id': applicant_id,
                      'services_linked': myMap['services_linked']
                    };
                    print("temporary Map is :::: $tempMap");
                    // update and send services
                    http.Response updateServices;
                    updateServices = await http.post(
                        Uri.parse(
                            "${MyConstants.myConst.baseUrl}api/v1/users/update_application"),
                        headers: {
                          'Content-Type': 'application/json',
                          'uuid': userID,
                          'Authentication': authToken
                        },
                        body: jsonEncode(tempMap));
                    if (updateServices.statusCode == 200) {
                      print("services updated");
                    }
                    print("Form Submitted");
                    submissions.removeLast();
                  }
                  print(response.data);
                } catch (e) {
                  print("Exception caught ::: $e");
                }

                print("yahan");
              }
            }
          });
          // .then((value) {
          //   LocalStorage.localStorage.deleteCacheDir();
          //   LocalStorage.localStorage.clearApplicationsID();
          //   print("Cache   Cleared");
          //   return true;
          // });
          LocalStorage.localStorage.deleteCacheDir();
          LocalStorage.localStorage.clearApplicationsID();
          print("Cache   Cleared");
          return true;
        }
      }
    } else {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return false;
    }
  }

  Future<Map<String, dynamic>> getFormData(String applicationId) async {
    List<MultipartFile> imgList = <MultipartFile>[];
    List<String> imagePath = <String>[];
    List listOfDecodedPaths = [];
    MultipartFile checkFile;

    Map map = Map();
    int i = 0;
    imgList = <MultipartFile>[];
    var decodeSucceeded = false;

    List<String> keys = [
      'applicant_id_proof',
      'spouse_id',
      'account_statement',
      'saps_affidavit',
      'signature'
    ];

    List<String> mulitFileKeys = [
      'death_certificate[]',
      'occupant_ids[]',
      'proof_of_incomes[]',
      'household[]',
    ];
    map = LocalStorage.localStorage.getFormData(applicationId);
    if (map.isNotEmpty) {
      print("map from sharedPref ::: $map");
      String singleFilePath;

      await Future.forEach(keys, (key) async {
        bool filesExists = false;
        MultipartFile multiPartImage;
        if (map[key] != null) {
          filesExists = await File(map[key]).exists();
        }
        try {
          if (filesExists) {
            multiPartImage =
                await MultipartFile.fromFile(map[key], filename: '$key$i.jpg');
            if (multiPartImage != null) {
              singleFilePath = map[key];
              map[key] = multiPartImage;
              print("$key is now ::::: ${map[key]}");
              i++;
              print("i is :::: $i after increment");
            }
          } else {
            print("File you are trying to convert does not exists");
          }
        } catch (e) {
          print("Exception while converting the file $e");
        }
      });

      print("not waiting");

      await Future.forEach(mulitFileKeys, (key) async {
        List<MultipartFile> listOfMultipartFile = [];
        try {
          print(map[key]);
          if (map[key] != null) {
            if (map[key].isNotEmpty) {
              listOfDecodedPaths = json.decode(map[key]);
              print("dynamic list of decoded ::: $listOfDecodedPaths");
              decodeSucceeded = true;
            }
          } else {
            print("Map you are trying to decode does not exists");
          }
        } on FormatException catch (e) {
          print('The provided string is not valid JSON');
          print(e);
          // imagePath.add(map[key]);
          MultipartFile multiPartImage;
          bool fileExists = await File(map[key]).exists();
          if (fileExists) {
            multiPartImage =
                await MultipartFile.fromFile(map[key], filename: '$key$i');
            if (multiPartImage != null) {
              listOfMultipartFile.add(multiPartImage);
              map[key] = listOfMultipartFile;
              print("Single file added ");
              print("$key is now :::: ${map[key]}");
              i++;
              print("i is ::: $i");
            }
          } else {
            print("In exception files does not exist");
          }
        }

        if (listOfDecodedPaths != null || listOfDecodedPaths.isNotEmpty) {
          await Future.forEach(listOfDecodedPaths, (path) async {
            bool fileExists = await File(path).exists();
            if (fileExists) {
              checkFile =
                  await MultipartFile.fromFile(path, filename: 'file$i');
              if (checkFile != null) {
                if (listOfDecodedPaths.length > 1) {
                  listOfMultipartFile.add(checkFile);
                  // map[key].add(checkFile);
                  print("$key is now a list ::::: ${map[key]}");
                  i++;
                  print("i is :::: $i after increment");
                } else {
                  listOfMultipartFile.add(checkFile);
                  // map[key] = checkFile;
                  print("$key is now ::::: ${map[key]}");
                  i++;
                  print("i is :::: $i after increment");
                }
                map[key] = listOfMultipartFile;
              }
            } else {
              print("Multiple Files you are trying to convert does not exists");
            }
          });
        }
        print('Decoding succeeded: $decodeSucceeded');
      });

      print("reached");
      return map;
    }
  }

  Future<void> ifInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet Available');
        //
        MyConstants.myConst.internet = true;
        print("Internet Value :::: ${MyConstants.myConst.internet}");
      } else {
        print("No internet");
        print(result);
        MyConstants.myConst.internet = false;
      }
    } on SocketException catch (_) {
      print('No Internet');
      MyConstants.myConst.internet = false;
    }
  }

  Future<int> singleFormSubmission(bool previousFormSubmitted) async {
    var dio = Dio(BaseOptions(
      connectTimeout: 90 * 1000,
    ));
    dio.interceptors.add(LogInterceptor(responseBody: true));

    String url;
    String userID = LocalStorage.localStorage.getUserID();
    String authToken = LocalStorage.localStorage.getAuthToken();
    int applicant_id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (previousFormSubmitted) {
      url = '${MyConstants.myConst.baseUrl}api/v1/users/update_application';
    } else {
      url = '${MyConstants.myConst.baseUrl}api/v1/users/application_form';
    }
    myMap = await getFormData(MyConstants.myConst.currentApplicantId);
    if (myMap != null) {
      tempMap = myMap;
      log("Map key value pairings are " + myMap.toString());
      if (myMap != null || myMap.isNotEmpty) {
        FormData formData = new FormData.fromMap(myMap);
        log("FormData fields " + formData.fields.toString());
        log("FormData files " + formData.files.toString());
        try {
          print("Inside try Response");
          Response response = await dio.post(
            url,
            data: formData,
            options: Options(
              headers: {'uuid': userID, 'Authentication': authToken},
              contentType: "*/*",
              responseType: ResponseType.json,
            ),
          );
          if (response.statusCode == 200) {
            print("Form Submitted");

            if (!previousFormSubmitted) {
              var apid;
              apid = response.data;
              sharedPreferences.setInt(
                  'applicant_id', apid['data']['application_id']);
              applicant_id = apid['application_id'];
            } else {
              sharedPreferences.setInt('applicant_id', myMap['application_id']);
              applicant_id = myMap['application_id'];
            }

            return applicant_id;
          } else {
            return null;
          }
          // print(response.data);
        } catch (e) {
          print("Exception caught ::: $e");
          return null;
        }
      }
    }
  }
}
