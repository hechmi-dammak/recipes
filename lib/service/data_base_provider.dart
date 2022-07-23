import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider extends GetxService {
  static DataBaseProvider get find => Get.find<DataBaseProvider>();

  static Future<Database> get database async {
    final dataBaseRepository = DataBaseProvider.find;
    dataBaseRepository._database = dataBaseRepository._database ??
        await dataBaseRepository._initDB('recipes_book.db');
    return dataBaseRepository._database!;
  }

  Database? _database;
  final int _databaseVersion = 1;

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _createDB,
        onConfigure: _onConfigure);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const integerType = 'INTEGER';
    const realType = 'REAL';
    const blobType = 'BLOB';
    await db.execute('''
        CREATE TABLE $tablePictures ( 
          ${PictureFields.id} $idType, 
          ${PictureFields.image} $blobType
        )
    ''');
    await db.execute('''
        CREATE TABLE $tableRecipes ( 
          ${RecipeFields.id} $idType, 
          ${RecipeFields.name} $textType,
          ${RecipeFields.category} $textType,
          ${RecipeFields.servings} $integerType,
          ${RecipeFields.pictureId} $integerType,
          FOREIGN KEY (${RecipeFields.pictureId}) REFERENCES $tablePictures ( ${PictureFields.id})
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
        CREATE TABLE $tableInstructions ( 
          ${InstructionFields.id} $idType, 
          ${InstructionFields.order} $integerType,
          ${InstructionFields.toDo} $textType,
          ${InstructionFields.recipeId} $integerType,
          FOREIGN KEY (${IngredientFields.recipeId}) REFERENCES $tableRecipes ( ${RecipeFields.id}) 
        )
    ''');
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    (await database).close();
  }
}
