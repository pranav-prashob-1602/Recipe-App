import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';

class RecipeDetailScreen extends StatelessWidget {
  static const routeName = '/recipe-detail';

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(Widget child, BuildContext context, int wigNo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: wigNo == 1
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.42,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeId = ModalRoute.of(context).settings.arguments as String;
    final loadedRecipe = Provider.of<Recipes>(
      context,
      listen: false,
    ).findById(recipeId);
    final List<String> ingredientValues =
        LineSplitter().convert(loadedRecipe.ingredients);
    print(ingredientValues.toString());
    final List<String> stepsValue = LineSplitter().convert(loadedRecipe.steps);
    print(stepsValue.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedRecipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Image.network(
                              loadedRecipe.imageUrl,
                              height: MediaQuery.of(context).size.height * 0.34,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: <Widget>[
                        buildSectionTitle(context, 'Ingredients'),
                        buildContainer(
                          ListView.builder(
                            itemBuilder: (ctx, index) => Card(
                              color: Theme.of(context).accentColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                child: Text(ingredientValues[index]),
                              ),
                            ),
                            itemCount: ingredientValues.length,
                          ),
                          context,
                          1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '# ${(index + 1)}',
                        ),
                      ),
                      title: Text(
                        stepsValue[index],
                      ),
                    ),
                    Divider(),
                  ],
                ),
                itemCount: stepsValue.length,
              ),
              context,
              0,
            )
          ],
        ),
      ),
    );
  }
}
