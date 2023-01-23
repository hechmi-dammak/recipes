// import 'package:get/get.dart';
// import 'package:recipes/models/ingredient.dart';
// import 'package:recipes/service/data_base_provider.dart';
//
// class IngredientRepository extends GetxService {
//   static IngredientRepository get find => Get.find<IngredientRepository>();
//
//   Future<Ingredient> _create(Ingredient ingredient, int? recipeId) async {
//     final id = await (await DataBaseProvider.database).insert(tableIngredients,
//         ingredient.toJson(recipeId: recipeId, withId: false, database: true));
//     return ingredient.copy(id: id);
//   }
//
//   Future<Ingredient> save(Ingredient ingredient, int? recipeId) async {
//     if (ingredient.id == null) return await _create(ingredient, recipeId);
//
//     (await DataBaseProvider.database).update(
//       tableIngredients,
//       ingredient.toJson(database: true),
//       where: '${IngredientFields.id} = ?',
//       whereArgs: [ingredient.id],
//     );
//     return ingredient;
//   }
//
//   Future<int> deleteById(int? id) async {
//     if (id == null) return 0;
//
//     return await (await DataBaseProvider.database).delete(
//       tableIngredients,
//       where: '${IngredientFields.id} = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deleteByIds(List<int?> ids) async {
//     if (ids.isEmpty) return 0;
//     return await (await DataBaseProvider.database).delete(
//       tableIngredients,
//       where: '${IngredientFields.id} in (?)',
//       whereArgs: [ids.where((id) => id != null).toList()],
//     );
//   }
//
//   Future<Ingredient?> findById(int? id) async {
//     if (id == null) return null;
//
//     final queryResult = await (await DataBaseProvider.database).query(
//       tableIngredients,
//       columns: IngredientFields.values,
//       where: '${IngredientFields.id} = ?',
//       whereArgs: [id],
//     );
//     if (queryResult.isNotEmpty) {
//       return Ingredient.fromJson(queryResult.first, database: true);
//     }
//     return null;
//   }
//
//   Future<List<Ingredient>> findAllByRecipeId(int? recipeId) async {
//     if (recipeId == null) {
//       return [];
//     }
//     final queryResult = await (await DataBaseProvider.database).query(
//       tableIngredients,
//       columns: IngredientFields.values,
//       where: '${IngredientFields.recipeId} = ?',
//       whereArgs: [recipeId],
//     );
//     return queryResult
//         .map((ingredientJson) =>
//             Ingredient.fromJson(ingredientJson, database: true))
//         .toList();
//   }
//
//   Future<List<Ingredient>> findAll() async {
//     final queryResult = await (await DataBaseProvider.database).query(
//       tableIngredients,
//       columns: IngredientFields.values,
//     );
//     return queryResult
//         .map((ingredientJson) =>
//             Ingredient.fromJson(ingredientJson, database: true))
//         .toList();
//   }
//
//   Future<int> deleteByRecipeId(int recipeId) async {
//     return await (await DataBaseProvider.database).delete(
//       tableIngredients,
//       where: '${IngredientFields.recipeId} = ?',
//       whereArgs: [recipeId],
//     );
//   }
//
//   Future<List<Ingredient>> saveAll(
//       {List<Ingredient> oldIngredients = const [],
//       required List<Ingredient> ingredients,
//       int? recipeId}) async {
//     if (oldIngredients.isNotEmpty) {
//       final List<int?> newIds =
//           ingredients.map((ingredient) => ingredient.id).toList();
//       deleteByIds(oldIngredients
//           .map((ingredient) => ingredient.id)
//           .where((id) => !newIds.contains(id))
//           .toList());
//     }
//     final List<Ingredient> result = [];
//     for (var ingredient in ingredients) {
//       result.add(await save(ingredient, recipeId));
//     }
//     return result;
//   }
// }
