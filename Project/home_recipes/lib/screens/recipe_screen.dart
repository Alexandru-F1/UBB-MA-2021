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

  Future<int> deleteRecipe(int id) async {
    await Future.delayed(const Duration(milliseconds: 4));
    return recipeService!.deleteRecipe(id);
  }

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  _RecipeScreenState();

  Future<int>? recipeDeleted;

  void delete() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete a recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');

              try {
                setState(() {
                  recipeDeleted = widget.deleteRecipe(widget.recipe!.id);
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Wait'),
                    actions: [
                      recipeDeleted == null
                          ? const Text('Wait')
                          : FutureBuilder<int>(
                              future: recipeDeleted,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      const Text("The recipe was deleted successfully.\nPres Ok to close."),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          Provider.of<RecipeModelItems>(context, listen: false).delete(widget.recipe!.id);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Column(children: [
                                    Text('Delivery error: ${snapshot.error.toString()}'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ]);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                    ],
                  ),
                );
              } on Exception catch (ex) {
                var error = ex.toString();
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('An error has occurred'),
                    content: Text(error),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Ok'),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              }
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
  }

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<RecipeModelItems>(context).findRecipeByID(widget.recipe!.id);
    if (a != null) {
      widget.recipe = a;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe!.recipeName),
        backgroundColor: Utilitys.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  var recipeScreen = MainScreen(recipeService: widget.recipeService);
                  return recipeScreen;
                },
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: " + widget.recipe!.time),
                      const SizedBox(height: 20.0),
                      Text("Difficulty: " + widget.recipe!.difficulty),
                      const SizedBox(height: 20.0),
                      Text("Calories: " + widget.recipe!.calories.toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const Text("Ingredients", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(widget.recipe!.ingredients),
              const SizedBox(height: 30.0),
              const Text("Cooking Specifications", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(widget.recipe!.cookingSpecifications),
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
                    builder: (context) => ModifyScreen(recipe: widget.recipe, recipeService: widget.recipeService),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
              child: const Text("   Edit   ", style: TextStyle(color: Colors.white, fontSize: 20)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utilitys.darkGreen)),
            ),
            const SizedBox(width: 50),
            TextButton(
              onPressed: () {
                if (!Utilitys.internetConnection) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Warning!"),
                      content: const Text("Aplicatia nu este conectata la internet, stergerea va fi facuta local."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Ok');
                            delete();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  );
                } else {
                  delete();
                }
              },
              child: const Text(" Delete ", style: TextStyle(color: Colors.white, fontSize: 20)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utilitys.darkGreen)),
            ),
          ],
        ),
      ),
    );
  }
}
