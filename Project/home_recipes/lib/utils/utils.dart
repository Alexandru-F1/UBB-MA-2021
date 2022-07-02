import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/services/recipe_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Utilitys {
  static const darkGreen = Color.fromRGBO(64, 99, 67, 1);
  static const greyGreen = Color.fromRGBO(199, 207, 183, 0.8);
  static int idNumber = 0;
  static String root = "";
  static String url = "http://192.168.0.174:2018";
  static String url_ws = "ws://192.168.0.174:2018";
  static bool internetConnection = false;
  static bool loadOnlyOnce = false;
  static bool wasCopied = false;
}
