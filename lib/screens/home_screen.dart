import 'package:flutter/material.dart';
import 'package:shopping_app/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/screens/product_details.dart';
import 'package:shopping_app/screens/profile_screen.dart';
class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#ffedfe"),
      appBar: AppBar(
          title: Text("Products", style: TextStyle(color: Colors.white, fontSize: 25)),
           backgroundColor: HexColor("#8549b3"),
          actions: [

            //shoppingCart
            IconButton(
              onPressed: (){

              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30, ),
            ),


            //profile
            IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen())
                  );
                },
                icon: const Icon(Icons.person, color: Colors.white, size: 30)
            )
          ],
      ),


      body: FutureBuilder<List<Product>>(
        future: Product.fetchProducts(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: SpinKitWaveSpinner(color: Colors.purple, size: 100, duration: Duration(milliseconds: 1500),));
          }
          else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          }
          else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No products found'),);
          }
          else
            {
              final products = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
                itemCount: products.length,
                itemBuilder: (context, index){
                  final product = products[index];

                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetails(product: product))
                      );
                    },
                    child:  Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Image.network(
                          product.image,
                          height: 150,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress){
                            if(loadingProgress == null){
                              return child;
                            }
                            return const Center(child: SpinKitWave(color: Colors.deepPurpleAccent, itemCount: 5, duration: Duration(milliseconds: 1000),));
                          },
                        ),
                        Padding(padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.title,
                          maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        )
                        ),
                        Text('\$${product.price.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                          )
                        ),

                      ],
                    )
                  )
                  );
                },
              );
            }
        }
      )
    );
  }
}
