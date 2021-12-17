import 'package:home_recipes/models/recipe.dart';

class RecipeRepo {
  final List<Recipe> _recipes = [];

  void add(Recipe recipe) {
    _recipes.add(recipe);
  }

  void delete(String id) {
    _recipes.removeWhere((element) => element.id == id);
  }

  void modify(Recipe recipe) {
    var currentRecipe =
        _recipes.where((element) => element.id == recipe.id).first;
    currentRecipe.recipeName = recipe.recipeName;
    currentRecipe.ingredients = recipe.ingredients;
    currentRecipe.cookingSpecifications = recipe.cookingSpecifications;
    currentRecipe.time = recipe.time;
    currentRecipe.difficulty = recipe.difficulty;
    currentRecipe.image = recipe.image;
    currentRecipe.calories = recipe.calories;
  }

  List<Recipe> getAll() {
    return _recipes;
  }

  Recipe findById(String id) {
    return _recipes.where((element) => element.id == id).first;
  }
}
