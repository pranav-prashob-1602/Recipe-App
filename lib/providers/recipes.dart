import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'recipe.dart';
import '../models/http_exception.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _items = [];

  final String authToken;
  final String userId;

  Recipes(this.authToken, this.userId, this._items);

  List<Recipe> get items {
    return [..._items];
  }

  

  List<Recipe> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Recipe findById(String id) {
    return items.firstWhere(
      (prod) => prod.id == id,
    );
  }

  Future<void> fetchAndSetRecipes([bool filterByUser = false]) async {
    final filterString = filterByUser? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url ='https://recipe-app-eaa42.firebaseio.com/meals.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      url =
          'https://recipe-app-eaa42.firebaseio.com/userFavourties/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Recipe> loadedRecipes = [];
      extractedData.forEach((prodId, prodData) {
        loadedRecipes.add(Recipe(
          id: prodId,
          title: prodData['title'],
          ingredients: prodData['ingredients'],
          steps: prodData['steps'],
          price: prodData['price'],
          time: prodData['time'],
          imageUrl: prodData['imageUrl'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      _items = loadedRecipes;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    final url =
        'https://recipe-app-eaa42.firebaseio.com/meals.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': recipe.title,
            'ingredients' : recipe.ingredients,
            'steps': recipe.steps,
            'imageUrl': recipe.imageUrl,
            'price': recipe.price,
            'time' : recipe.time,
            'creatorId': userId,
          },
        ),
      );
      final newRecipe = Recipe(
        id: json.decode(response.body)['name'],
        title: recipe.title,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
        price: recipe.price,
        time: recipe.time,
        imageUrl: recipe.imageUrl,
      );
      _items.add(newRecipe);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateRecipe(String id, Recipe newRecipe) async {
    final prodindex = _items.indexWhere((prod) => prod.id == id);
    if (prodindex >= 0) {
      final url =
          'https://recipe-app-eaa42.firebaseio.com/meals/$id.json?auth=$authToken';
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': newRecipe.title,
              'ingredients' : newRecipe.ingredients,
              'steps': newRecipe.steps,
              'imageUrl': newRecipe.imageUrl,
              'price': newRecipe.price,
              'time' : newRecipe.time,
            },
          ),
        );
        _items[prodindex] = newRecipe;
        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteRecipe(String id) async {
    final url =
        'https://recipe-app-eaa42.firebaseio.com/meals/$id.json?auth=$authToken';
    final existingRecipeIndex = _items.indexWhere((prod) => prod.id == id);
    var existingRecipe = _items[existingRecipeIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingRecipeIndex, existingRecipe);
      notifyListeners();
      throw HttpException('Could not delete recipe.');
    }
    existingRecipe = null;
  }
}
