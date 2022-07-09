class Ingredient {
  String name;
  String image;
  String description;

  Ingredient({
    required this.name,
    required this.image,
    required this.description,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        image: json["image"],
        description: json["description"],
      );

  @override
  String toString() =>
      'Ingredient(name: $name, image: $image, description: $description)';
}
