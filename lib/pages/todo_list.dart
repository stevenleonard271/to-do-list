import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/add_screen.dart';

class ToDoScreen extends StatefulWidget {
  // const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List todos = [];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference todo = firestore.collection('todo');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('todo').snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return Text('Something went wrong');
            } else if (snapshots.hasData || snapshots.data != null) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot? documentSnapshot =
                      snapshots.data?.docs[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        setState(() {
                          deleteTodos(
                              context,
                              (documentSnapshot != null
                                  ? (documentSnapshot['todoTitle'])
                                  : ""));
                        });
                      },
                      key: UniqueKey(),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(documentSnapshot != null
                              ? (documentSnapshot['todoTitle'])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? ((documentSnapshot['todoDesc']) != null)
                                  ? documentSnapshot['todoDesc']
                                  : ""
                              : ""),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  deleteTodos(
                                      context,
                                      (documentSnapshot != null
                                          ? (documentSnapshot['todoTitle'])
                                          : ""));
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      ));
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ),
            );
          }),
      floatingActionButton: addList(context),
    );
  }

  Widget addList(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.teal[200],
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddList();
        }));
      },
    );
  }

  deleteTodos(BuildContext context, item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('todo').doc(item);
    documentReference.delete().whenComplete(() {
      var snackBar = SnackBar(
        content: Text('Deleted Successfully!'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
