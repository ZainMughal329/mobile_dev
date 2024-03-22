import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/common_services/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttachmentsNotifier extends ChangeNotifier {
  ServicesRequest request = ServicesRequest();
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

  init(){

    controller.addListener(() => extension = controller.text);
    checkInternetAvailability();
  }
}
