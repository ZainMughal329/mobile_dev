import 'dart:io';

class OccupationModel {
  String id;
  List<File> selectedImages;

  OccupationModel({required this.selectedImages, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selectedImages': selectedImages.map((image) => image.path).toList(),
    };
  }
}