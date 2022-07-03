import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/login.dart';

import 'package:to_do_list/properties/empty_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  // const ForgotPasswordScreen({Key? key}) : super(key: key);

  TextEditingController resetPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          margin: EdgeInsets.all(20),
          // padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      fontSize: 25),
                ),
                SizedBox(height: 20),
                Text(
                  "Please enter your email to confirm new password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
                SizedBox(height: 20),
                Image(
                  image: AssetImage('assets/images/forgot_password.png'),
                  height: 250,
                  width: 250,
                ),
                Container(margin: EdgeInsets.all(20), child: buildEmail()),
                SizedBox(height: 20),
                EmptyButton(
                    onTap: () {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: resetPasswordController.text)
                          .then((value) {
                        var snackBar = SnackBar(
                          content: Text('Success!'),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      });
                    },
                    buttonText: 'Confirm',
                    buttonColor: Colors.teal[200]),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget buildEmail() => TextFormField(
        style: TextStyle(fontSize: 12, height: 1),
        controller: resetPasswordController,
        decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
            labelText: 'Email',
            hintText: 'Enter your Email',
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            fillColor: Colors.white54,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );
}
