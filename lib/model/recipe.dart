import 'package:recipes/model/menu.dart';

class Recipe {
  String name;
  String image;
  List<Menu>? menu = [];

  Recipe({
    required this.name,
    required this.image,
    required this.menu,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        name: json["name"],
        image: json["image"],
        menu: json["menu"] == null
            ? null
            : List<Menu>.from(json["menu"].map(
                (x) => Menu.fromJson(x),
              )),
      );

  @override
  String toString() => 'Recipe(name: $name, image: $image, menu: $menu)';
}
