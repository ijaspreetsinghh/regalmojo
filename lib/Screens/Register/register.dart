import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regalmojo/Screens/Login/Login.dart';
import 'package:regalmojo/Screens/Profile/profile.dart';
import 'package:regalmojo/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  static const id = 'RegisterPage';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String currentUserId;
  bool letRegister = false;
  User loggedInUser;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        currentUserId = loggedInUser.uid;
        print(currentUserId);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(currentUserId)
        .set({
          'Name': nameController.text, // John Doe
          'Contact': contactController.text, 'Email': emailController.text,
          'DoB': dateController.text,
          // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  final _RegisterFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  var showPasswordIcon = Icon(Icons.remove_red_eye);
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _obscureText == true
          ? showPasswordIcon = Icon(Icons.short_text)
          : showPasswordIcon = Icon(Icons.remove_red_eye);
    });
  }

  TextEditingController nameController = TextEditingController();
  bool showNameBorder = false;
  TextEditingController dateController = TextEditingController();
  bool showDateBorder = false;
  TextEditingController emailController = TextEditingController();
  bool showEmailBorder = false;
  TextEditingController contactController = TextEditingController();
  bool showContactBorder = false;
  TextEditingController passwordController = TextEditingController();
  bool showPasswordBorder = false;

  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register on Regalmojo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPageHorizontalPadding),
          child: Column(
            children: [
              Form(
                  key: _RegisterFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: kPageVerticalPadding * 4,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: showNameBorder ? kBorderColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  showNameBorder = true;
                                  letRegister = false;
                                });
                              } else {
                                setState(() {
                                  showNameBorder = false;
                                  letRegister = true;
                                });
                              }
                              return null;
                            },
                            controller: nameController,
                            cursorColor: kPrimaryColor,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.perm_identity_rounded),
                              labelText: 'Full Name',
                              labelStyle: kLabelTextStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: kPageHorizontalPadding - 8,
                                  vertical: 15.0),
                              hintText: 'Enter your name here',
                              hintStyle: kHintTextStyle,
                              isDense: true,
                              isCollapsed: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kRoundedCorners),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 2,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: showDateBorder ? kBorderColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  showDateBorder = true;
                                  letRegister = false;
                                });
                              } else {
                                setState(() {
                                  showDateBorder = false;
                                  letRegister = true;
                                });
                              }
                              return null;
                            },
                            controller: dateController,
                            cursorColor: kPrimaryColor,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: 'DOB',
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                    dateController.text =
                                        "$selectedDate".split(' ')[0];
                                  },
                                  child: Icon(Icons.calendar_today_rounded)),
                              labelStyle: kLabelTextStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: kPageHorizontalPadding - 8,
                                  vertical: 15.0),
                              hintText: "yyyy-mm-dd",
                              hintStyle: kHintTextStyle,
                              isDense: true,
                              isCollapsed: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kRoundedCorners),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 2,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color:
                                showEmailBorder ? kBorderColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty ||
                                  !RegExp(emailRegex).hasMatch(value) ||
                                  value.length > 50) {
                                setState(() {
                                  showEmailBorder = true;
                                  letRegister = false;
                                });
                              } else {
                                setState(() {
                                  showEmailBorder = false;
                                  letRegister = true;
                                });
                              }
                              return null;
                            },
                            controller: emailController,
                            cursorColor: kPrimaryColor,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                              labelText: 'Email',
                              labelStyle: kLabelTextStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: kPageHorizontalPadding - 8,
                                  vertical: 15.0),
                              hintText: 'Enter your email',
                              hintStyle: kHintTextStyle,
                              isDense: true,
                              isCollapsed: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kRoundedCorners),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 2,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color:
                                showContactBorder ? kBorderColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty || value.length != 10) {
                                setState(() {
                                  showContactBorder = true;
                                  letRegister = false;
                                });
                              } else {
                                setState(() {
                                  showContactBorder = false;
                                  letRegister = true;
                                });
                              }
                              return null;
                            },
                            controller: contactController,
                            cursorColor: kPrimaryColor,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Contact Number',
                              labelStyle: kLabelTextStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: kPageHorizontalPadding - 8,
                                  vertical: 15.0),
                              hintText: '10 digit number',
                              hintStyle: kHintTextStyle,
                              isDense: true,
                              isCollapsed: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kRoundedCorners),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 2,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: showPasswordBorder
                                ? kBorderColor
                                : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Container(
                          // color: Colors.white,
                          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(kRoundedCorners),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: kPrimaryColor,
                            validator: (value) {
                              if (value.isEmpty ||
                                  value.length < 6 ||
                                  value.length > 30) {
                                setState(() {
                                  showPasswordBorder = true;
                                  letRegister = false;
                                });
                              } else {
                                setState(() {
                                  showPasswordBorder = false;
                                  letRegister = true;
                                });
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Password',
                              labelStyle: kLabelTextStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: kPageHorizontalPadding - 8,
                                  vertical: 15.0),
                              isDense: true,
                              isCollapsed: true,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _toggle();
                                },
                                child: showPasswordIcon,
                              ),
                              hintText: '6-30 character password',
                              hintStyle: kHintTextStyle,
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kRoundedCorners),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 2,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print(letRegister);
                          if (_RegisterFormKey.currentState.validate()) {
                            _RegisterFormKey.currentState.save();
                            String email = emailController.text.toLowerCase();
                            String password = passwordController.text;
                            if (letRegister) {
                              try {
                                print(letRegister);
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                currentFocus.unfocus();

                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                getCurrentUser();
                                addUser();
                                if (newUser != null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Profile.id, (route) => false);
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  print('email already registered');
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        },
                        color: kPrimaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: kPageHorizontalPadding * 1,
                            vertical: kPageVerticalPadding * 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRoundedCorners),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: kPageVerticalPadding * 3,
                      ),
                    ],
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Login.id);
                },
                child: Text(
                  'Already have an account',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
