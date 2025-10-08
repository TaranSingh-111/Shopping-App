import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/google_sign_in.dart';
import 'package:shopping_app/screens/login_screen.dart';
import 'package:shopping_app/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context){
    final user = FirebaseAuth.instance.currentUser;

    final photo = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: HexColor("#8549b3"),
        foregroundColor: Colors.white,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            //Image

            if(photo != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(photo),
              ),


          const SizedBox(height: 20),

          //Name
           Text(
            user?.displayName ?? "No name" ,
            style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

           //Email
            Text(
              user?.email ?? "No email" ,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            //LogoutButton
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async{
                  final prefs =await SharedPreferences.getInstance();
                  await prefs.remove('cart_items');
                 // setState(() => quantities.clear());

                  final userCredential = await signOutGoogle();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                )
              ),
            )

          ],
        ),
      ),
    );
  }
}