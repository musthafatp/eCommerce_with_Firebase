// utils/cart_and_favourites.dart
import 'package:flutter/material.dart';
import '../widgets/product_detail.dart'; // import Product model

List<Product> cartItems = [];
List<Product> favouriteItems = [];

void addToCart(Product product) {
  if (!cartItems.any((item) => item.id == product.id)) {
    cartItems.add(product);
  }
}

void toggleFavourite(Product product) {
  if (favouriteItems.any((item) => item.id == product.id)) {
    favouriteItems.removeWhere((item) => item.id == product.id);
  } else {
    favouriteItems.add(product);
  }
}

bool isFavourite(Product product) {
  return favouriteItems.any((item) => item.id == product.id);
}
