import 'dart:io';
import 'package:docup_app/Widgets/round_button.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_Text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class UploadPdfWithTextScreen extends StatefulWidget {
  const UploadPdfWithTextScreen({super.key});

  @override
  State<UploadPdfWithTextScreen> createState() =>
      _UploadPdfWithTextScreenState();
}

class _UploadPdfWithTextScreenState extends State<UploadPdfWithTextScreen> {
  File? _pdf;
  final TextEditingController _textController = TextEditingController();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdf = File(result.files.single.path!);
      });
    } else {
      print('No file selected');
    }
  }

  Future uploadPdfWithTextToFirestore(String text) async {
    if (_pdf == null) return;

    // Upload PDF to Firebase Storage
    firebase_storage.Reference ref = storage
        .ref('pdf_with_text/${DateTime.now().millisecondsSinceEpoch}.pdf');
    firebase_storage.UploadTask uploadTask = ref.putFile(_pdf!);

    await uploadTask;

    // Get download URL
    String downloadUrl = await ref.getDownloadURL();

    // Save the text and download URL to Firestore
    await firestore
        .collection('PDF with Text')
        .add({'text': text, 'url': downloadUrl});

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF and Text Uploaded Successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF with Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickPdf,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _pdf != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 50, color: Colors.red),
                              SizedBox(height: 10),
                              Text('PDF Selected',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Tap to select PDF',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              RoundButton(
                  title: 'Upload',
                  onTap: () {
                    uploadPdfWithTextToFirestore(_textController.text);
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.remove_red_eye),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPdfWithTextScreen()));
          }),
    );
  }
}
