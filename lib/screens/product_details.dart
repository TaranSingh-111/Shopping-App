import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/products.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatelessWidget{
  final Product product;

  const ProductDetails({super.key, required this.product});

  Future<void> addtoCart(Product product, BuildContext context) async{
    final prefs =await SharedPreferences.getInstance();
    final data = prefs.getString('cart_items');
    List<dynamic> cart = data != null ? jsonDecode(data): [];

    bool found =false;
    for(var item in cart){
      if(item['product']['id'] == product.id){
        item['quantity'] +=1;
        found =true;
        break;
      }
    }
    if(!found){
      cart.add({'product': product.toJson(), 'quantity': 1});
    }
    await prefs.setString('cart_items', jsonEncode(cart));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
         iconTheme: IconThemeData(color: Colors.purple),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 250,
                  fit: BoxFit.contain,
              ),
            ),

            //title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                product.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
            ),

            //price
            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "\$${product.price.toString()}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),

            const Divider(),

            //description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),

            const Divider(),

            //rating
            Padding(
                padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    "${product.rating.rate} (${product.rating.count} reviews)", style: const TextStyle(fontSize: 16),
                  )
                ],
              )
            ),

            //addToCart
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))
                ),

                onPressed: (){
                  addtoCart(product, context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white),
                            children: [
                              TextSpan(text: product.title),
                              TextSpan(
                                text: ' added to cart.',
                                style: const TextStyle(fontWeight: FontWeight.bold)
                              )
                            ]
                          )
                      ),

                      backgroundColor: HexColor("#3f8c1b"),
                     behavior: SnackBarBehavior.floating,
                    )
                  );
                },
                child: const Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20)
          ],
        )
      )
    );
  }
}