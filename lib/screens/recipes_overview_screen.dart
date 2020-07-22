import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/recipes_grid.dart';
import '../widgets/app_drawer.dart';
import '../providers/recipes.dart';

enum FilterOptions {
  Favourites,
  All,
}

class RecipesOverviewScreens extends StatefulWidget {
  @override
  _RecipesOverviewScreensState createState() =>
      _RecipesOverviewScreensState();
}

class _RecipesOverviewScreensState extends State<RecipesOverviewScreens> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   // Provider.of<Recipes>(context).fetchAndSetRecipes(); //WON'T WORK!!
  //   // Future.delayed(Duration.zero).then((_) {
  //   //   Provider.of<Recipes>(context).fetchAndSetRecipes();
  //   // });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Recipes>(context).fetchAndSetRecipes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe App',
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favourites',
                ),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RecipesGrid(_showOnlyFavourites),
    );
  }
}
