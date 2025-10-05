import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product{
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({required this.id, required this.title, required this.price, required this.description, required this.category,
      required this.image, required this.rating});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price']as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }

 static Future<List<Product>> fetchProducts() async{
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    }
    else{
      throw Exception('Failed to load products');
    }
  }
}

class Rating{
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json){
    return Rating(rate:(json['rate' ]as num).toDouble(), count: json['count']);
  }
}
