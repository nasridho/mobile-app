import 'package:baru/constant.dart';
import 'package:baru/screen/adminpage.dart';
import 'package:baru/screen/login.dart';
import 'package:baru/screen/produk.dart';
import 'package:baru/screen/promo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    PromoScreen(),
    ProdukScreen(),
    LoginScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sportiv', style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.bold),),
        backgroundColor: kMainColor,
        elevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kMainColor,
        selectedItemColor: kSecondaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}