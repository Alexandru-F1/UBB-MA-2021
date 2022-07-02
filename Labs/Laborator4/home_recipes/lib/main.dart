import 'package:flutter/material.dart';
import 'package:home_recipes/repo/recipe_repo.dart';
import 'package:home_recipes/screens/main_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/validators/recipe_validator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static RecipeRepo recipeRepo = RecipeRepo();
  static RecipeValidator recipeValidator = RecipeValidator();

  static RecipeService recipeService = RecipeService(
    recipeRepo: recipeRepo,
    recipeValidator: recipeValidator,
  );

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: RecipeModelItems(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(recipeService: recipeService),
      ),
    );
  }
}
