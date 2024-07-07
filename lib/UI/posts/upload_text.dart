import 'package:docup_app/UI/uploaded_list/Retrive_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docup_app/Widgets/round_button.dart'; // Ensure this import is correct according to your project structure

class UploadTextScreen extends StatefulWidget {
  @override
  _UploadTextScreenState createState() => _UploadTextScreenState();
}

class _UploadTextScreenState extends State<UploadTextScreen> {
  final TextEditingController _textController = TextEditingController();

  final AddTextController = TextEditingController();
  final AddTextController1 = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('Text Only');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Text'),
          backgroundColor: Colors.cyan,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: AddTextController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Thoughts',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              RoundButton(
                title: 'Upload',
                onTap: () async {
                  String id = DateTime.now().microsecond.toString();

                  await firestore.doc().set({
                    'Text Data': AddTextController.text.toString(),
                    'id': id,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text uploaded successfully!'),
                    ),
                  );

                  AddTextController
                      .clear(); // Clear the text field after upload
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.remove_red_eye),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DisplayTextOnly()));
            }),
      ),
    );
  }
}
