import 'package:flutter/material.dart';
import 'package:regalmojo/Screens/ForgotPassword/forgot_password.dart';
import 'package:regalmojo/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regalmojo/Screens/Profile/profile.dart';

class Login extends StatefulWidget {
  static const id = 'Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  bool letLogin = false;
  final _LoginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool showEmailBorder = false;
  TextEditingController passwordController = TextEditingController();
  bool showPasswordBorder = false;
  String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPageHorizontalPadding),
          child: Form(
              key: _LoginFormKey,
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
                        color: showEmailBorder ? kBorderColor : Colors.white,
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
                              letLogin = false;
                            });
                          } else {
                            setState(() {
                              showEmailBorder = false;
                              letLogin = true;
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        color: showPasswordBorder ? kBorderColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(kRoundedCorners),
                    ),
                    child: Container(
                      // color: Colors.white,
                      padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kRoundedCorners),
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
                              letLogin = false;
                            });
                          } else {
                            setState(() {
                              showPasswordBorder = false;
                              letLogin = true;
                            });
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          labelStyle: kLabelTextStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPassword.id);
                    },
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: kPageVerticalPadding * 2,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_LoginFormKey.currentState.validate()) {
                        _LoginFormKey.currentState.save();
                        String email = emailController.text.toLowerCase();
                        String password = passwordController.text;
                        if (letLogin) {
                          try {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            currentFocus.unfocus();

                            final loggedInUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                            if (loggedInUser != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Profile.id, (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'wrong-password') {
                              print('wrong-password');
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
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
