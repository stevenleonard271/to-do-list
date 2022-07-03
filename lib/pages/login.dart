import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/pages/forgot_password.dart';
import 'package:to_do_list/properties/empty_button.dart';
import 'package:to_do_list/pages/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  //membuat textediting controller
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //Login Function
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print('Email belum terdaftar');
        var snackBar = SnackBar(
          content: Text('Email anda belum terdaftar'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == "wrong-password") {
        print('Email/Password anda salah');
        var snackBar = SnackBar(
          content: Text('Email/Password anda salah'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == "too-many-request") {
        // print('Email/Password anda salah');
        var snackBar = SnackBar(
          content: Text('Tunggu sebentar'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      print(e.code);
    }
    return user;
  }

  bool isHiddenPassword = true;
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage('assets/images/login.png'),
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          buildEmail(),
                          SizedBox(height: 20),
                          buildPassword(),
                        ],
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.teal[300],
                          letterSpacing: 1,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                  ),
                  SizedBox(height: 10),
                  EmptyButton(
                      onTap: () async {
                        //CEK DATA VALID
                        User? user = await loginUsingEmailPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context);
                        print('user');

                        if (formKey.currentState!.validate()) {
                          if (user != null) {
                            var snackBar = SnackBar(
                              content: Text('Anda berhasil masuk'),
                              backgroundColor: Colors.green,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          }
                        }
                        print('object');
                      },
                      buttonText: 'Log in',
                      buttonColor: Colors.teal[200]),
                  SizedBox(
                    height: 10,
                  ),
                  SafeArea(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have an Account?",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                letterSpacing: 1),
                          ),
                          SizedBox(width: 5),
                          TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: Text(
                              "Register",
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
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  // !RegExp(r'^[\w-\.@([\w-]+\.)+[\w-]{2-4}').hasMatch(value)
  Widget buildEmail() => TextFormField(
        style: TextStyle(fontSize: 12, height: 1),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your email";
          } else {
            return null;
          }
        },
        controller: _emailController,
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
