import 'dart:typed_data';

import 'package:isar/isar.dart';

part 'picture.g.dart';

@collection
class Picture {
  Id? id;
  Uint8List image;

  Picture({
    this.id,
    required this.image,
  });

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'image': image.toList(),
    };
  }

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
      id: map['id'],
      image: Uint8List.fromList(map['image'].cast<int>()),
    );
  }
}
