import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_recipes/repo/i_repo.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:home_recipes/validators/recipe_validator.dart';
import 'package:connectivity/connectivity.dart';

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
    items.add(RecipeModelItem(id: id, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories));
    notifyListeners();
  }

  void delete(int id) {
    items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void modify(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
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
      RecipeModelItem? item;
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
  IRepo? recipeRepoDB;
  RecipeValidator? recipeValidator;
  RecipeModelItems? recipeModelItems;

  List<Recipe> recipes = [];

  RecipeService({this.recipeModelItems, this.recipeRepo, this.recipeRepoDB, this.recipeValidator});

  void m() async {
    List<Recipe> recipes = await getAllRecipes();

    var recipeModelItemsd = recipes
        .map((data) => RecipeModelItem(
              id: data.id,
              recipeName: data.recipeName,
              calories: data.calories,
              cookingSpecifications: data.cookingSpecifications,
              difficulty: data.difficulty,
              ingredients: data.ingredients,
              time: data.time,
            ))
        .toList();
    recipeModelItems?.setAll(recipeModelItemsd);
  }

  Future<Recipe> addRecipe(String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    var recipe = Recipe(id: -1, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories);
    var errors = recipeValidator!.recipeValidator(recipe);

    if (errors == "") {
      if (Utilitys.internetConnection) {
        print("Add in Server");
        recipeRepoDB!.add(recipe);
        return recipeRepo!.add(recipe);
      } else {
        print("Add in DB");
        return recipeRepoDB!.add(recipe);
      }
    } else {
      throw Exception(errors);
    }
  }

  Future<int> deleteRecipe(int id) {
    if (Utilitys.internetConnection) {
      print("Delete in server: " + id.toString());
      recipeRepoDB!.delete(id);
      return recipeRepo!.delete(id);
    } else {
      print("Delete in DB: " + id.toString());
      return recipeRepoDB!.delete(id);
    }
  }

  Future<int> modifyRecipe(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) {
    var recipe = Recipe(id: id, recipeName: recipeName, ingredients: ingredients, cookingSpecifications: cookingSpecifications, time: time, difficulty: difficulty, calories: calories);
    var errors = recipeValidator!.recipeValidator(recipe);

    if (errors == "") {
      if (Utilitys.internetConnection) {
        print("Modify in Server");
        recipeRepoDB!.modify(recipe);
        return recipeRepo!.modify(recipe);
      } else {
        print("Modify in DB");
        return recipeRepoDB!.modify(recipe);
      }
    } else {
      throw Exception(errors);
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    if (Utilitys.internetConnection) {
      print("GetAll in server");
      return recipeRepo!.getAll();
    } else {
      print("GetAll in DB");
      return recipeRepoDB!.getAll();
    }
  }

  Future<Recipe> findRecipeById(int id) {
    if (Utilitys.internetConnection) {
      return recipeRepo!.findById(id);
    } else {
      return recipeRepoDB!.findById(id);
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
