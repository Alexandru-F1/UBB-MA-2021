import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/input_fields.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  RecipeService? recipeService;

  AddScreen({
    Key? key,
    this.recipeService,
  }) : super(key: key);

  Future<Recipe> addRecipe(String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) async {
    await Future.delayed(const Duration(milliseconds: 4));
    return recipeService!.addRecipe(recipeName, ingredients, cookingSpecifications, time, difficulty, calories);
  }

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var myRecipeNameController = TextEditingController();
  var myIngredientsController = TextEditingController();
  var myCookingController = TextEditingController();
  var myTimeController = TextEditingController();
  var myDifficultyController = TextEditingController();
  var myCaloriesController = TextEditingController();

  _AddScreenState();

  Future<Recipe>? recipeAdded;

  void add() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a recipe'),
        content: const Text('Are you sure you want to add a recipe?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');
              try {
                setState(() {
                  recipeAdded = widget.addRecipe(
                      myRecipeNameController.text, myIngredientsController.text, myCookingController.text, myTimeController.text, myDifficultyController.text, double.parse(myCaloriesController.text));
                });
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Wait'),
                    actions: [
                      recipeAdded == null
                          ? const Text('Wait')
                          : FutureBuilder<Recipe>(
                              future: recipeAdded,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      const Text("The recipe was added successfully.\nPres Ok to close."),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Provider.of<RecipeModelItems>(context, listen: false).add(snapshot.data!.id, myRecipeNameController.text, myIngredientsController.text,
                                              myCookingController.text, myTimeController.text, myDifficultyController.text, double.parse(myCaloriesController.text));
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
                              },
                            )
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        backgroundColor: Utilitys.darkGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputFields.inputField("Recipe name", "Recipe name", TextInputType.text, myRecipeNameController, ""),
              const SizedBox(height: 20.0),
              InputFields.inputField("Ingredients", "Ingredients", TextInputType.text, myIngredientsController, ""),
              const SizedBox(height: 20.0),
              InputFields.inputField("Cooking specifications", "Cooking specifications", TextInputType.text, myCookingController, ""),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: InputFields.inputField("Time", "Time", TextInputType.text, myTimeController, ""),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: InputFields.inputField("Difficulty", "Difficulty", TextInputType.text, myDifficultyController, ""),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: InputFields.inputField("Calories", "Calories", TextInputType.number, myCaloriesController, ""),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              TextButton(
                onPressed: () {
                  if (!Utilitys.internetConnection) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Warning!"),
                        content: const Text("Aplicatia nu este conectata la internet, adaugarea va fi facuta local."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Ok');
                              add();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    add();
                  }
                },
                child: const Text(
                  "    Add    ",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Utilitys.darkGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
