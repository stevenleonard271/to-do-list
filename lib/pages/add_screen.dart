import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/properties/empty_button.dart';

class AddList extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String title = "";

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference todo = firestore.collection('todo');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text(
          'Add Task',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      buildTitleTask(),
                      SizedBox(height: 20),
                      buildNoteTask(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                EmptyButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        createTodos(context);
                      }
                    },
                    buttonText: 'Add Task',
                    buttonColor: Colors.teal[200]),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

  createTodos(BuildContext context) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('todo').doc(taskController.text);

    Map<String, String> todos = {
      "todoTitle": taskController.text,
      "todoDesc": descriptionController.text,
    };

    documentReference.set(todos).whenComplete(() {
      var snackBar = SnackBar(
        content: Text('Success!'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
    });
  }

  Widget buildNoteTask() => TextFormField(
        style: TextStyle(fontSize: 12),
        controller: descriptionController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your task";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            // isDense: true,
            contentPadding:
                EdgeInsets.only(bottom: 50, left: 10, right: 10, top: 50),
            // prefix: Icon(Icons.lock),
            labelText: 'Description',
            hintText: 'Enter your task description',
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            fillColor: Colors.white54,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );
  Widget buildTitleTask() => TextFormField(
        style: TextStyle(fontSize: 12),
        controller: taskController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your title";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            // isDense: true,
            contentPadding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
            // prefix: Icon(Icons.lock),
            labelText: 'Title',
            hintText: 'Enter your task',
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            fillColor: Colors.white54,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );
}
