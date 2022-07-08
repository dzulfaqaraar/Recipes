import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/utils/colors.dart';
import 'package:recipes/pages/detail/detail_screen.dart';

import 'package:recipes/model/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe>? recipes;
  Recipe? selectedRecipe;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () async {
      var jsonText = await rootBundle.loadString('assets/data.json');

      setState(() {
        List<dynamic> data = json.decode(jsonText);
        recipes = List<Recipe>.from(data.map((x) {
          return Recipe.fromJson(x);
        }));
        selectedRecipe = recipes?.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkOrange.withOpacity(0.8),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 1200) {
            final isMobile = constraints.maxWidth <= 600;
            return CustomScrollView(
              slivers: [
                const _HomeAppBar(),
                const _HomePopularTitle(),
                if (recipes != null)
                  _HomePopularItem(
                    recipes: recipes,
                    onSelected: (recipe) {
                      setState(() {
                        selectedRecipe = recipe;
                      });
                    },
                  ),
                const _HomeMenuTitle(),
                if (selectedRecipe != null)
                  isMobile
                      ? _HomeMenuItemMobile(selectedRecipe: selectedRecipe)
                      : _HomeMenuItemTablet(selectedRecipe: selectedRecipe)
              ],
            );
          } else {
            final screenWidth = MediaQuery.of(context).size.width;
            return Center(
              child: SizedBox(
                width: screenWidth <= 1200 ? 900 : 1200,
                child: CustomScrollView(
                  slivers: [
                    const _HomeAppBar(),
                    const _HomePopularTitle(),
                    if (recipes != null)
                      _HomePopularItem(
                        recipes: recipes,
                        onSelected: (recipe) {
                          setState(() {
                            selectedRecipe = recipe;
                          });
                        },
                      ),
                    const _HomeMenuTitle(),
                    if (selectedRecipe != null)
                      _HomeMenuItemWeb(selectedRecipe: selectedRecipe)
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text(
        "Recipe",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0,
    );
  }
}

class _HomePopularTitle extends StatelessWidget {
  const _HomePopularTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: veryDarkOrange),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: const Center(
            child: Text(
          'Popular Ingredients',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}

class _HomePopularItem extends StatelessWidget {
  final List<Recipe>? recipes;
  final Function onSelected;

  const _HomePopularItem({
    Key? key,
    required this.recipes,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          if (recipes != null)
            ...recipes!.map((recipe) {
              return Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      onSelected(recipe);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            'assets/ingredient/${recipe.image}',
                            width: 200,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class _HomeMenuTitle extends StatelessWidget {
  const _HomeMenuTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: veryDarkOrange),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: const Center(
            child: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}

class _HomeMenuItemMobile extends StatelessWidget {
  final Recipe? selectedRecipe;

  const _HomeMenuItemMobile({
    Key? key,
    required this.selectedRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var menus = selectedRecipe?.menu;
          if (selectedRecipe != null && menus != null) {
            var menu = menus[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DetailPage(menu: menu);
                    },
                  ));
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: menu.image,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/menu/${menu.image}',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          menu.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total ingredients: ${menu.ingredients?.length ?? 0}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: selectedRecipe?.menu?.length,
      ),
    );
  }
}

class _HomeMenuItemTablet extends StatelessWidget {
  final Recipe? selectedRecipe;

  const _HomeMenuItemTablet({
    Key? key,
    required this.selectedRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var menus = selectedRecipe?.menu;
          if (selectedRecipe != null && menus != null) {
            var menu = menus[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DetailPage(menu: menu);
                    },
                  ));
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: menu.image,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/menu/${menu.image}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        menu.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total ingredients: ${menu.ingredients?.length ?? 0}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: selectedRecipe?.menu?.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
    );
  }
}

class _HomeMenuItemWeb extends StatelessWidget {
  final Recipe? selectedRecipe;

  const _HomeMenuItemWeb({
    Key? key,
    required this.selectedRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var menus = selectedRecipe?.menu;
          if (selectedRecipe != null && menus != null) {
            var menu = menus[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DetailPage(menu: menu);
                    },
                  ));
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: menu.image,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/menu/${menu.image}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        menu.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total ingredients: ${menu.ingredients?.length ?? 0}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: selectedRecipe?.menu?.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
    );
  }
}
