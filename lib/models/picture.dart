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
}
