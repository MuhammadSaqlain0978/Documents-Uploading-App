import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:docup_app/UI/auth/login_screen.dart';
import 'package:docup_app/UI/posts/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayTextOnly extends StatefulWidget {
  const DisplayTextOnly({super.key});

  @override
  State<DisplayTextOnly> createState() => _DisplayTextOnlyState();
}

class _DisplayTextOnlyState extends State<DisplayTextOnly> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore =
      FirebaseFirestore.instance.collection('Text Only').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Uploaded Text')),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
                icon: Icon(Icons.logout)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (BuildContext contex,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();

                  if (snapshot.hasError) return Text('Error Occured');

                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, Index) {
                            return ListTile(
                              title: Text(snapshot
                                  .data!.docs[Index]['Text Data']
                                  .toString()),
                            );
                          }));
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadScreen()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
