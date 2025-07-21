import 'package:flutter/material.dart';
import 'package:recipes/utils/colors.dart';

import 'package:recipes/model/menu.dart';

class DetailPage extends StatelessWidget {
  final Menu menu;

  const DetailPage({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: veryDarkOrange.withValues(alpha: 0.8),
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 1200) {
              final isMobile = constraints.maxWidth <= 600;
              return CustomScrollView(
                slivers: [
                  _DetailHeaderMobile(menu: menu, isMobile: isMobile),
                  const _DetailIngredientTitle(),
                  isMobile
                      ? _DetailIngredientItemList(menu: menu)
                      : _DetailIngredientItemGrid(menu: menu, gridCount: 5),
                  const _DetailInstructionTitle(),
                  _DetailInstructionItem(menu: menu)
                ],
              );
            } else {
              final screenWidth = MediaQuery.of(context).size.width;
              return Center(
                child: SizedBox(
                  width: screenWidth <= 1200 ? 900 : 1200,
                  child: CustomScrollView(
                    slivers: [
                      _DetailHeaderWeb(menu: menu),
                      const _DetailIngredientTitle(),
                      _DetailIngredientItemGrid(
                        menu: menu,
                        gridCount: 8,
                      ),
                      const _DetailInstructionTitle(),
                      _DetailInstructionItem(menu: menu)
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}

class _DetailHeaderMobile extends StatelessWidget {
  final Menu menu;
  final bool isMobile;

  const _DetailHeaderMobile({
    super.key,
    required this.menu,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: menu.image,
              child: Image.asset(
                'assets/menu/${menu.image}',
              ),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: veryDarkOrange,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Center(
              child: Container(
                width: isMobile ? 300 : 480,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                  color: veryDarkOrange.withValues(alpha: 0.9),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  menu.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeaderWeb extends StatelessWidget {
  const _DetailHeaderWeb({
    super.key,
    required this.menu,
  });

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: veryDarkOrange),
            padding: const EdgeInsets.symmetric(vertical: 32),
            width: double.infinity,
            child: Center(
              child: Text(
                menu.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Card(
              color: darkOrange,
              child: Hero(
                tag: menu.image,
                child: Center(
                  child: Image.asset(
                    'assets/menu/${menu.image}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailIngredientTitle extends StatelessWidget {
  const _DetailIngredientTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: veryDarkOrange),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: const Center(
            child: Text(
          'Ingredients',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}

class _DetailIngredientItemList extends StatelessWidget {
  final Menu menu;

  const _DetailIngredientItemList({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var ingredients = menu.ingredients;
          if (ingredients != null) {
            var ingredient = ingredients[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange,
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ingredient/${ingredient.image}',
                    fit: BoxFit.fitHeight,
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ingredient.name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ingredient.description,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: menu.ingredients?.length,
      ),
    );
  }
}

class _DetailIngredientItemGrid extends StatelessWidget {
  final Menu menu;
  final int gridCount;

  const _DetailIngredientItemGrid({
    super.key,
    required this.menu,
    required this.gridCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var ingredients = menu.ingredients;
          if (ingredients != null) {
            var ingredient = ingredients[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange,
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      ingredient.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/ingredient/${ingredient.image}',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    flex: 1,
                    child: Text(
                      ingredient.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: menu.ingredients?.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
      ),
    );
  }
}

class _DetailInstructionTitle extends StatelessWidget {
  const _DetailInstructionTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: veryDarkOrange),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: const Center(
            child: Text(
          'Instructions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}

class _DetailInstructionItem extends StatelessWidget {
  const _DetailInstructionItem({
    super.key,
    required this.menu,
  });

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var instructions = menu.instructions;
          if (instructions != null) {
            var instruction = instructions[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    instruction,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        childCount: menu.instructions?.length,
      ),
    );
  }
}
