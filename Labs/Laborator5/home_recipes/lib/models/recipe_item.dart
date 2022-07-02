import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/screens/recipe_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:provider/provider.dart';

class RecipeItem extends StatefulWidget {
  final int id;
  final String recipeName;
  RecipeService recipeService;

  RecipeItem(this.id, this.recipeName, this.recipeService, {Key? key}) : super(key: key);

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ImageProvider<Object> defaultImage = const AssetImage("assets/images/img_test.jpg");

    return SizedBox(
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
                              recipe: Provider.of<RecipeModelItems>(context, listen: false).findRecipeByID(widget.id),
                              recipeService: widget.recipeService,
                            ))).then((value) => setState(() {})).then((value) => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  image: DecorationImage(image: defaultImage, fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: FractionallySizedBox(
              child: Center(child: Text(widget.recipeName)),
            ),
            decoration: const BoxDecoration(
              color: Utilitys.greyGreen,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
            ),
          ),
        ],
      ),
    );
  }
}
