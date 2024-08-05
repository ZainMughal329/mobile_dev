import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttachmentsNotifier extends ChangeNotifier {
  ServicesRequest request = ServicesRequest();
  Location location = new Location();
  File? image;
  final picker = ImagePicker();

  String? fileName;
  String? path;
  Map<String, String>? paths;
  String? extension;
  bool loadingPath = false;
  bool multiPick = false;
  bool hasValidMime = false;
  FileType? pickingType;
  String? profileType;
  TextEditingController controller = new TextEditingController();
  bool isLoadingSecondary = false;
  bool isLoading = false;
  int? applicant_id;
  bool? _coordinatesLoading = false;
  var lat = '';
  var lng = '';
  LocationData? _locationData;

  var employment_status;
  var spouse_id;
  var dependent_ids;
  var applicant_id_proof;
  var proof_of_income;
  var account_statement;
  var saps_affidavit;

  var attachmentOfId;

  setLoading(bool val){
    isLoading=val;
    notifyListeners();
  }

  void updateProfileWithResume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? auth_token = sharedPreferences.getString('token');
  }

  checkInternetAvailability() async {
    await request.ifInternetAvailable();
    notifyListeners();
  }

  getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    lat = _locationData?.latitude.toString() ?? "";
    lng = _locationData?.longitude.toString() ?? "";
    notifyListeners();

    print('coordinates loading: ${_coordinatesLoading}');
    print('location holdeer');
    print(_locationData?.latitude);
  }

  init(){

    controller.addListener(() => extension = controller.text);
    checkInternetAvailability();
    getLocation();
  }
}
