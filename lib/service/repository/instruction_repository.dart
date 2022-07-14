import 'package:get/get.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/service/data_base_provider.dart';

class InstructionRepository extends GetxService {
  static InstructionRepository get find => Get.find<InstructionRepository>();

  Future<Instruction> create(Instruction instruction, int? recipeId) async {

    final id = await (await DataBaseProvider.database).insert(tableInstructions, instruction.toDatabaseJson(recipeId, true));
    return instruction.copy(id: id);
  }

  Future<Instruction?> read(int? id) async {
    if (id == null) return null;
    final maps = await (await DataBaseProvider.database).query(
      tableInstructions,
      columns: InstructionFields.values,
      where: '${InstructionFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Instruction.fromDatabaseJson(maps.first);
    }
    return Instruction();
  }

  Future<Instruction> update(Instruction instruction, int? recipeId) async {
    if (instruction.id == null) return await create(instruction, recipeId);

    (await DataBaseProvider.database).update(
      tableInstructions,
      instruction.toJson(),
      where: '${InstructionFields.id} = ?',
      whereArgs: [instruction.id],
    );
    return instruction;
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;

    return await (await DataBaseProvider.database).delete(
      tableInstructions,
      where: '${InstructionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Instruction>> readAllByRecipeId(int? recipeId) async {
    if (recipeId == null) return [];
    final List<Instruction> instructions = [];
    final maps = await (await DataBaseProvider.database).query(tableInstructions,
        columns: InstructionFields.values,
        where: '${InstructionFields.recipeId} = ?',
        whereArgs: [recipeId],
        orderBy: InstructionFields.order);
    if (maps.isNotEmpty) {
      for (var instruction in maps) {
        instructions.add(Instruction.fromDatabaseJson(instruction));
      }
    }
    return instructions;
  }

  Future<List<Instruction>> readAll() async {
    final List<Instruction> instructions = [];
    final maps = await (await DataBaseProvider.database).query(
      tableInstructions,
      columns: InstructionFields.values,
    );
    if (maps.isNotEmpty) {
      for (var instruction in maps) {
        instructions.add(Instruction.fromDatabaseJson(instruction));
      }
    }
    return instructions;
  }

  Future<int> deleteByRecipeId(int? recipeId) async {
    if (recipeId == null) return 0;

    return await (await DataBaseProvider.database).delete(
      tableInstructions,
      where: '${InstructionFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> deleteByRecipeIds(List<int?> recipeIds) async {
    recipeIds.removeWhere((element) => element == null);
    return await (await DataBaseProvider.database).delete(
      tableInstructions,
      where: '${InstructionFields.recipeId} in (?)',
      whereArgs: [recipeIds],
    );
  }

  Future<List<Instruction>> createAll(List<Instruction>? instructions, int? recipeId) async {
    if (instructions == null || instructions.isEmpty) return [];
    final List<Instruction> result = [];
    for (var instruction in instructions) {
      instruction.id = null;
      final id =
          await (await DataBaseProvider.database).insert(tableInstructions, instruction.toDatabaseJson(recipeId, true));
      result.add(instruction.copy(id: id));
    }
    return result;
  }

  Future<List<Instruction>> updateAll(List<Instruction>? instructions, int? recipeId) async {
    final List<Instruction> result = [];
    if (instructions == null || instructions.isEmpty) return result;
    await (await DataBaseProvider.database).transaction((txn) async {
      for (var instruction in instructions) {
        if (instruction.id == null) {
          final id =
              await txn.insert(tableInstructions, instruction.toDatabaseJson(recipeId, true));
          result.add(instruction.copy(id: id));
        } else {
          txn.update(
            tableInstructions,
            instruction.toDatabaseJson(recipeId),
            where: '${InstructionFields.id} = ?',
            whereArgs: [instruction.id],
          );
          result.add(instruction);
        }
      }
    });
    return result;
  }
}
