class OccupantAndSpouseModel {
  List<OccupantIdsWithImages>? occupantIdsWithImages;
  List<SpouseIdsWithImages>? spouseIdsWithImages;

  OccupantAndSpouseModel({
    this.occupantIdsWithImages,
    this.spouseIdsWithImages,
  });

  OccupantAndSpouseModel.fromJson(Map<String, dynamic> json) {
    if (json['occupant_ids_with_images'] != null) {
      occupantIdsWithImages = <OccupantIdsWithImages>[];
      json['occupant_ids_with_images'].forEach((v) {
        occupantIdsWithImages!.add(new OccupantIdsWithImages.fromJson(v));
      });
    }
    if (json['spouse_ids_with_images'] != null) {
      spouseIdsWithImages = <SpouseIdsWithImages>[];
      json['spouse_ids_with_images'].forEach((v) {
        spouseIdsWithImages!.add(new SpouseIdsWithImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.occupantIdsWithImages != null) {
      data['occupant_ids_with_images'] =
          this.occupantIdsWithImages!.map((v) => v.toJson()).toList();
    }
    if (this.spouseIdsWithImages != null) {
      data['spouse_ids_with_images'] =
          this.spouseIdsWithImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OccupantIdsWithImages {
  String? id;
  List<String>? selectedImages;

  OccupantIdsWithImages({this.id, this.selectedImages});

  OccupantIdsWithImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selectedImages = json['selectedImages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['selectedImages'] = this.selectedImages;
    return data;
  }
}

class SpouseIdsWithImages {
  String? id;
  List<String>? selectedImages;

  SpouseIdsWithImages({this.id, this.selectedImages});

  SpouseIdsWithImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selectedImages = json['selectedImages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['selectedImages'] = this.selectedImages;
    return data;
  }
}
