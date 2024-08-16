import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesedi/forms/attachments/view/occupants/model/occupaton_model.dart';
import 'package:lesedi/network/api_data_source.dart';
import 'package:lesedi/network/app_exceptions.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OccupantViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>>? _occupantImagesData;

  List<Map<String, dynamic>>? get occupantImagesData => _occupantImagesData;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<OccupationModel> occupantData = [];

  void initMethod(List<String> loadOccupantIds) {
    for (var id in loadOccupantIds) {
      occupantData.add(OccupationModel(id: id, selectedImages: []));
    }
    print(occupantData.length);
  }

  Future<File?> imageOptionClick(ImageSource source) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> setOccupantImages(ImageSource source, int index) async {
    final imgFile = await imageOptionClick(source);

    if (imgFile != null) {
      occupantData[index].selectedImages.add(imgFile); // Add image to the list

      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Image selected for occupant ID: ${occupantData[index].id}');
    }
  }

  Future<void> postOccupation(String applicationId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var userID = sharedPreferences.getString('userID');
      var authToken = sharedPreferences.getString('auth-token');
      // Convert the occupationList to a JSON-compatible list of maps
      List<Map<String, dynamic>> occupationData =
          occupantData.map((occupation) => occupation.toJson()).toList();

      // Create the body with the key 'occupation_data'
      Map<String, dynamic> body = {
        'occupant_ids_with_images': jsonEncode(occupationData),
        "application_id": applicationId,
      };
      print('body: ${body}');

      // Prepare the files for the multipart request
      List<MapEntry<String, File>> files = [];
      for (var occupation in occupantData) {
        for (var image in occupation.selectedImages) {
          files.add(MapEntry('occupation_${occupation.id}[]', image));
        }
      }

      await NetworkApi.instance.post(
          url: '${MyConstants.myConst.baseUrl}api/v1/users/update_application',
          body: body,
          // files: files,
          customHeader: {'uuid': userID, 'Authentication': authToken});
    } on DioExceptionError catch(e) {
      Fluttertoast.showToast(msg: "Network Error: ${e.toString()}");
    }
    on BadRequestException catch (e) {
      Fluttertoast.showToast(msg: "Bad Request: ${e.toString()}");
    } on InternalServerError catch (e) {
      Fluttertoast.showToast(msg: "Server Error: ${e.toString()}");
    }
    catch (error) {
      Fluttertoast.showToast(msg: '${error.toString()}');
    } finally {
      setLoading(false);
      print('postOccupation completed');
    }
  }
}
