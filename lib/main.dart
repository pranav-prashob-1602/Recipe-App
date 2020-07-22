import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/recipe_detail_screen.dart';
import 'providers/recipes.dart';
import './providers/auth.dart';
import 'screens/user_recipes_screen.dart';
import 'screens/edit_recipe_screen.dart';
import './screens/auth-screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';
import './screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Recipes>(
          update: (ctx, auth, previousRecipes) => Recipes(
            auth.token,
            auth.userId,
            previousRecipes == null ? [] : previousRecipes.items,
          ),
          create: (ctx) => Recipes(null, null, []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Recipe App',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amber,
            canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline6: TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                  ),
                ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            RecipeDetailScreen.routeName: (ctx) => RecipeDetailScreen(),
            UserRecipesScreen.routeName: (ctx) => UserRecipesScreen(),
            EditRecipeScreen.routeName: (ctx) => EditRecipeScreen(),
          },
        ),
      ),
    );
  }
}
