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

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeName = json['recipeName'];
    ingredients = json['ingredients'];
    cookingSpecifications = json['cookingSpecifications'];
    time = json['time'];
    difficulty = json['difficulty'];
    calories = double.parse(json['calories']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'recipeName': recipeName,
      'ingredients': ingredients,
      'cookingSpecifications': cookingSpecifications,
      'time': time,
      'difficulty': difficulty,
      'calories': calories.toString(),
    };
    return map;
  }

  Map<String, dynamic> toJsonWithId() {
    var map = <String, dynamic>{
      'id': id.toString(),
      'recipeName': recipeName,
      'ingredients': ingredients,
      'cookingSpecifications': cookingSpecifications,
      'time': time,
      'difficulty': difficulty,
      'calories': calories.toString(),
    };
    return map;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Recipe && other.recipeName == recipeName && other.ingredients == ingredients && other.calories == calories && other.time == time;
  }
}
