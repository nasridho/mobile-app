

import 'dart:convert';
import 'dart:io';
import 'package:baru/constant.dart';
import 'package:baru/screen/detail_produk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baru/screen/login.dart';
import 'package:baru/screen/promo.dart';
import 'package:file_picker/file_picker.dart';

import 'package:baru/fitur/formatRupiah.dart';





class ProdukScreen extends StatefulWidget {
  const ProdukScreen({Key? key}) : super(key: key);

  @override
  _ProdukScreenState createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {

  // text fields' controllers
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;
  
  String cari = '';
  List<String> gambars = [];

  Map<dynamic,dynamic> ukurans = {};
  List onlyKey= [];
  List onlyValue= [];

  bool tombol = true;  

  List<TextEditingController> controllersKey = []; 
  List<TextEditingController> controllersValue = []; 

  Map<String, int> dataUkuran = {};
  

  String salahFile = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _banderolController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();
  
  final TextEditingController _ukuranController = TextEditingController();

  
  String ujang = "https://firebasestorage.googleapis.com/v0/b/firestore-demo-face4.appspot.com/o/files%2F20221021_005520.jpg?alt=media&token=d8bf60c7-d49d-42e8-b218-989e6e198811";
  String fileUrl = "hoi".replaceAll(new RegExp(r'(\?alt).*'), '');

  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('products');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product

  
  
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    PlatformFile? pickedFile;
    UploadTask? uploadTask;


    
    String pesan = '';
    
    Future uploadFile() async {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
    }

    Future selectFile() async {
      final result = await FilePicker.platform.pickFiles();
      if (result == null ) return;

      setState(() {
        pickedFile = result.files.first;
      });
    }

    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _gambarController.text = documentSnapshot['gambar'];
      _nameController.text = documentSnapshot['name'];
      _brandController.text = documentSnapshot['brand'];
      _jenisController.text = documentSnapshot['jenis'];
      _priceController.text = documentSnapshot['price'].toInt().toString();
      _banderolController.text = documentSnapshot['banderol'].toInt().toString();
      _ukuranController.text = documentSnapshot['size'].toString();

    }

    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStax){
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.1,
                maxChildSize: 0.7,
                builder: (_, controller) {
                  return SingleChildScrollView (
                    controller: controller,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          // prevent the soft keyboard from covering text fields
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  if (action == "create")
                                  Container (
                                      width: 116,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                      ),
                                      
                                  ),

                                  if (action == "update")
                                  Container (
                                      width: 116,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(image: NetworkImage(_gambarController.text.toString()),fit: BoxFit.cover)
                                      ),
                                  ),                       
                                ],
                              ),
                              if (pickedFile!=null)
                              Text(" -> "),
                              Column(
                                children: [
                                  if (pickedFile!=null)
                                    Container (
                                        width: 116,
                                        height: 96,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black)
                                        ),
                                        child: Image.file(
                                          File(pickedFile!.path!),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                ],
                              )
                            ],
                          ),
                          

                          
                          
                          ElevatedButton(
                            onPressed: () async {
                            final result = await FilePicker.platform.pickFiles();
                                
                                if (result == null ) return;
                                pickedFile = result.files.first;
                                
                                if (gambars.contains(pickedFile!.name)) {
                                  setStax(() {
                                    pesan = "Nama file sama sudah ada, harap ganti file lain!";
                                    salahFile = "salah";
                                    pickedFile = null;
                                  });
                                } else {
                                  setStax(() {
                                  pesan = "Gambar terpilih, siap diupload";
                                  pickedFile = result.files.first;
                                  salahFile = "";
                                }); 
                                }
                                
                            },
                            child: Text(action == 'create' ? 'Tambah Gambar' : 'Ganti Gambar',),
                            style: ElevatedButton.styleFrom(
                              primary: kMainColor,
                              onPrimary: kSecondaryColor,
                              padding: EdgeInsets.all(8),
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )
                            )
                          ),
                          Text(pesan),
                          // Text(gambars.toString()),
                      
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: _brandController,
                              style: TextStyle(color: kSecondaryColor),
                              decoration: const InputDecoration(
                                labelText: 'Brand',
                                hintStyle: TextStyle(color: kThirdColor),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),


                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(color: kSecondaryColor),
                              decoration: const InputDecoration(
                                labelText: 'Nama',
                                hintStyle: TextStyle(color: kThirdColor),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: _jenisController,
                              style: TextStyle(color: kSecondaryColor),
                              decoration: const InputDecoration(
                                labelText: 'Jenis Produk',
                                hintStyle: TextStyle(color: kThirdColor),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          

                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              controller: _priceController,
                              style: TextStyle(color: kSecondaryColor),
                              decoration: const InputDecoration(
                                labelText: 'Harga Sportiv',
                                hintStyle: TextStyle(color: kThirdColor),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              )
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              controller: _banderolController,
                              style: TextStyle(color: kSecondaryColor),
                              decoration: const InputDecoration(
                                labelText: 'Harga Banderol',
                                hintStyle: TextStyle(color: kThirdColor),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              )
                            ),
                          ),

                          // Text(ukurans.toString()),
                          // Text(onlyKey.toString()),
                          Text(onlyValue.toString()),
                          // Text(dataUkuran.toString()),
                          // Text(controllersKey.toString()),
                          Text(ukurans.toString()),

                          
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (tombol == false ) { return; } else {
                                    if (action == "update") {
                                      setStax(() {
                                        final jsonString = _ukuranController.text.toString();
                                        final decodedMap = json.decode(jsonString);
                                        ukurans = decodedMap;
                                        ukurans.keys.forEach((k) => onlyKey.add(k));
                                        ukurans.values.forEach((k) => onlyValue.add(k));
                                        tombol = false;

                                        
                                        for (var i = 0; i<onlyKey.length; i++){
                                          TextEditingController controllerKey = TextEditingController();
                                          TextEditingController controllerValue = TextEditingController();
                                          controllersKey.add(controllerKey);
                                          controllersKey[i].text = onlyKey[i];
                                          controllersValue.add(controllerValue);
                                          controllersValue[i].text = onlyValue[i].toString();
                                        }
                                      });
                                    } else if (action == "create") {

                                      setStax(() {
                                        ukurans = {"isi":0};
                                        ukurans.keys.forEach((k) => onlyKey.add(k));
                                        ukurans.values.forEach((k) => onlyValue.add(k));
                                        tombol = false;

                                        
                                        for (var i = 0; i<onlyKey.length; i++){
                                          TextEditingController controllerKey = TextEditingController();
                                          TextEditingController controllerValue = TextEditingController();
                                          controllersKey.add(controllerKey);
                                          controllersKey[i].text = onlyKey[i];
                                          controllersValue.add(controllerValue);
                                          controllersValue[i].text = onlyValue[i].toString();
                                        }
                                      });

                                    }
                                  
                                  }
                                }, 
                                child: Text(action == 'create' ? 'Tambah Stock' : 'Edit Stock',),
                                style: ElevatedButton.styleFrom(
                                  primary: kSecondaryColor,
                                  onPrimary: kMainColor,
                                  padding: EdgeInsets.all(8),
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )  
                                )
                              ),
                              (!tombol) ?  Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kWhite,
                                    onPrimary: kSecondaryColor,
                                    padding: EdgeInsets.all(8),
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )  
                                  ),
                                  onPressed:() {
                                    setStax(() {
                                      ukurans = {};
                                      tombol = true;
                                      onlyKey = [];
                                      onlyValue = [];
                                    });
                                  }, 
                                  child: Text('Batal')),
                              ) : 
                                Text(""),
                            ],
                          ),

                          


                          for (var i =0; i < onlyKey.length; i ++) 
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 50,
                                  child: TextField(
                                    onChanged: (value) {
                                    setStax(() {
                                      onlyKey[i] = value;
                                    });
                                  },
                                    controller: controllersKey[i],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  onChanged: (value) {
                                    setStax(() {
                                      onlyValue[i] = value;
                                    });
                                  },
                                  keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                  controller: controllersValue[i],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (onlyKey.length > 1) {
                                    setStax(() {
                                      onlyKey.removeAt(i);
                                      onlyValue.removeAt(i);
                                      controllersKey.removeAt(i);
                                      controllersValue.removeAt(i);
                                    });
                                  }
                                },
                                child: Icon( 
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: CircleBorder(), 
                                  padding: EdgeInsets.all(8),
                                ),
                              ),
                              if (i == onlyKey.length-1)
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setStax(() {
                                        TextEditingController controllerKey = TextEditingController();
                                        TextEditingController controllerValue = TextEditingController();
                                        controllersKey.add(controllerKey);
                                        onlyKey.add("isi");
                                        onlyValue.add(0);
                                        controllersKey[onlyKey.length-1].text = onlyKey[onlyKey.length-1];
                                        controllersValue.add(controllerValue);
                                        controllersValue[onlyValue.length-1].text = onlyValue[onlyValue.length-1].toString();
                                        
                                      });
                                    },
                                    child: Icon( 
                                      Icons.add,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(), 
                                      padding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ],
                              ),
                              // Text("${onlyKey[i]} : ${onlyValue[i]} ")
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          ElevatedButton(
                            child: Text(action == 'create' ? 'Create' : 'Update'),
                            onPressed: () async {
                              String? gambarnya = _gambarController.text;
                              
                              
                              if (pickedFile!=null){
                              final path = 'files/${pickedFile!.name}';
                              final file = File(pickedFile!.path!);
                              
                              final ref = FirebaseStorage.instance.ref().child(path);

                              uploadTask = ref.putFile(file);

                              final snapshot = await uploadTask!.whenComplete(() {});
                              final urlDownload = await snapshot.ref.getDownloadURL();
                              gambarnya = urlDownload;
                              }

                              final String? brand = _brandController.text;
                              final String? name = _nameController.text;
                              final String? jenis = _jenisController.text;
                              final double? price = double.tryParse(_priceController.text);
                              final double? banderol = double.tryParse(_banderolController.text);
                              
                              if (onlyKey!=[]) {
                                for (var i=0; i<onlyKey.length; i++){
                                  dataUkuran.putIfAbsent('"${onlyKey[i].toString()}"', () => int.parse(onlyValue[i].toString()));
                                }
                              } 



                              print("${gambarnya}, ${brand}, ${name}, ${price}, ${dataUkuran.toString()}");
                              if (name != null && price != null && brand != null && jenis != null && banderol != null && gambarnya!= null && gambarnya!='' && salahFile!= 'salah' ) {
                                if (action == 'create') {
                                  // Persist a new product to Firestore
                                  List<String> splitList = name.trim().split(' ');
                                  List<String> indexList = [];

                                  for (int i=0; i<splitList.length; i++){
                                    for (int j=0; j<splitList[i].length+1; j++){
                                      indexList.add(splitList[i].substring(0,j).toLowerCase());
                                    }
                                  }

                                  if (dataUkuran.isEmpty){
                                    setState(() {
                                      dataUkuran = {'"isi"': 0};
                                    });
                                  }

                                  indexList.add(brand.toLowerCase());

                                  await _productss.add({"brand": brand, "jenis": jenis, "banderol": banderol, "name": name, "price": price, "gambar": gambarnya, 'searchIndex': indexList, 'size': dataUkuran});
                                }

                                if (action == 'update') {

                                  if (pickedFile!=null){
                                  FirebaseStorage.instance.refFromURL(_gambarController.text.toString()).delete();

                                  RegExpMatch? match = RegExp(r'(?<=[F]).*(?=[\?])').firstMatch(_gambarController.text.toString());
                                  if (gambars.contains(match![0].toString())) {
                                    gambars.removeWhere((item) => item == match[0].toString());
                                  } 

                                  }
                                  // Update the product
                                  List<String> splitList = name.trim().split(' ');
                                  List<String> indexList = [];
                                  
                                  for (int i=0; i<splitList.length; i++){
                                    for (int j=0; j<splitList[i].length+1; j++){
                                      indexList.add(splitList[i].substring(0,j).toLowerCase());
                                    }
                                  }

                                  indexList.add(brand.toLowerCase());

                                  await _productss
                                      .doc(documentSnapshot!.id)
                                      .update({"brand": brand, "name": name, "jenis": jenis, "banderol": banderol, "price": price, "gambar": gambarnya, 'searchIndex': indexList});

                                  if (!(dataUkuran.isEmpty)){
                                    await _productss
                                      .doc(documentSnapshot.id)
                                      .update({'size': dataUkuran});
                                  } 
                                }

                                // Clear the text fields
                                _nameController.text = '';
                                _priceController.text = '';
                                _jenisController.text = '';
                                _banderolController.text = '';
                                _brandController.text = '';
                                dataUkuran = {};
                                setState(() {
                                  ukurans = {};
                                  onlyKey = [];
                                  onlyValue = [];
                                  tombol = true;
                                  controllersValue = [];
                                  controllersKey = [];
                                });
                                
                                // Hide the bottom sheet
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kMainColor,
                              onPrimary: kSecondaryColor,
                              padding: EdgeInsets.all(8),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )  
                            )
                          ),
                        ],
                      ),
                    )
                  );
                }
              );
          });
        }
      ).whenComplete(() {
        _nameController.text = '';
        _priceController.text = '';
        _banderolController.text = '';
        _jenisController.text = '';
        _gambarController.text = '';
        _brandController.text = '';
        setState(() {
          ukurans = {};
          onlyKey = [];
          onlyValue = [];
          tombol = true;
          controllersValue = [];
          controllersKey = [];
        });
      });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId, String gambarURL) async {
    await _productss.doc(productId).delete();
    FirebaseStorage.instance.refFromURL(gambarURL).delete();

                                  RegExpMatch? match = RegExp(r'(?<=[F]).*(?=[\?])').firstMatch(gambarURL);
                                  if (gambars.contains(match![0].toString())) {
                                    gambars.removeWhere((item) => item == match[0].toString());
                                  } 
    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kFourthColor,
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: (cari == null || cari.trim() == '')
        ? FirebaseFirestore.instance.collection("products").snapshots()
        : FirebaseFirestore.instance.collection("products").where("searchIndex", arrayContains: cari.trim()).snapshots(),
        //stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          
          if (streamSnapshot.hasData) {

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight:Radius.circular(16), bottomLeft: Radius.circular(16)),
                    color: kMainColor,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kThirdColor,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: TextField(
                      style: TextStyle(color: kWhite),
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: kWhite,),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Cari brand/produk",
                        hintStyle: TextStyle(color: kFourthColor)
                      ),
                      onChanged: (value) {
                        setState(() {
                          cari = value.toLowerCase();
                        });
                      },
                    ),
                  )
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                  
                //   child: TextField(
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       hintText: "Cari brand/produk",
                //     ),
                //     onChanged: (value) {
                //       setState(() {
                //         cari = value.toLowerCase();
                //       });
                //     },
                //   )
                // ),
                Expanded(
                  child: Container(
                    child: RawScrollbar(
                        thumbColor: kSecondaryColor,
                        thickness: 4, //width of scrollbar
                        scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          
                          
                          
                          final Map<String, int> ukuran =
                          Map<String, int>.from(documentSnapshot['size']);
                          
                          

                          
                    
                          
                    
                         
                          
                          RegExpMatch? match = RegExp(r'(?<=[F]).*(?=[\?])').firstMatch(documentSnapshot['gambar']);
                          if (!gambars.contains(match![0].toString())) {
                            gambars.add(match[0].toString());
                          } 
                          
                           
                    
                          var sortedUkuran = Map.fromEntries(
                          ukuran.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

                          
                          
                          return Card(
                            color: Color.fromARGB(255, 255, 255, 255),
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Container(
                                  width: 116,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              documentSnapshot['gambar'],
                                              width: 100,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Text('${CurrencyFormat.convertToIdr(documentSnapshot['banderol'].toInt(), 0)}', style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Text('${CurrencyFormat.convertToIdr(documentSnapshot['price'].toInt(), 0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize:16)),
                                          
                                        )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width * 0.17)-116,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(documentSnapshot['brand'], style: TextStyle(color: kThirdColor, fontSize: 15) ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Text(documentSnapshot['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: kSecondaryColor)),
                                      ),
                                      Text("Stok Ukuran: "),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Wrap(
                                          spacing: 4.0,
                                          runSpacing: 4,
                                          children: 
                                          sortedUkuran
                                            .map((key, value) => MapEntry(key, 
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    color: kMainColor
                                                  ),
                                                  child: Text('${key.replaceAll('"', '')} (${value})'),
                                                )
                                              )
                                            )
                                            .values
                                            .toList(),
                                        ),
                                      )
                                      
                                    ],
                                  ),
                                ),
                                
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.1,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      IconButton(
                                          icon: const Icon(Icons.info),
                                          onPressed: () {
                                            Navigator.push(context, 
                                            MaterialPageRoute(builder: (context) => DetailScreen(
                                              name: documentSnapshot['name'],
                                              brand: documentSnapshot['brand'],
                                              ukuran: sortedUkuran,
                                              gambar:  documentSnapshot['gambar'],
                                              harga:  documentSnapshot['price'],
                                              banderol:  documentSnapshot['banderol'],
                                            )));
                                          },
                                      ),
                                      isLoggedIn?               
                                      IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _createOrUpdate(documentSnapshot)):
                                      Text(""),
                                      // This icon button is used to delete a single product
                                      isLoggedIn?
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              _deleteProduct(documentSnapshot.id,documentSnapshot['gambar'])):
                                      Text(""),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            
                          );
                        },
                      ),
                    ),
                  ),
                ),
               
              ],
            );
          }

          

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      
      // Add new product
      
      floatingActionButton: isLoggedIn ? FloatingActionButton(
        backgroundColor: kSecondaryColor,
        foregroundColor: kMainColor,
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ):Container(),
    );
    
  }

}

