import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/service/isar_service.dart';

abstract class RepositoryService<T> extends GetxService {
  Future<T> save(T element) async {
    await IsarService.isar
        .writeTxn(() async => await IsarService.isar.collection<T>().put(element));
    return element;
  }

  Future<T?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.collection<T>().get(id);
  }

  Future<List<T>> findAll() async {
    return await IsarService.isar.collection<T>().where().findAll();
  }


  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    if (!await beforeDelete(id)) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.collection<T>().delete(id));
  }

  Future<bool> beforeDelete(int id) async{
    return true;
  }
}
