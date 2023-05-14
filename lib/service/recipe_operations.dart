import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:content_resolver/content_resolver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekla/models/recipe.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/service/logger_service.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/create_file_name_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class RecipeOperations extends GetxService {
  static RecipeOperations get find => Get.find<RecipeOperations>();

  Future<void> init() async {
    await initDeepLinks();
  }

  Future<void> requestStoragePermissions() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> exportToFile(
      {required List<Map<String, dynamic>> recipes,
      AsyncCallback? onStart,
      AsyncCallback? onSuccess,
      AsyncCallback? onFailure,
      AsyncCallback? onFinish}) async {
    onStart?.call();
    await UpsertElementDialog<CreateFileNameController>(
      controller: CreateFileNameController(onConfirm: (String fileName) async {
        try {
          await requestStoragePermissions();
          final String? fileDirectory = await FilePicker.platform
              .getDirectoryPath(dialogTitle: 'Select where to save to file');
          if (fileDirectory == null) {
            CustomSnackBar.warning('You must choose a directory');
            return;
          }
          final fileLocation = '$fileDirectory/$fileName.recipe';
          File file = File(fileLocation);
          file = await file.writeAsString(json.encode(recipes), flush: true);
          CustomSnackBar.success('Recipes are exported to file $fileName.');
          LoggerService.logger
              ?.i('Recipes are exported to file $fileLocation.');
          onSuccess?.call();
        } catch (e) {
          CustomSnackBar.error('Failed to export to file $e');
          onFailure?.call();
        }
      }),
    ).show(false);
    onFinish?.call();
  }

  Future<void> shareAsFile(
      {required List<Map<String, dynamic>> recipes,
      AsyncCallback? onStart,
      AsyncCallback? onSuccess,
      AsyncCallback? onFailure,
      AsyncCallback? onFinish}) async {
    onStart?.call();
    await UpsertElementDialog<CreateFileNameController>(
      controller: CreateFileNameController(onConfirm: (String fileName) async {
        try {
          await requestStoragePermissions();
          final tempDir = await getTemporaryDirectory();
          final fileLocation = '${tempDir.path}/$fileName.recipe';
          final file = File(fileLocation);
          await file.writeAsString(json.encode(recipes), flush: true);
          Get.back();
          await Share.shareXFiles([XFile(file.path)],
              subject: 'Share your Recipes');

          CustomSnackBar.success('Recipes file $fileName were shared.');
          onSuccess?.call();
        } catch (e) {
          CustomSnackBar.error('Failed to share file$e');
          onFailure?.call();
        }
      }),
    ).show(false);
    onFinish?.call();
  }

  Future<void> importFromFile(
      {AsyncCallback? onStart,
      AsyncCallback? onSuccess,
      AsyncCallback? onFailure,
      AsyncCallback? onFinish}) async {
    try {
      await onStart?.call();
      await requestStoragePermissions();
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null ||
          result.count == 0 ||
          !result.files.single.path!.endsWith('.recipe')) {
        CustomSnackBar.error('You must pick a recipe file.');
        onFailure?.call();
        return;
      }
      final content = await File(result.files.single.path!).readAsString();
      await saveRecipesFromFileContent(content: content, onSuccess: onSuccess);
    } catch (e) {
      CustomSnackBar.error('Failed to  import from file$e');
      onFailure?.call();
    }
    onFinish?.call();
  }

  Future<void> importFromLibrary(
      {AsyncCallback? onStart,
      AsyncCallback? onSuccess,
      AsyncCallback? onFailure,
      AsyncCallback? onFinish}) async {
    try {
      await onStart?.call();
      final String content = await rootBundle.loadString('assets/recipes.json');
      await saveRecipesFromFileContent(content: content, onSuccess: onSuccess);
    } catch (e) {
      CustomSnackBar.error('Failed to  import from file $e');
      onFailure?.call();
    }
    onFinish?.call();
  }

  Future<void> saveRecipesFromFileContent(
      {required String content,
      AsyncCallback? onStart,
      AsyncCallback? onSuccess,
      AsyncCallback? onFailure,
      AsyncCallback? onFinish}) async {
    try {
      await onStart?.call();
      final data = await json.decode(content);
      for (var item in data as List) {
        await RecipeRepository.find.save(await Recipe.fromMap(item));
      }
      CustomSnackBar.success('Recipes are imported.');
      onSuccess?.call();
    } catch (error, stackTrace) {
      CustomSnackBar.error('Failed to import from file');
      LoggerService.logger?.errorStackTrace(error, stackTrace);
      onFailure?.call();
    }
    onFinish?.call();
  }

  Future<void> initDeepLinks() async {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      _openAppLink(uri);
    });

    final appLink = await appLinks.getInitialAppLink();
    if (appLink != null) {
      _openAppLink(appLink);
    }
  }

  void _openAppLink(Uri uri) async {
    try {
      final uriStr = uri.toString().replaceFirst(
          'content://com.slack.fileprovider/',
          'content://com.Slack.fileprovider/');
      var content = '';
      try {
        final contentEncoded = await ContentResolver.resolveContent(uriStr);
        content = String.fromCharCodes(contentEncoded.data);
      } catch (e) {
        try {
          content = await File(uri.path).readAsString();
        } catch (e) {
          content = await File(uri.path.split('external').last).readAsString();
        }
      }

      await saveRecipesFromFileContent(
          content: content,
          onSuccess: () async {
            try {
              await RecipesController.find.fetchData();
            } catch (error) {
              LoggerService.logger?.i('failed to refresh recipes $error');
            }
          });
    } catch (e) {
      CustomSnackBar.error('Failed to open to file $e');
    }
  }
}
