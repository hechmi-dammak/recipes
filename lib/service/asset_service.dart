import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetService extends GetxService {
  static AssetService get find => Get.find<AssetService>();

  static Map<String, ImageProvider> get assets =>
      Get.find<AssetService>()._assets;

  final Map<String, ImageProvider> _assets = <String, ImageProvider>{};

  final List<String> _imageAssetsPath = [
    'assets/icons_png/back_arrow_icon.png',
    'assets/icons_png/big_plus_icon.png',
    'assets/icons_png/camera_icon.png',
    'assets/icons_png/cancel_icon.png',
    'assets/icons_png/category_icon.png',
    'assets/icons_png/confirm_icon.png',
    'assets/icons_png/deselect_all_icon.png',
    'assets/icons_png/down_arrow_icon.png',
    'assets/icons_png/edit_icon.png',
    'assets/icons_png/gallery_icon.png',
    'assets/icons_png/hat_icon.png',
    'assets/icons_png/info_icon.png',
    'assets/icons_png/menu_icon.png',
    'assets/icons_png/plus_icon.png',
    'assets/icons_png/portions_icon.png',
    'assets/icons_png/scale_icon.png',
    'assets/icons_png/select_all_icon.png',
    'assets/icons_png/settings_icon.png',
    'assets/icons_png/share_icon.png',
    'assets/icons_png/trash_icon.png',
    'assets/icons_png/up_arrow_icon.png',
    'assets/icons_png/used_icon.png',
  ];

  Future<void> init() async {
    Future.wait(_imageAssetsPath.map(
        (asset) => precache(asset.split('/').last.split('.').first, asset)));
  }

  Future<void> precache(String name, String asset) async {
    _assets[name] = AssetImage(asset);
    await precacheImage(_assets[name]!, Get.context!);
  }
}
