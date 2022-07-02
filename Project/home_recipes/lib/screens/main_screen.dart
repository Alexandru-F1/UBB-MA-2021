import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';

import 'package:home_recipes/models/recipe_item.dart';
import 'package:home_recipes/screens/add_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  void initState() {
    super.initState();
    if (!Utilitys.loadOnlyOnce) {
      _loadData();
      Utilitys.loadOnlyOnce = true;
    }
  }

  _loadData() async {
    Directory root = await getTemporaryDirectory();
    Utilitys.root = root.path;

    List<Recipe> recipes = await widget.recipeService!.getAllRecipes();

    var recipeModelItems = recipes
        .map((data) => RecipeModelItem(
              id: data.id,
              recipeName: data.recipeName,
              calories: data.calories,
              cookingSpecifications: data.cookingSpecifications,
              difficulty: data.difficulty,
              ingredients: data.ingredients,
              time: data.time,
            ))
        .toList();
    Provider.of<RecipeModelItems>(context, listen: false).setAll(recipeModelItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Recipes"),
        backgroundColor: Utilitys.darkGreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen(recipeService: widget.recipeService)));
        },
        child: const Icon(Icons.add, size: 50),
        backgroundColor: Utilitys.darkGreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(25),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20),
              children: Provider.of<RecipeModelItems>(context).items.map((data) => RecipeItem(data.id, data.recipeName, widget.recipeService!)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
