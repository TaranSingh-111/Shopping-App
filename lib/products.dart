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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;


  Map<String, dynamic> toJson() =>{
    'id':id,
    'title': title,
    'price': price,
    'image': image
  };

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      price: (json['price']as num).toDouble() ?? 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: json['rating'] != null
          ? Rating.fromJson(Map<String, dynamic>.from(json['rating']))
          : Rating(rate: 0.0, count: 0),
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

  Map<String, dynamic> toJson() => {
    'rate': rate,
    'count': count,
  };
}
