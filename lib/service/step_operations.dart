import 'package:recipes/models/step.dart';
import 'package:recipes/service/database.dart';

class StepOperations {
  static final StepOperations instance = StepOperations._init();
  StepOperations._init();

  final dbProvider = DataBaseRepository.instance;
  Future<Step> create(Step step, int? recipeId) async {
    final db = await dbProvider.database;

    final id = await db.insert(tableSteps, step.toDatabaseJson(recipeId));
    return step.copy(id: id);
  }

  Future<Step> read(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query(
      tableSteps,
      columns: StepFields.values,
      where: '${StepFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Step.fromDatabaseJson(maps.first);
    }
    return Step();
  }

  Future<int> update(Step step) async {
    final db = await dbProvider.database;

    return db.update(
      tableSteps,
      step.toJson(),
      where: '${StepFields.id} = ?',
      whereArgs: [step.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;

    return await db.delete(
      tableSteps,
      where: '${StepFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Step>> readAllByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    List<Step> steps = [];
    final maps = await db.query(
      tableSteps,
      columns: StepFields.values,
      where: '${StepFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
    if (maps.isNotEmpty) {
      for (var step in maps) {
        steps.add(Step.fromDatabaseJson(step));
      }
    }
    return steps;
  }

  Future<List<Step>> readAll() async {
    final db = await dbProvider.database;
    List<Step> steps = [];
    final maps = await db.query(
      tableSteps,
      columns: StepFields.values,
    );
    if (maps.isNotEmpty) {
      for (var step in maps) {
        steps.add(Step.fromDatabaseJson(step));
      }
    }
    return steps;
  }

  Future<int> deleteByRecipeId(int recipeId) async {
    final db = await dbProvider.database;

    return await db.delete(
      tableSteps,
      where: '${StepFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<Step>> createAll(List<Step>? steps, int? recipeId) async {
    if (steps == null || steps.isEmpty) return [];
    final db = await dbProvider.database;
    final List<Step> result = [];
    for (var step in steps) {
      step.id = null;
      final id = await db.insert(tableSteps, step.toDatabaseJson(recipeId));
      result.add(step.copy(id: id));
    }
    return result;
  }
}
