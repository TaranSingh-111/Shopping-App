import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'products.dart';

class Cart extends StatefulWidget{
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart>{
  Map<Product, int> quantities={};

  @override
  void initState(){
    super.initState();
    _loadCart();
  }

  //load cart

Future<void> _loadCart() async{
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart_items');
    if(cartData != null){
      final decoded = jsonDecode(cartData) as List;
      final loadedItems = <Product, int>{};
      for(var item in decoded){
        loadedItems[Product.fromJson(item['product'])] = item['quantity'];
      }
      setState(() => quantities= loadedItems);
    }
}

// save cart

Future<void> _saveCart() async{
    final prefs = await SharedPreferences.getInstance();
    final data = quantities.entries.map((entry){
      return{
        'product': entry.key.toJson(),
        'quantity':entry.value
      };
    }).toList();
    await prefs.setString('cart_items', jsonEncode(data));
}

//quantity handle
void increaseQuantity(Product product){
    setState(() {
      quantities[product] = (quantities[product] ?? 0)+1;
    });
    _saveCart();
}

void decreaseQuantity(Product product){
    setState(() {
      if(quantities[product] !>1){
        quantities[product] = quantities[product]! -1;
      }
      else{
        quantities.remove(product);
      }
    });
    _saveCart();
}
double get totalPrice{
    double total =0;
    quantities.forEach((product, qty){
      total += product.price * qty;
    });
    return total;
}


//ui
@override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: HexColor("#ffedfe"),
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: HexColor("#8549b3"),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () async{
                final prefs =await SharedPreferences.getInstance();
                await prefs.remove('cart_items');
                setState(() => quantities.clear());
              },
              icon: const Icon
          )
        ],
      ),

    )
}
}