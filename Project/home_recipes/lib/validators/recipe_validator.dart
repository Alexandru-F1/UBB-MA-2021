import 'package:home_recipes/models/recipe.dart';

class RecipeValidator {
  String recipeValidator(Recipe recipe) {
    String errors = "";

    if (recipe.recipeName.isEmpty) {
      errors += "Recipe Name field is empty!\n";
    }
    if (recipe.ingredients.isEmpty) {
      errors += "Ingredients field is empty!\n";
    }
    if (recipe.cookingSpecifications.isEmpty) {
      errors += "Cooking Specifications field is empty!\n";
    }
    if (recipe.time.isEmpty) {
      errors += "Time field is empty!\n";
    }
    if (recipe.difficulty.isEmpty) {
      errors += "Difficulty field is empty!\n";
    }
    if (recipe.calories < 0) {
      errors += "Calories field is empty!\n";
    }
    return errors;
  }
}
