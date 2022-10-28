
import 'package:baru/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool edit = false;
  TextEditingController controllerWA = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user =  FirebaseAuth.instance.currentUser!;

    return Padding(
      padding: EdgeInsets.all(32),
      child: ListView(
        children: [
          Column(
          children: [
            Text('Login Sebagai Admin!'),
            Text('Halo, ${user.email!}'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: kMainColor,
                onPrimary: kSecondaryColor,
                minimumSize: Size.fromHeight(50)
              ),
              icon: Icon(Icons.arrow_back, size: 32),
              label: Text(
                'Sign Out',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
            SizedBox(
              height: 40,
            ),
            Text('Nomer WhatsApp'),
            Text(wa, style: TextStyle(fontSize: 24)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kMainColor,
                onPrimary: kSecondaryColor,
              ),
              child: Text(
                'Edit',
              ),
              onPressed: () {
                setState(() {
                  controllerWA.text = wa;
                  edit = true;
                });
              },
            ),

            if (edit == true)
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16)
                  ),
                  
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerWA,
                      style: TextStyle(color: kSecondaryColor),
                                      decoration: const InputDecoration(
                                        labelText: 'Edit WA',
                                        hintStyle: TextStyle(color: kThirdColor),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kMainColor,
                    onPrimary: kSecondaryColor,
                  ),
                  child: Text(
                    'Save',
                  ),
                  onPressed: () {
                    setState(() {
                      wa = controllerWA.text;
                      edit = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 100,
        )
        ]
      ),
    );
  }

}