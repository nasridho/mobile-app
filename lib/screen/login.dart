
import 'package:baru/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'adminpage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFourthColor,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return Center(child: Text("Ada masalah!"));
          } else if (snapshot.hasData){
            return AdminScreen();
          } else {
            return LoginWidget();
          }
            
        }
      )
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,16),
            child: Text('Login sebagai Admin', style: TextStyle(fontSize: 18, color: kSecondaryColor,fontWeight: FontWeight.bold)),
          ),
          Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16)
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            margin: const EdgeInsets.only(bottom: 8, top: 8),
            child: TextField(
              controller: emailController,
              style: TextStyle(color: kSecondaryColor),
              cursorColor: kSecondaryColor,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                hintStyle: TextStyle(color: kSecondaryColor),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16)
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            margin: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              obscureText: true,
              style: TextStyle(color: kSecondaryColor),
              cursorColor: kSecondaryColor,
              decoration: InputDecoration(
                labelText: 'Password',
                hintStyle: TextStyle(color: kSecondaryColor),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),

            ),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: kMainColor,
                onPrimary: kSecondaryColor,
                minimumSize: Size.fromHeight(20),
                padding: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // <-- Radius
                )
              ),
              icon: Icon(Icons.lock_open, size: 24),
              label: Text('Login', style: TextStyle(fontSize: 21)),
              onPressed: signIn,
            ),
          )
        ],
      ),
    );


  }

  Future signIn() async{

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

   
  }
}

