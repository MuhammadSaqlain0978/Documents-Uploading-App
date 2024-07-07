import 'dart:io';
import 'package:docup_app/Widgets/round_button.dart';

import 'package:docup_app/UI/uploaded_list/Retrive_image_w_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageWithTextScreen extends StatefulWidget {
  const UploadImageWithTextScreen({super.key});

  @override
  State<UploadImageWithTextScreen> createState() =>
      _UploadImageWithTextScreenState();
}

class _UploadImageWithTextScreenState extends State<UploadImageWithTextScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future uploadImageWithTextToFirestore(String text) async {
    if (_image == null) return;

    // Upload image to Firebase Storage
    firebase_storage.Reference ref = storage
        .ref('images_with_text/${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!);

    await uploadTask;

    // Get download URL
    String downloadUrl = await ref.getDownloadURL();

    // Save the text and download URL to Firestore
    await firestore
        .collection('PhotosWithText')
        .add({'text': text, 'url': downloadUrl});

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image and Text Uploaded Successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Image with Text'),
          backgroundColor: Colors.cyan,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: getImageGallery,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Icon(
                          Icons.image_search_outlined,
                          size: 50,
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              RoundButton(
                  title: 'Upload',
                  onTap: () {
                    uploadImageWithTextToFirestore(_textController.text);
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.remove_red_eye),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayImagesWithTextScreen()));
            }),
      ),
    );
  }
}
