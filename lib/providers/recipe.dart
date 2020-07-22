import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Recipe with ChangeNotifier {
  final String id;
  final String title;
  final String ingredients;
  final String steps;
  final double price;
  final int time;
  final String imageUrl;
  bool isFavourite;

  Recipe({
    @required this.id,
    @required this.title,
    @required this.ingredients,
    @required this.steps,
    @required this.price,
    @required this.time,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://recipe-app-eaa42.firebaseio.com/userFavourties/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
