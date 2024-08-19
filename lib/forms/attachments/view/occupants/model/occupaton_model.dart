import 'dart:io';

class OccupantModel {
  String id;
  List<File> selectedImages;
  bool isUploading = false;
  bool isUploaded = false;

  OccupantModel({required this.selectedImages, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selectedImages': selectedImages.map((image) => image.path).toList(),
    };
  }
  Map<String, dynamic> toJsonName() {
    return {
      'id': id,
      'selectedImages': selectedImages.map((image) => image.path.split('/').last).toList(),
    };
  }
}