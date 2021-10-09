import 'package:path/path.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/step.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static final DataBaseRepository instance = DataBaseRepository._init();

  static Database? _database;
  static const int _databaseVersion = 1;
  DataBaseRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recipes_book.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _createDB,
        onConfigure: _onConfigure);
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
          ${RecipeFields.steps} $textType,
          ${RecipeFields.category} $textType
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
          ${IngredientFields.recipeId} $integerType,
          FOREIGN KEY (${IngredientFields.recipeId}) REFERENCES $tableRecipes ( ${RecipeFields.id}) 
        )
    ''');
    await db.execute('''
        CREATE TABLE $tableSteps ( 
          ${StepFields.id} $idType, 
          ${StepFields.order} $integerType,
          ${StepFields.toDo} $textType,
          ${StepFields.recipeId} $integerType,
          FOREIGN KEY (${IngredientFields.recipeId}) REFERENCES $tableRecipes ( ${RecipeFields.id}) 
        )
    ''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
