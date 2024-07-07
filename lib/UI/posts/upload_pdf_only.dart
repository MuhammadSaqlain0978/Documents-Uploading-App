import 'dart:io';
import 'package:docup_app/Widgets/round_button.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_only.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  File? _pdf;
  firebase_storage.FirebaseStorage storage =
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

  Future<void> uploadPdfToFirestore() async {
    if (_pdf == null) return;

    // Upload PDF to Firebase Storage
    firebase_storage.Reference ref =
        storage.ref('PDF only/${DateTime.now().millisecondsSinceEpoch}.pdf');
    firebase_storage.UploadTask uploadTask = ref.putFile(_pdf!);

    await uploadTask;

    // Get download URL
    String downloadUrl = await ref.getDownloadURL();

    // Save the download URL to Firestore
    await firestore.collection('PDF Only').add({'url': downloadUrl});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('PDF Uploaded Successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF Only'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                            Icon(Icons.picture_as_pdf_outlined,
                                size: 50, color: Colors.red),
                            SizedBox(height: 10),
                            Text('Selected PDF: ${_pdf!.path.split('/').last}',
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
            RoundButton(
              title: 'Upload',
              onTap: uploadPdfToFirestore,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.remove_red_eye),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPdfOnlyScreen()));
          }),
    );
  }
}
