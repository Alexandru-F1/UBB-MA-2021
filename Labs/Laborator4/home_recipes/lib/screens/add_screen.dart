import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  _AddScreenState createState() => _AddScreenState(
        recipeService: recipeService,
      );
}

class _AddScreenState extends State<AddScreen> {
  var myRecipeNameController = TextEditingController();
  var myIngredientsController = TextEditingController();
  var myCookingController = TextEditingController();
  var myTimeController = TextEditingController();
  var myDifficultyController = TextEditingController();
  var myCaloriesController = TextEditingController();
  RecipeService? recipeService;

  Future<XFile?>? imageFile;
  FileImage? image;

  _AddScreenState({
    this.recipeService,
  });

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
        title: const Text("Add Recipe"),
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
                myRecipeNameController,
                "",
              ),
              const SizedBox(
                height: 20.0,
              ),
              InputFields.inputField(
                "Ingredients",
                "Ingredients",
                TextInputType.text,
                myIngredientsController,
                "",
              ),
              const SizedBox(
                height: 20.0,
              ),
              InputFields.inputField(
                "Cooking specifications",
                "Cooking specifications",
                TextInputType.text,
                myCookingController,
                "",
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
                      myTimeController,
                      "",
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
                      myDifficultyController,
                      "",
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
                      myCaloriesController,
                      "",
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
                      title: const Text('Add a recipe'),
                      content:
                          const Text('Are you sure you want to add a recipe?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Yes');
                            try {
                              var id = recipeService!.addRecipe(
                                  myRecipeNameController.text,
                                  myIngredientsController.text,
                                  myCookingController.text,
                                  myTimeController.text,
                                  myDifficultyController.text,
                                  image,
                                  double.parse(myCaloriesController.text));
                              Navigator.pop(context);
                              Provider.of<RecipeModelItems>(context,
                                      listen: false)
                                  .add(id, myRecipeNameController.text, image!);
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
                  "    Add    ",
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
