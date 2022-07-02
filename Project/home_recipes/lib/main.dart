import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:home_recipes/repo/i_repo.dart';
import 'package:home_recipes/repo/recipe_repo_db.dart';
import 'package:home_recipes/repo/server_repo.dart';
import 'package:home_recipes/screens/main_screen.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:home_recipes/validators/recipe_validator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/recipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //static RecipeRepo recipeRepo = RecipeRepo();
  static RecipeRepoDB recipeRepoDB = RecipeRepoDB();
  static RecipeRepoServer recipeRepo = RecipeRepoServer();
  static RecipeValidator recipeValidator = RecipeValidator();
  static RecipeModelItems recipeModelItems = RecipeModelItems();
  static RecipeService recipeService = RecipeService(recipeModelItems: recipeModelItems, recipeRepo: recipeRepo, recipeRepoDB: recipeRepoDB, recipeValidator: recipeValidator);

  const MyApp({Key? key}) : super(key: key);

  Future<void> copyInDB() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    //avem net
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
      List<Recipe> recipesDB = await recipeService.recipeRepoDB?.getAll();
      List<Recipe> recipesServer = await recipeService.recipeRepo?.getAll();
      for (var item in recipesDB) {
        recipeRepoDB.delete(item.id);
      }
      for (var item in recipesServer) {
        final a = await recipeRepoDB.add(item);
        //print(item.id.toString() + " --- " + r.id.toString());
      }
    } else {
      print("NU am avut net");
    }
  }

  void sync() async {
    List<Recipe> recipesDB = await recipeService.recipeRepoDB?.getAll();
    List<Recipe> recipesServer = await recipeService.recipeRepo?.getAll();

    var sizeDB = recipesDB.length;
    var sizeServer = recipesServer.length;

    for (int i = 0; i < sizeDB; i++) {
      for (int j = 0; j < sizeServer; j++) {
        //modify
        if (recipesDB[i].id == recipesServer[j].id &&
            (recipesDB[i].ingredients != recipesServer[j].ingredients ||
                recipesDB[i].calories != recipesServer[j].calories ||
                recipesDB[i].cookingSpecifications != recipesServer[j].cookingSpecifications ||
                recipesDB[i].time != recipesServer[j].time ||
                recipesDB[i].difficulty != recipesServer[j].difficulty)) {
          recipeService.recipeRepo?.modify(recipesDB[i]);
        }
      }
    }
    for (int i = 0; i < sizeDB; i++) {
      if (!recipesServer.contains(recipesDB[i])) {
        recipeService.recipeRepo?.add(recipesDB[i]);
      }
    }
    for (int i = 0; i < sizeServer; i++) {
      if (!recipesDB.contains(recipesServer[i])) {
        recipeService.recipeRepo?.delete(recipesServer[i].id);
      }
    }

    recipeService.m();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    StreamSubscription<ConnectivityResult> subscription;
    copyInDB().then((value) {
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          // ignore: avoid_print
          print("Internet connection is inactive.");
          Utilitys.internetConnection = false;
          recipeService.m();
        } else {
          // ignore: avoid_print

          print("Internet connection is active.");
          Utilitys.internetConnection = true;
          sync();
        }
      });
    });
    return ChangeNotifierProvider.value(
      value: recipeModelItems,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainScreen(recipeService: recipeService),
      ),
    );
  }
}
