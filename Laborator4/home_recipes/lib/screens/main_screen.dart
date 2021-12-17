import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';

import 'package:home_recipes/models/recipe_item.dart';
import 'package:home_recipes/screens/add_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  RecipeService? recipeService;

  MainScreen({
    Key? key,
    this.recipeService,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Recipes"),
        backgroundColor: UtilsColors.darkGreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddScreen(recipeService: widget.recipeService)));
        },
        child: const Icon(
          Icons.add,
          size: 50,
        ),
        backgroundColor: UtilsColors.darkGreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(25),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: Provider.of<RecipeModelItems>(context)
                  .items
                  .map(
                    (data) => RecipeItem(
                      data.id,
                      data.title,
                      data.image,
                      widget.recipeService!,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
