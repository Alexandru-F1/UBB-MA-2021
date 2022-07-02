import 'package:flutter/material.dart';
import 'package:home_recipes/screens/recipe_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';

class RecipeItem extends StatefulWidget {
  final String id;
  final String recipeName;
  final FileImage? image;
  RecipeService recipeService;

  RecipeItem(this.id, this.recipeName, this.image, this.recipeService);

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ImageProvider<Object> defaultImage =
        AssetImage("assets/images/img_test.jpg");

    if (widget.image != null) {
      defaultImage = widget.image as ImageProvider<Object>;
    }

    return Container(
      width: size.width * 0.4,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeScreen(
                                  recipe: widget.recipeService
                                      .findRecipeById(widget.id),
                                  recipeService: widget.recipeService,
                                )))
                    .then((value) => setState(() {}))
                    .then((value) => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: defaultImage,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: FractionallySizedBox(
              child: Container(
                child: Center(child: Text(widget.recipeName)),
              ),
            ),
            decoration: BoxDecoration(
              color: UtilsColors.greyGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
