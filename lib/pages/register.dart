import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/login.dart';
import 'package:to_do_list/properties/empty_button.dart';

class RegisterScreen extends StatefulWidget {
  // const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isHiddenPassword = true;
  final formKey = GlobalKey<FormState>();

  //membuat textediting controller
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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
                        'Welcome Onboard!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Let's help you meet up your tasks.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              buildUsername(),
                              SizedBox(height: 20),
                              buildEmail(),
                              SizedBox(height: 20),
                              buildPassword(),
                              SizedBox(height: 20),
                              TextFormField(
                                style: TextStyle(fontSize: 12, height: 1),
                                obscureText: isHiddenPassword,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value != _passwordController.text) {
                                    return "Enter correct your password";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    // isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 25, left: 10, right: 10),
                                    // prefix: Icon(Icons.lock),
                                    labelText: 'Confirm Password',
                                    hintText: 'Enter your Confirm Password ',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 13),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 12),
                                    fillColor: Colors.white54,
                                    filled: true,
                                    suffix: GestureDetector(
                                      onTap: _togglePasswordView,
                                      child: Icon(isHiddenPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      EmptyButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (User != null) {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text)
                                    .then((value) {
                                  //Kasih masuk ke firestore database
                                  return FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(value.user?.uid)
                                      .set({
                                    'name': _nameController.text,
                                    'email': _emailController.text
                                  });
                                }).then((value) {
                                  //Kalo bener keluar message bener
                                  print('Created new account');
                                  var signedSnackBar = SnackBar(
                                      content: Text('Success!!'),
                                      backgroundColor: Colors.green);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(signedSnackBar);
                                  Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }))
                                      //Kalau gagal keluar message error
                                      .onError((error, stackTrace) {
                                    print('Error ${error.toString()}');
                                    var errorSnackBar = SnackBar(
                                      content:
                                          Text('Error ${error.toString()}'),
                                      backgroundColor: Colors.red,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(errorSnackBar);
                                  });
                                });
                              }
                            }
                          },
                          buttonText: 'Register',
                          buttonColor: Colors.teal[200]),
                      SizedBox(
                        height: 20,
                      ),
                      SafeArea(
                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already Have an Account?",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      letterSpacing: 1),
                                ),
                                SizedBox(width: 1),
                                TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent)),
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }));
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal[300]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ));
  }

//Methods

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Widget buildUsername() => TextFormField(
        style: TextStyle(fontSize: 12, height: 1),
        controller: _nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your username";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            labelText: 'Fullname',
            hintText: 'Enter your Fullname',
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            fillColor: Colors.white54,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );
  Widget buildEmail() => TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your email";
          } else {
            return null;
          }
        },
        style: TextStyle(fontSize: 12, height: 1),
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
  Widget buildPassword() => TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your password";
          } else {
            return null;
          }
        },
        style: TextStyle(fontSize: 12, height: 1),
        obscureText: isHiddenPassword,
        decoration: InputDecoration(
            // isDense: true,
            contentPadding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
            // prefix: Icon(Icons.lock),
            labelText: 'Password',
            hintText: 'Enter your Password ',
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            fillColor: Colors.white54,
            filled: true,
            suffix: GestureDetector(
              onTap: _togglePasswordView,
              child: Icon(
                  isHiddenPassword ? Icons.visibility_off : Icons.visibility),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );
}
