import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../widgets/user_recipe_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_recipe_screen.dart';

class UserRecipesScreen extends StatelessWidget {
  static const routeName = '/user-recipes';

  Future<void> _refreshRecipes(BuildContext context) async {
    await Provider.of<Recipes>(context, listen: false).fetchAndSetRecipes(true);
  }

  @override
  Widget build(BuildContext context) {
    // final recipesData = Provider.of<Recipes>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Recipes',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditRecipeScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshRecipes(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshRecipes(context),
                    child: Consumer<Recipes>(
                      builder: (ctx, recipesData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: recipesData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UserRecipeItem(
                                recipesData.items[i].id,
                                recipesData.items[i].title,
                                recipesData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
