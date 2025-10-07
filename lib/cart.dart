import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
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
      
      print("Loaded items : $loadedItems");
      setState(() => quantities= loadedItems);
    }
    else
      print("Cart is Empty");


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
      if(quantities[product]! >1){
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
              icon: const Icon(Icons.delete_outline),
          )
        ],
      ),

      body: quantities.isEmpty
        ? const Center(
        child: Text("Your cart is empty",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
        ),

      )
      :Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quantities.length,
              itemBuilder: (context,index){
                final product =quantities.keys.elementAt(index);
                final qty = quantities[product]!;

                return Card(
                  margin:const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading:
                          SizedBox(
                            width: 60,
                            height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            product.image,
                        ),
                      )
                    ),

                      title: Text(product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                      subtitle: Text(
                        "\$${product.price.toStringAsFixed(2)} x $qty = \$${(product.price * qty).toStringAsFixed(2)}"),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () =>decreaseQuantity(product) ,
                              icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(qty.toString(),
                          style: const TextStyle(fontSize: 16)),
                          IconButton(
                              onPressed: () => increaseQuantity(product) ,
                              icon: Icon(Icons.add_circle_outline)
                          ),
                        ],
                      ),

                  ),
                );
              },
            )
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, -2)
                )
              ]
            ),
            
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#3f8c1b")
                    ))
                  ],
                ),


                //checkout
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async{
                      final prefs =await SharedPreferences.getInstance();
                      await prefs.remove('cart_items');
                      setState(() => quantities.clear());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: const Text("Your order is placed"),
                          backgroundColor: HexColor("#3f8c1b"),
                        )
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#3f8c1b"),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    child: const Text("Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 16))
                )
              ],
            ),
          )
        ],
      )

    );
}
}