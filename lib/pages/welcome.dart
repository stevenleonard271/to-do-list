import 'package:flutter/material.dart';
import 'package:to_do_list/pages/login.dart';
import 'package:to_do_list/pages/register.dart';
import 'package:to_do_list/properties/empty_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        color: Colors.grey[200],
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/welcome_screen.png'),
                    height: 300,
                    width: 300,
                  ),
                  Text(
                    'Get things done with TODO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The getting things done method rests on the idea of moving planned tasks and projects out of the mind by recording then',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                  ),
                  SizedBox(height: 40),
                  EmptyButton(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    buttonColor: Colors.teal[200],
                    buttonText: 'Get Started',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
