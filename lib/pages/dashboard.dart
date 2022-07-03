import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/login.dart';
import 'package:to_do_list/pages/todo_list.dart';
import 'package:to_do_list/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    User? user;
    // return Text("Welcome " + value.data()!['name']);

    String mama = "mama";

    showText() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get()
          .then((value) {
        mama = value.data()!['name'];
      });
      return Text(mama);
      // } else {
      //   return Text('Welcome');
      // }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasData || snapshots.data != null) {
          return MaterialApp(
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: {'/login': (context) => const LoginScreen()},
            home: SafeArea(
              child: Scaffold(
                  body: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      color: Colors.teal[300],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.exit_to_app),
                                  color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Icon(Icons.exit_to_app),
                                                SizedBox(width: 10),
                                                Text('Sign out'),
                                              ],
                                            ),
                                            content: Text(
                                                'Would you like to sign out?'),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    FirebaseAuth.instance
                                                        .signOut();
                                                    print('keluar');
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/login',
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  },
                                                  child: Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No'))
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                            ClipOval(
                                child: Image.network(
                              "https://icon-library.com/images/person-png-icon/person-png-icon-29.jpg",
                              fit: BoxFit.cover,
                              width: 80.0,
                              height: 80.0,
                            )),
                            Container(
                              child: showText(),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Text(
                                'Please add your task by + button ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.list),
                            SizedBox(width: 10),
                            Text(
                              'Task List',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Flexible(flex: 9, child: ToDoScreen())
                ],
              )),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ));
        }
      },
    );
  }
}
