import 'dart:typed_data';

import 'package:isar/isar.dart';

part 'picture.g.dart';

@collection
class Picture {
  Id? id;
  List<int> image;

  @ignore
  Uint8List get memoryImage => Uint8List.fromList(image);

  Picture({
    required this.image,
  });
}
