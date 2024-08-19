import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/forms/attachments/view/occupants/model/occupaton_model.dart';
import 'package:lesedi/network/api_data_source.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/spouse_model.dart';

class SpouseViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<SpouseModel> spouseData = [];

  void initMethod(List<String> loadSpouseIds) {
    for (var id in loadSpouseIds) {
      spouseData.add(SpouseModel(id: id, selectedImages: []));
    }
    print(spouseData.length);
  }

  Future<File?> imageOptionClick(ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> setSpouseImages(ImageSource source, int index) async {
    final imgFile = await imageOptionClick(source);

    if (imgFile != null) {
      spouseData[index].selectedImages.add(imgFile); // Add image to the list

      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Image selected for spouse ID: ${spouseData[index].id}');
    }
  }

  Future<void> postSpouse(String applicationId) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      var userID = sharedPreferences.getString('userID');
      var authToken = sharedPreferences.getString('auth-token');
      for (var spouse in spouseData) {

        spouse.isUploading = true;
        notifyListeners();

        Map<String, dynamic> body = {
          "application_id": applicationId,
          "spouse_id": spouse.id
        };

        List<File> allFiles = [];
        for (var image in spouse.selectedImages) {
          allFiles.add(image);
        }

        MapEntry<String, List<File>> files = MapEntry('files[]', allFiles);

        // Post request with NetworkApi
        await NetworkApi.instance.post(
          url: '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
          body: body,
          files: files,
          customHeader: {
            'uuid': userID,
            'Authentication': authToken,
          },
        );

        spouse.isUploading = false;
        spouse.isUploaded = true;
        notifyListeners();
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '${error.toString()}');
      for (var spouse in spouseData) {
        spouse.isUploading = false;
        notifyListeners();
      }
    }
  }
}