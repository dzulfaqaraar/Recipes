import 'package:recipes/model/ingredient.dart';

class Menu {
  String name;
  String image;
  List<Ingredient>? ingredients = [];
  List<String>? instructions = [];

  Menu({
    required this.name,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        name: json["name"],
        image: json["image"],
        ingredients: json["ingredients"] == null
            ? null
            : List<Ingredient>.from(json["ingredients"].map(
                (x) => Ingredient.fromJson(x),
              )),
        instructions: json["instructions"] == null
            ? null
            : List<String>.from(
                json["instructions"].map(
                  (x) => x,
                ),
              ),
      );

  Map<String, dynamic> toJson() => {"name": name, "image": image};

  @override
  String toString() {
    return 'Menu(name: $name, image: $image, ingredients: $ingredients, instructions: $instructions)';
  }
}
