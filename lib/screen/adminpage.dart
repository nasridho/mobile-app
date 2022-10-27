
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =  FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Text('Login Sebagai Admin ${user.email!}'),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50)
            ),
            icon: Icon(Icons.arrow_back, size: 32),
            label: Text(
              'Sign Out',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
    );
  }
}