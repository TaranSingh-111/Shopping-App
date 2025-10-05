import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/google_sign_in.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context){
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
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/036/594/092/small_2x/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg'),
            ),

          const SizedBox(height: 20),

          //Name
          const Text(
            'Taran Singh',
            style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

           //Email
            const Text(
              '123@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            //LogoutButton
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async{
                  final userCredential = await signOutGoogle();
                },
                icon: const Icon(Icons.logout),
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