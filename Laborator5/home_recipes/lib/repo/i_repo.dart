import 'package:home_recipes/models/recipe.dart';

abstract class IRepo<T1, T2, T3> {
  T2? add(Recipe recipe) {}
  T3? delete(int id) {}
  T3? modify(Recipe recipe) {}
  T1? getAll() {}
  T2? findById(int id) {}
}
