// import 'package:get/get.dart';
// import 'package:recipes/models/instruction.dart';
// import 'package:recipes/service/data_base_provider.dart';
//
// class InstructionRepository extends GetxService {
//   static InstructionRepository get find => Get.find<InstructionRepository>();
//
//   Future<Instruction> _create(Instruction instruction, int? recipeId) async {
//     final id = await (await DataBaseProvider.database).insert(tableInstructions,
//         instruction.toJson(recipeId: recipeId, withId: false, database: true));
//     return instruction.copy(id: id);
//   }
//
//   Future<Instruction> save(Instruction instruction, int? recipeId) async {
//     if (instruction.id == null) return await _create(instruction, recipeId);
//
//     (await DataBaseProvider.database).update(
//       tableInstructions,
//       instruction.toJson(database: true),
//       where: '${InstructionFields.id} = ?',
//       whereArgs: [instruction.id],
//     );
//     return instruction;
//   }
//
//   Future<int> deleteById(int? id) async {
//     if (id == null) return 0;
//
//     return await (await DataBaseProvider.database).delete(
//       tableInstructions,
//       where: '${InstructionFields.id} = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deleteByIds(List<int?> ids) async {
//     if (ids.isEmpty) return 0;
//     return await (await DataBaseProvider.database).delete(
//       tableInstructions,
//       where: '${InstructionFields.id} in (?)',
//       whereArgs: [ids.where((id) => id != null).toList()],
//     );
//   }
//
//   Future<Instruction?> findById(int? id) async {
//     if (id == null) return null;
//     final queryResult = await (await DataBaseProvider.database).query(
//       tableInstructions,
//       columns: InstructionFields.values,
//       where: '${InstructionFields.id} = ?',
//       whereArgs: [id],
//     );
//     if (queryResult.isNotEmpty) {
//       return Instruction.fromJson(queryResult.first, database: true);
//     }
//     return null;
//   }
//
//   Future<List<Instruction>> findAllByRecipeId(int? recipeId) async {
//     if (recipeId == null) {
//       return [];
//     }
//     final queryResult = await (await DataBaseProvider.database).query(
//         tableInstructions,
//         columns: InstructionFields.values,
//         where: '${InstructionFields.recipeId} = ?',
//         whereArgs: [recipeId],
//         orderBy: InstructionFields.order);
//     return queryResult
//         .map((instructionJson) =>
//             Instruction.fromJson(instructionJson, database: true))
//         .toList();
//   }
//
//   Future<List<Instruction>> findAll() async {
//     final queryResult = await (await DataBaseProvider.database).query(
//       tableInstructions,
//       columns: InstructionFields.values,
//     );
//     return queryResult
//         .map((instructionJson) =>
//             Instruction.fromJson(instructionJson, database: true))
//         .toList();
//   }
//
//   Future<int> deleteByRecipeId(int? recipeId) async {
//     if (recipeId == null) return 0;
//
//     return await (await DataBaseProvider.database).delete(
//       tableInstructions,
//       where: '${InstructionFields.recipeId} = ?',
//       whereArgs: [recipeId],
//     );
//   }
//
//   Future<List<Instruction>> saveAll(
//       {List<Instruction> oldInstructions = const [],
//       required List<Instruction> instructions,
//       int? recipeId}) async {
//     if (oldInstructions.isNotEmpty) {
//       final List<int?> newIds =
//           instructions.map((instruction) => instruction.id).toList();
//       deleteByIds(oldInstructions
//           .map((instruction) => instruction.id)
//           .where((id) => !newIds.contains(id))
//           .toList());
//     }
//     final List<Instruction> result = [];
//     for (var instruction in instructions) {
//       result.add(await save(instruction, recipeId));
//     }
//     return result;
//   }
// }
