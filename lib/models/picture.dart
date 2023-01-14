import 'dart:typed_data';

const String tablePictures = 'pictures';

class PictureFields {
  static final List<String> values = [id, image];
  static const String id = '_id';
  static const String image = 'image';
}

class Picture {
  int? id;
  String? uuid;
  Uint8List? image;

  Picture({
    this.id,
    this.uuid,
    this.image,
  });

  static Picture fromJson(
    Map<String, dynamic> json, {
    bool database = false,
  }) {
    final picture = Picture(
      id: json[PictureFields.id],
      image: json[PictureFields.image],
    );
    if (json[PictureFields.image] != null) {
      if (database) {
        picture.image = json[PictureFields.image];
      } else {
        picture.image = Uint8List.fromList(json[PictureFields.image].codeUnits);
      }
    }
    return picture;
  }

  Map<String, dynamic> toJson({
    bool database = false,
    bool withId = true,
  }) =>
      {
        if (!database || withId) PictureFields.id: id,
        if (!database && image != null)
          PictureFields.image: String.fromCharCodes(image!),
        if (database && image != null) PictureFields.image: image,
      };

  Picture copy({
    int? id,
    Uint8List? image,
  }) =>
      Picture(
        id: id ?? this.id,
        image: image ?? this.image,
      );
}
