import 'package:flutter/material.dart';

import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/screens/main_screen.dart';
import 'package:home_recipes/screens/modify_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatefulWidget {
  Recipe? recipe;
  RecipeService? recipeService;

  RecipeScreen({
    Key? key,
    this.recipe,
    this.recipeService,
  }) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState(
        recipe: recipe,
        recipeService: recipeService,
      );
}

class _RecipeScreenState extends State<RecipeScreen> {
  Recipe? recipe;
  RecipeService? recipeService;

  _RecipeScreenState({
    this.recipe,
    this.recipeService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe!.recipeName,
        ),
        backgroundColor: UtilsColors.darkGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(70),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: recipe!.image!,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: " + recipe!.time),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Difficulty: " + recipe!.difficulty),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Calories: " + recipe!.calories.toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(recipe!.ingredients),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Cooking Specifications",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(recipe!.cookingSpecifications),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: 70,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ModifyScreen(
                              recipe: recipe,
                              recipeService: recipeService,
                            ))).then((value) => setState(() {}));
              },
              child: const Text(
                "   Edit   ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(UtilsColors.darkGreen),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            TextButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete a recipe'),
                    content: const Text(
                        'Are you sure you want to delete this recipe?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Yes');
                          Navigator.pop(context);
                          recipeService!.deleteRecipe(recipe!.id);
                          Provider.of<RecipeModelItems>(context, listen: false)
                              .delete(recipe!.id);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'No');
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                " Delete ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(UtilsColors.darkGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
