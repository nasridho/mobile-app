import 'package:baru/constant.dart';
import 'package:flutter/material.dart';

import '../fitur/formatRupiah.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String jenis;
  final String brand;
  final String gambar;
  final double harga;
  final double banderol;
  final Map ukuran;
  
  const DetailScreen( {
    Key? key,
    required this.name,
    required this.jenis,
    required this.brand,
    required this.ukuran,
    required this.gambar,
    required this.harga,
    required this.banderol

  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('Detail Produk', style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.bold),),
        backgroundColor: kMainColor,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column (
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: isPortrait? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 1,
              child: Image(image: NetworkImage(gambar), fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text("${brand}  ", style: TextStyle(color: kThirdColor, fontSize: 20) ),
                          Container(
                            padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kSecondaryColor
                            ),
                            child: Text(jenis, style: TextStyle(color: kWhite, fontSize: 15) )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: kSecondaryColor)),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Harga Retail:"),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text('${CurrencyFormat.convertToIdr(banderol.toInt(), 0)}', style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Harga Sportiv:"),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text('${CurrencyFormat.convertToIdr(harga.toInt(), 0)}', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,16,0,0),
                      child: Text("Stok Ukuran:"),
                    )  
                  ]
                ),
              ),
            ),
 
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16,0,0,0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4,
                          children:  
                            ukuran.map((key, value) => MapEntry(key, 
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kMainColor
                                ),
                                child: Text('${key.replaceAll('"', '')} (${value})', style:  TextStyle(fontSize: 14) ),
                              )
                            )).values.toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Untuk pemesanan hubungi WhatsApp:", style: TextStyle(color: kThirdColor, fontSize: 16) ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 32),
                      child: Text(wa, style: TextStyle(color: kThirdColor, fontSize: 28, fontWeight: FontWeight.w700) ),
                    ),
                    
                  ]
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}