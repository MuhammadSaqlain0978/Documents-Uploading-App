import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayImageAndPdfScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded Images and PDFs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('Image with Pdf')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No images or PDFs found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              var imageUrl = data['image_url'];
              var pdfUrl = data['pdf_url'];

              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(),
                    ListTile(
                      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text('PDF ${index + 1}'),
                      subtitle: Text(pdfUrl),
                      onTap: () async {
                        if (await canLaunch(pdfUrl)) {
                          await launch(pdfUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open PDF')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
