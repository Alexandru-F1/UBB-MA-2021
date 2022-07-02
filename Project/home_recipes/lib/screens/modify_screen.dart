import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/input_fields.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:provider/provider.dart';

class ModifyScreen extends StatefulWidget {
  Recipe? recipe;
  RecipeService? recipeService;

  ModifyScreen({Key? key, this.recipe, this.recipeService}) : super(key: key);

  Future<int> modifyRecipe(int id, String recipeName, String ingredients, String cookingSpecifications, String time, String difficulty, double calories) async {
    await Future.delayed(const Duration(milliseconds: 4));
    return recipeService!.modifyRecipe(id, recipeName, ingredients, cookingSpecifications, time, difficulty, calories);
  }

  @override
  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  var myIngredientsModifyController = TextEditingController();
  var myCookingModifyController = TextEditingController();
  var myTimeModifyController = TextEditingController();
  var myDifficultyModifyController = TextEditingController();
  var myCaloriesModifyController = TextEditingController();

  Future<int>? recipeModified;

  void modify() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit a recipe'),
        content: const Text('Are you sure you want to edit a recipe?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');

              try {
                setState(() {
                  recipeModified = widget.modifyRecipe(widget.recipe!.id, widget.recipe!.recipeName, myIngredientsModifyController.text, myCookingModifyController.text, myTimeModifyController.text,
                      myDifficultyModifyController.text, double.parse(myCaloriesModifyController.text));
                });
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Wait'),
                    actions: [
                      recipeModified == null
                          ? const Text('Wait')
                          : FutureBuilder<int>(
                              future: recipeModified,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      const Text("The recipe was modified successfully.\nPres Ok to close."),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<RecipeModelItems>(context, listen: false).modify(widget.recipe!.id, widget.recipe!.recipeName, myIngredientsModifyController.text,
                                              myCookingModifyController.text, myTimeModifyController.text, myDifficultyModifyController.text, double.parse(myCaloriesModifyController.text));
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
        title: const Text("Edit Recipe"),
        backgroundColor: Utilitys.darkGreen,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context, widget.recipe);
        //     },
        //   ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputFields.inputField("Ingredients", "Ingredients", TextInputType.text, myIngredientsModifyController, widget.recipe!.ingredients),
              const SizedBox(height: 20.0),
              InputFields.inputField("Cooking specifications", "Cooking specifications", TextInputType.text, myCookingModifyController, widget.recipe!.cookingSpecifications),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(child: InputFields.inputField("Time", "Time", TextInputType.text, myTimeModifyController, widget.recipe!.time)),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Difficulty", "Difficulty", TextInputType.text, myDifficultyModifyController, widget.recipe!.difficulty)),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Calories", "Calories", TextInputType.number, myCaloriesModifyController, widget.recipe!.calories.toString())),
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
                        content: const Text("Aplicatia nu este conectata la internet, modificarea va fi facuta local."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Ok');
                              modify();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    modify();
                  }
                },
                child: const Text(
                  "    Save    ",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Utilitys.darkGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
