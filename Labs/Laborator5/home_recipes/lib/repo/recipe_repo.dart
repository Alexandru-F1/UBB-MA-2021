import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/repo/i_repo.dart';

class RecipeRepo implements IRepo {
  final List<Recipe> _recipes = [];

  @override
  void add(Recipe recipe) {
    _recipes.add(recipe);
  }

  @override
  void delete(int id) {
    _recipes.removeWhere((element) => element.id == id);
  }

  @override
  void modify(Recipe recipe) {
    var currentRecipe = _recipes.where((element) => element.id == recipe.id).first;
    currentRecipe.recipeName = recipe.recipeName;
    currentRecipe.ingredients = recipe.ingredients;
    currentRecipe.cookingSpecifications = recipe.cookingSpecifications;
    currentRecipe.time = recipe.time;
    currentRecipe.difficulty = recipe.difficulty;
    currentRecipe.calories = recipe.calories;
  }

  @override
  List<Recipe> getAll() {
    return _recipes;
  }

  @override
  Recipe findById(int id) {
    return _recipes.where((element) => element.id == id).first;
  }
}
