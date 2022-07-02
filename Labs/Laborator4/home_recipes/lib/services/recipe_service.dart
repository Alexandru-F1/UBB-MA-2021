import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/repo/recipe_repo.dart';
import 'package:home_recipes/validators/recipe_validator.dart';

class RecipeModelItem {
  String id;
  FileImage? image;
  String title;

  RecipeModelItem({
    required this.id,
    required this.title,
    required this.image,
  });
}

class RecipeModelItems with ChangeNotifier {
  List<RecipeModelItem> items = [];

  void add(String id, String recipeName, FileImage image) {
    items.add(RecipeModelItem(
      id: id,
      title: recipeName,
      image: image,
    ));
    print("add");
    notifyListeners();
  }

  void delete(String id) {
    items.removeWhere((element) => element.id == id);
    print("delete");
    notifyListeners();
  }

  void modify(Recipe recipe) {
    var item = items.where((element) => element.id == recipe.id).first;
    item.title = recipe.recipeName;
    item.image = recipe.image;
    print("modify");
    notifyListeners();
  }

  List<RecipeModelItem> getAll() {
    notifyListeners();
    print("get");
    return items;
  }
}

class RecipeService with ChangeNotifier {
  RecipeRepo? recipeRepo;
  RecipeValidator? recipeValidator;
  RecipeModelItems recipeModelItems = RecipeModelItems();

  RecipeService({
    this.recipeRepo,
    this.recipeValidator,
  });

  String addRecipe(
      String recipeName,
      String ingredients,
      String cookingSpecifications,
      String time,
      String difficulty,
      FileImage? image,
      double calories) {
    var id = const Uuid().v1();

    var recipe = Recipe(
      id: id,
      recipeName: recipeName,
      ingredients: ingredients,
      cookingSpecifications: cookingSpecifications,
      time: time,
      difficulty: difficulty,
      image: image,
      calories: calories,
    );

    var errors = recipeValidator!.recipeValidator(recipe);
    if (errors == "") {
      recipeRepo!.add(recipe);
    } else {
      throw Exception(errors);
    }
    return id;
  }

  String deleteRecipe(String id) {
    recipeRepo!.delete(id);
    return id;
  }

  Recipe modifyRecipe(
      String id,
      String recipeName,
      String ingredients,
      String cookingSpecifications,
      String time,
      String difficulty,
      FileImage? image,
      double calories) {
    var recipe = Recipe(
      id: id,
      recipeName: recipeName,
      ingredients: ingredients,
      cookingSpecifications: cookingSpecifications,
      time: time,
      difficulty: difficulty,
      image: image,
      calories: calories,
    );

    var errors = recipeValidator!.recipeValidator(recipe);
    if (errors == "") {
      recipeRepo!.modify(recipe);
    } else {
      throw Exception(errors);
    }
    return recipe;
  }

  List<Recipe> getAllRecipes() {
    return recipeRepo!.getAll();
  }

  Recipe findRecipeById(String id) {
    return recipeRepo!.findById(id);
  }

  List<RecipeModelItem> getAllRecipeItem() {
    return recipeModelItems.getAll();
  }
}
