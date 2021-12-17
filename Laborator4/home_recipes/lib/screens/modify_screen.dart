import 'dart:io';

import 'package:flutter/material.dart';

import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/input_fields.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyScreen extends StatefulWidget {
  Recipe? recipe;
  RecipeService? recipeService;

  ModifyScreen({
    Key? key,
    this.recipe,
    this.recipeService,
  }) : super(key: key);

  @override
  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  var myRecipeNameModifyController = TextEditingController();
  var myIngredientsModifyController = TextEditingController();
  var myCookingModifyController = TextEditingController();
  var myTimeModifyController = TextEditingController();
  var myDifficultyModifyController = TextEditingController();
  var myCaloriesModifyController = TextEditingController();

  Future<XFile?>? imageFile;
  FileImage? image;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker().pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<XFile?>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          var filePath = snapshot.data!.path;
          image = FileImage(File(filePath));
          return Image.file(
            File(filePath),
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Recipe"),
        backgroundColor: UtilsColors.darkGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputFields.inputField(
                "Recipe name",
                "Recipe name",
                TextInputType.text,
                myRecipeNameModifyController,
                widget.recipe!.recipeName,
              ),
              const SizedBox(
                height: 20.0,
              ),
              InputFields.inputField(
                "Ingredients",
                "Ingredients",
                TextInputType.text,
                myIngredientsModifyController,
                widget.recipe!.ingredients,
              ),
              const SizedBox(
                height: 20.0,
              ),
              InputFields.inputField(
                "Cooking specifications",
                "Cooking specifications",
                TextInputType.text,
                myCookingModifyController,
                widget.recipe!.cookingSpecifications,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputFields.inputField(
                      "Time",
                      "Time",
                      TextInputType.text,
                      myTimeModifyController,
                      widget.recipe!.time,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: InputFields.inputField(
                      "Difficulty",
                      "Difficulty",
                      TextInputType.text,
                      myDifficultyModifyController,
                      widget.recipe!.difficulty,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: InputFields.inputField(
                      "Calories",
                      "Calories",
                      TextInputType.number,
                      myCaloriesModifyController,
                      widget.recipe!.calories.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              showImage(),
              TextButton(
                child: const Text(
                  "  Select Image from Gallery  ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onPressed: () {
                  pickImageFromGallery(ImageSource.gallery);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(UtilsColors.greyGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Edit a recipe'),
                      content:
                          const Text('Are you sure you want to edit a recipe?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Yes');
                            try {
                              FileImage? a;
                              if (image == null) {
                                a = widget.recipe!.image;
                              } else {
                                a = image;
                              }

                              var recip = widget.recipeService!.modifyRecipe(
                                  widget.recipe!.id,
                                  myRecipeNameModifyController.text,
                                  myIngredientsModifyController.text,
                                  myCookingModifyController.text,
                                  myTimeModifyController.text,
                                  myDifficultyModifyController.text,
                                  a,
                                  double.parse(
                                      myCaloriesModifyController.text));
                              Navigator.pop(context);
                              Provider.of<RecipeModelItems>(context,
                                      listen: false)
                                  .modify(recip);
                            } on Exception catch (ex) {
                              var error = ex.toString();
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('An error has occurred'),
                                  content: Text(error),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
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
                },
                child: const Text(
                  "    Save    ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(UtilsColors.darkGreen),
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
