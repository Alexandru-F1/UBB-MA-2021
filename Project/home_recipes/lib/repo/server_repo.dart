import 'dart:async';
import 'package:home_recipes/models/recipe.dart';
import 'package:home_recipes/repo/i_repo.dart';
import 'package:home_recipes/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeRepoServer implements IRepo {
  @override
  Future<Recipe> add(Recipe recipe) async {
    final response = await http.post(Uri.parse(Utilitys.url + "/recipe"), body: recipe.toJson());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var body = json.decode(response.body);
      return Recipe.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load recipe.');
    }
  }

  @override
  Future<int> delete(int id) async {
    final response = await http.delete(Uri.parse(Utilitys.url + "/recipe/" + id.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return 1;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete recipe.');
    }
  }

  @override
  Future<Recipe> findById(int id) async {
    final response = await http.get(Uri.parse(Utilitys.url + "/recipe/" + id.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var body = json.decode(response.body);
      return Recipe.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load recipe.');
    }
  }

  @override
  Future<List<Recipe>> getAll() async {
    List<Recipe> recipes = [];
    final response = await http.get(Uri.parse(Utilitys.url + "/recipes"));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var body = json.decode(response.body);
      for (var item in body) {
        recipes.add(Recipe.fromJson(item));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return recipes;
  }

  @override
  Future<int> modify(Recipe recipe) async {
    final response = await http.patch(Uri.parse(Utilitys.url + "/recipe"), body: recipe.toJsonWithId());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return 1;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load recipe.');
    }
  }
}
