import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product ({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavorite = false
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
  } 

  Future<void> toggleIsFavorite(String? token, String? userId) async{
    final oldStatus = !isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url), 
        body: json.encode({
         isFavorite
        })
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}