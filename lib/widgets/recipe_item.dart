import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe.dart';
import '../providers/auth.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipe>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          RecipeDetailScreen.routeName,
          arguments: recipe.id,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        size: 25,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${recipe.time} min',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        size: 25,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${recipe.price}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Consumer<Recipe>(
                    builder: (ctx, recipe, _) => IconButton(
                      icon: Icon(
                        recipe.isFavourite ? Icons.star : Icons.star_border,
                        size: 30,
                      ),
                      onPressed: () {
                        recipe.toggleFavouriteStatus(
                            authData.token, authData.userId);
                      },
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
