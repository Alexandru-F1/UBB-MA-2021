import 'package:flutter/material.dart';

class RecipeModelItem {
  final String id;
  final String recipeName;
  final FileImage image;

  RecipeModelItem({
    required this.id,
    required this.recipeName,
    required this.image,
  });
}

class Recipe {
  final String id;
  String recipeName;
  String ingredients;
  String cookingSpecifications;
  String time;
  String difficulty;
  FileImage? image;
  double calories;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.cookingSpecifications,
    required this.time,
    required this.difficulty,
    required this.image,
    required this.calories,
  });
}
