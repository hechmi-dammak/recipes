import 'package:path/path.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe.dart';
import 'package:sqflite/sqflite.dart';

class RecipeRepository {
  static final RecipeRepository instance = RecipeRepository._init();

  static Database? _database;

  RecipeRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recipes_book.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const integerType = 'INTEGER';
    const realType = 'REAL';

    await db.execute('''
CREATE TABLE $tableRecipes ( 
  ${RecipeFields.id} $idType, 
  ${RecipeFields.name} $textType,
  ${RecipeFields.category} $textType,
  )
''');
    await db.execute('''
CREATE TABLE $tableIngredients ( 
  ${IngredientFields.id} $idType, 
  ${IngredientFields.name} $textType,
  ${IngredientFields.category} $textType,
  ${IngredientFields.quantity} $realType,
  ${IngredientFields.measuring} $textType,
  ${IngredientFields.size} $textType,
  ${IngredientFields.method} $textType,
  ${IngredientFields.recipe_id} $integerType,
  FOREIGN KEY ${IngredientFields.recipe_id}) REFERENCES $tableRecipes ( ${RecipeFields.id}) 
  )
''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Recipe> create(Recipe recipe) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipes, recipe.toJson());
    return recipe.copy(id: id);
  }

  Future<Recipe> readRecipe(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      Recipe recipe = Recipe.fromJson(maps.first);

      return recipe;
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
