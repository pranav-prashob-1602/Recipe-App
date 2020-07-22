import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import 'recipe_item.dart';

class RecipesGrid extends StatelessWidget {
  final bool showFavs;

  RecipesGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    var bodyRendered = false;
    final recipesData = Provider.of<Recipes>(context);
    final recipes = showFavs ? recipesData.favouriteItems : recipesData.items;
    if (recipes.length < 1) {
      bodyRendered = true;
    }
    return bodyRendered
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Recipes to your Favourites',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed',
                  ),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: recipes[i],
              child: RecipeItem(),
            ),
            itemCount: recipes.length,
          );
  }
}
