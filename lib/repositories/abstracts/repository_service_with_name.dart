import 'package:flutter/material.dart';
import 'package:mekla/helpers/isar_extension.dart';
import 'package:mekla/models/interfaces/model_name.dart';
import 'package:mekla/repositories/abstracts/repository_service.dart';
import 'package:mekla/services/isar_service.dart';

abstract class RepositoryServiceWithName<T extends ModelName>
    extends RepositoryService<T> {
  Future<List<T>> findAllByNameStartWith(String name) async {
    return await IsarService.isar
        .collection<T>()
        .filter()
        .nameStartsWith(name)
        .findAll();
  }

  Future<List<T>> findAllByNameEqualTo(String name) async {
    return await IsarService.isar
        .collection<T>()
        .filter()
        .nameEqualTo(name.trim(), caseSensitive: false)
        .findAll();
  }

  Future<String> getUniqueNameFrom(String name) async {
    final setOfNames = (await findAllByNameStartWith(name))
        .map((element) => element.name)
        .toSet();
    if (!setOfNames.contains(name)) return name;
    var index = 1;
    while (setOfNames.contains('${name}_$index')) {
      index++;
    }
    name += '_$index';
    return name;
  }

  @protected
  Future<void> replaceWithSameName(T element) async {
    final List<T> elements = await findAllByNameEqualTo(element.name);
    if (elements.isNotEmpty) {
      final T tmpElement = elements.first;
      if (element.id == tmpElement.id) return;
      if (element.id != null) {
        await replaceTmpItemValues(element, tmpElement);
        saveInternal(tmpElement);
        deleteById(element.id);
      }
      element.id = tmpElement.id;
      await replaceOriginalItemValues(element, tmpElement);
    }
  }

  Future<void> replaceOriginalItemValues(T original, T tmp);

  Future<void> replaceTmpItemValues(T original, T tmp);
}
