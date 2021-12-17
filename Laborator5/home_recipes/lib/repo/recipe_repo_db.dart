import 'dart:async';
import 'dart:io' as io;
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/repo/i_repo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class RecipeRepoDB implements IRepo {
  static Database? _db;
  static const String iD = "id";
  static const String recipeName = "recipeName";
  static const String ingredients = "ingredients";
  static const String cookingSpec = "cookingSpecifications";
  static const String time = "time";
  static const String difficulty = "difficulty";
  static const String calories = "calories";
  static const String table = "Recipes";
  static const String dbName = "recipes9.db";

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ($iD INTEGER PRIMARY KEY AUTOINCREMENT, $recipeName TEXT, $ingredients TEXT,$cookingSpec TEXT,$time TEXT,$difficulty TEXT, $calories REAL)");
  }

  @override
  Future<Recipe> add(Recipe recipe) async {
    var dbClient = await db;
    recipe.id = await dbClient!.insert(table, recipe.toMap());
    return recipe;
  }

  @override
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(table, where: '$iD = ?', whereArgs: [id]);
  }

  @override
  Future<Recipe> findById(int id) async {
    var dbClient = await db;
    String query = "SELECT * FROM " + table + " WHERE id = " + id.toString();
    var a = await dbClient!.rawQuery(query, null);
    var b = Recipe.fromMap(a.first);
    return b;
  }

  @override
  Future<List<Recipe>> getAll() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query(table, columns: [iD, recipeName, ingredients, cookingSpec, time, difficulty, calories]);

    List<Recipe> recipes = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        recipes.add(Recipe.fromMap(maps[i]));
      }
    }
    return recipes;
  }

  @override
  Future<int> modify(Recipe recipe) async {
    var dbClient = await db;
    return await dbClient!.update(table, recipe.toMap(), where: '$iD = ?', whereArgs: [recipe.id]);
  }
}
