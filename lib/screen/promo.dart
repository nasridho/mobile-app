import 'package:baru/constant.dart';
import 'package:flutter/material.dart';

import '../fitur/formatRupiah.dart';

class PromoScreen extends StatelessWidget {
  
  
  const PromoScreen( {
    Key? key,
 

  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
    

      body: SingleChildScrollView(
        child: Column (
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: isPortrait? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 1,
              child: Image(image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/firestore-demo-face4.appspot.com/o/MIYO.png?alt=media&token=58bddb89-3ba3-45a2-87c8-be21f1227cec"), fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: Text("Kontes berhadiah!", style: TextStyle(color: kThirdColor, fontSize: 20, fontWeight: FontWeight.bold) ),
                    ),
                   
                    
                  
                  ]
                ),
              ),
            ),
 
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16,0,8,0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text("Bagi reseller/dropshipher yang melakukan penjualan terbanyak selama bulan Oktober 2022 ini, akan mendapatkan hadiah berupa motor.")
                      ],
                    ),
                  ),
                ),
              ],
            ),

            

          ],
        ),
      )
    );
  }
}