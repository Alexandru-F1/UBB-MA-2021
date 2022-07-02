import 'package:flutter/cupertino.dart';
import 'package:home_recipes/repo/i_repo.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/validators/recipe_validator.dart';

class RecipeModelItem {
  int id;
  Image image = Image.asset("assets/images/img_test.jpg");
  String recipeName;
  String ingredients = "";
  String cookingSpecifications = "";
  String time = "";
  String difficulty = "";
  double calories = -1;

  RecipeModelItem({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.cookingSpecifications,
    required this.time,
    required this.difficulty,
    required this.calories,
  });
}

class RecipeModelItems with ChangeNotifier {
  List<RecipeModelItem> items = [];

  void add(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    print("add 1111111111111");
    items.add(RecipeModelItem(id: id, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories));
    notifyListeners();
  }

  void delete(int id) {
    items.removeWhere((element) => element.id == id);
    print("delete 1111111111111");
    notifyListeners();
  }

  void modify(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    print("modify 1111111111111");
    var item = items.where((element) => element.id == id).first;
    item.recipeName = recipeName;
    item.ingredients = ingredients;
    item.cookingSpecifications = cookingSpecifications;
    item.calories = calories;
    item.time = time;
    item.difficulty = difficulty;
    notifyListeners();
  }

  Recipe? findRecipeByID(int id) {
    try {
      var itemss = items.where((element) => element.id == id);
      RecipeModelItem? item = null;
      if (itemss.isNotEmpty) {
        item = itemss.first;
      }

      if (item == null) {
        return null;
      } else {
        return Recipe(
            id: item.id,
            recipeName: item.recipeName,
            ingredients: item.ingredients,
            cookingSpecifications: item.cookingSpecifications,
            time: item.time,
            difficulty: item.difficulty,
            calories: item.calories);
      }
    } on Exception {
      return null;
    }
  }

  List<RecipeModelItem> getAll() {
    notifyListeners();
    return items;
  }

  void setAll(List<RecipeModelItem> recipes) {
    items.clear();
    items = recipes;
    notifyListeners();
  }
}

class RecipeService with ChangeNotifier {
  IRepo? recipeRepo;
  RecipeValidator? recipeValidator;

  List<Recipe> recipes = [];

  RecipeService({this.recipeRepo, this.recipeValidator});

  Future<Recipe> addRecipe(String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    var recipe = Recipe(id: -1, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories);
    var errors = recipeValidator!.recipeValidator(recipe);

    if (errors == "") {
      return recipeRepo!.add(recipe);
    } else {
      throw Exception(errors);
    }
  }

  Future<int> deleteRecipe(int id) {
    return recipeRepo!.delete(id);
  }

  Future<int> modifyRecipe(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    var recipe = Recipe(id: id, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories);
    var errors = recipeValidator!.recipeValidator(recipe);

    if (errors == "") {
      return recipeRepo!.modify(recipe);
    } else {
      throw Exception(errors);
    }
  }

  List<Recipe> getAllRecipes() {
    return recipeRepo!.getAll();
  }

  Future<Recipe> findRecipeById(int id) {
    return recipeRepo!.findById(id);
  }
}
