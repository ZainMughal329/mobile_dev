import 'dart:io';

class SpouseModel {
  String id;
  List<File> selectedImages;

  SpouseModel({required this.selectedImages, required this.id});

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