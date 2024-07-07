import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayPdfOnlyScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded PDFs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('PDF Only').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No PDFs found'));
          }

          final pdfDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pdfDocs.length,
            itemBuilder: (context, index) {
              var pdfData = pdfDocs[index].data() as Map<String, dynamic>;
              var pdfUrl = pdfData['url'];

              return ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text('PDF ${index + 1}'),
                subtitle: Text(pdfUrl),
                onTap: () async {
                  if (await canLaunch(pdfUrl)) {
                    await launch(
                      pdfUrl,
                      forceSafariVC: false, // Use the default browser
                      forceWebView: false, // Do not open within the app
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open PDF')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
