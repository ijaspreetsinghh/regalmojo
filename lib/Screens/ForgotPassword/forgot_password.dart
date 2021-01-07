import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regalmojo/constants.dart';

class ForgotPassword extends StatefulWidget {
  static const id = 'ForgotPassword';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showEmailBorder = false;
  TextEditingController emailController = TextEditingController();
  final _ForgotPasswordFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPageHorizontalPadding),
          child: Form(
            key: _ForgotPasswordFormKey,
            child: Column(
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
                          });
                        } else {
                          setState(() {
                            showEmailBorder = false;
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
                          borderRadius: BorderRadius.circular(kRoundedCorners),
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
                    String email = emailController.text.toLowerCase();
                    if (_ForgotPasswordFormKey.currentState.validate()) {
                      _ForgotPasswordFormKey.currentState.save();
                      if (!showEmailBorder) {
                        try {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          currentFocus.unfocus();

                          await _auth.sendPasswordResetEmail(email: email);
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('email not registered');
                          }
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
                    'Get password reset link',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
