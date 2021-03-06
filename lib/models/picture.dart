import 'dart:typed_data';

const String tablePictures = 'pictures';

class PictureFields {
  static final List<String> values = [id, image];
  static const String id = '_id';
  static const String image = 'image';
}

class Picture {
  int? id;
  Uint8List? image;

  Picture({this.id, this.image});

  factory Picture.fromDatabaseJson(Map map) => Picture(
        id: map[PictureFields.id],
        image: map[PictureFields.image],
      );

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        id: json[PictureFields.id] as int?,
        image: json[PictureFields.image] != null
            ? Uint8List.fromList(json[PictureFields.image].codeUnits)
            : null,
      );

  Map<String, dynamic> toDatabaseJson([bool noId = false]) => {
        PictureFields.id: noId ? null : id,
        PictureFields.image: image,
      };

  Map<String, dynamic> toJson() => {
        PictureFields.id: id,
        PictureFields.image:
            image == null ? null : String.fromCharCodes(image!),
      };

  Picture copy({int? id, Uint8List? image}) => Picture(
        id: id ?? this.id,
        image: image ?? this.image,
      );
}
