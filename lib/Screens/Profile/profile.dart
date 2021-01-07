import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:regalmojo/Screens/Register/register.dart';
import 'package:regalmojo/constants.dart';
import 'package:regalmojo/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class Profile extends StatefulWidget {
  static const id = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final auth = FirebaseAuth.instance;
  User user;
  static String currentUserId;
  String userEmail;
  String name;
  String email;
  String number;
  User loggedInUser;
  final users = FirebaseFirestore.instance.collection('Users');
  bool userLoggedIn = false;
  void getCurrentUser() {
    try {
      user = auth.currentUser;
      currentUserId = user.uid;
      userEmail = user.email;
      if (user != null) {
        loggedInUser = user;
        userLoggedIn = true;
      }
    } catch (e) {
      print(e);
    }
  }

  final _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  final List<Widget> _children = [
    GetUserName(currentUserId),
    Center(
      child: Text(
        'Click Icon in top to Logout',
        style: TextStyle(fontSize: 20.0),
      ),
    ),
  ];
  @override
  void initState() {
    getCurrentUser();
    print(currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: kPageHorizontalPadding * 2),
            child: GestureDetector(
              onTap: () {
                _auth.signOut();
                print('signed Out');
                Navigator.pushNamedAndRemoveUntil(
                    context, RegisterPage.id, (route) => false);
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.home), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout')
        ],
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Full Name: ${data['Name']}"),
              Text("Contact Number: ${data['Contact']}"),
              Text("Email: ${data['Email']}"),
              Text("DOB: ${data['DoB']}"),
              Container(
                height: 200.0,
                child: SfBarcodeGenerator(
                  value: '${data['Contact']}',
                  symbology: QRCode(),
                  showValue: true,
                ),
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
