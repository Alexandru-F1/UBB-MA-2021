class Recipe {
  int id = -1;
  String recipeName = "";
  String ingredients = "";
  String cookingSpecifications = "";
  String time = "";
  String difficulty = "";
  double calories = -1;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.cookingSpecifications,
    required this.time,
    required this.difficulty,
    required this.calories,
  });

  Recipe.empty({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.cookingSpecifications,
    required this.time,
    required this.difficulty,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'recipeName': recipeName,
      'ingredients': ingredients,
      'cookingSpecifications': cookingSpecifications,
      'time': time,
      'difficulty': difficulty,
      'calories': calories,
    };
    return map;
  }

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    recipeName = map['recipeName'];
    ingredients = map['ingredients'];
    cookingSpecifications = map['cookingSpecifications'];
    time = map['time'];
    difficulty = map['difficulty'];
    calories = map['calories'];
  }
}
