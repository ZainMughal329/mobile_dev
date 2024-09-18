import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:lesedi/forms/attachments/view/occupants/model/occupaton_model.dart';
import 'package:lesedi/network/api_data_source.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OccupantViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<OccupantModel> occupantData = [];

  void initMethod(List<String> loadOccupantIds) {
    for (var id in loadOccupantIds) {
      occupantData.add(OccupantModel(id: id, selectedImages: []));
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

  Future<File?> compressImage(File image) async {
    // Read the image file as bytes
    List<int> imageBytes = await image.readAsBytes();
    Uint8List uint8List = Uint8List.fromList(imageBytes);
    img.Image originalImage = img.decodeImage(uint8List)!;

    // Original size
    int originalSize = imageBytes.length;
    print('Original size: ${originalSize / 1024} KB');

    // Initial compression parameters
    int quality = 100; // Start with the best quality
    int minQuality = 70; // Minimum quality to maintain (70%)
    File? compressedFile;

    // Loop until the quality reaches the minimum or less
    while (quality >= minQuality) {
      List<int> compressedBytes = img.encodeJpg(originalImage, quality: quality);
      compressedFile = File(image.path)..writeAsBytesSync(compressedBytes);

      // Compressed size
      int compressedSize = compressedFile.lengthSync();
      print('Compressed size at quality $quality: ${compressedSize / 1024} KB');

      // Break if we have successfully compressed it
      if (compressedSize < originalSize) {
        break;
      }

      quality -= 10; // Decrease quality in steps of 10%
    }

    // If still larger than original, return the compressed file
    if (compressedFile != null && compressedFile.lengthSync() < originalSize) {
      return compressedFile;
    } else {
      print('Unable to compress the image adequately.');
      return image; // Return the original if no adequate compression was possible
    }
  }



  Future<void> setOccupantImages(ImageSource source, int index) async {
    final imgFile = await imageOptionClick(source);
    if (imgFile != null) {
      File? compressedImage = await compressImage(imgFile);
      if (compressedImage != null) {
        occupantData[index].selectedImages.add(compressedImage); // Add optimized image to the list
        notifyListeners();
        Fluttertoast.showToast(
            msg: 'Image selected for occupant ID: ${occupantData[index].id}');
      } else {
        Fluttertoast.showToast(msg: 'Failed to compress image.');
      }
    }
  }

  Future<void> postOccupant(String applicationId) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var userID = sharedPreferences.getString('userID');
      var authToken = sharedPreferences.getString('auth-token');
      for (var occupant in occupantData) {
        occupant.isUploading = true;
        notifyListeners();

        Map<String, dynamic> body = {
          "application_id": applicationId,
          "occupant_id": occupant.id
        };

        List<File> allFiles = [];
        for (var image in occupant.selectedImages) {
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

        occupant.isUploading = false;
        occupant.isUploaded = true;
        notifyListeners();
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '${error.toString()}');
      for (var occupant in occupantData) {
        occupant.isUploading = false;
        notifyListeners();
      }
    }
  }
}
