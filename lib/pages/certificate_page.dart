import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase Firestore package
import 'pdf_generator.dart'; // Import your PDF generator file

class CertificatePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateCertificate(BuildContext context, Map<String, dynamic> data) async {
    try {
      await generateCertificatePdf(
        certificateNumber: data['certificateNumber'] ?? '',
        referenceNumber: data['referenceNumber'] ?? '',
        name: data['name'] ?? '',
        idNumber: data['idNumber'] ?? '',
        courseDate: data['courseDate'] ?? '',
        academyName: data['academyName'] ?? '',
        academyEntity: data['academyEntity'] ?? '',
        recognizedBy: data['recognizedBy'] ?? '',
        courseName: data['courseName'] ?? '',
        location: data['location'] ?? '',
        instructorName: data['instructorName'] ?? '',
        instructorCertificateNumber: data['instructorCertificateNumber'] ?? '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Certificate successfully generated for ${data['name']}!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating certificate: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificates"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('certificates').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data: ${snapshot.error}'));
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(child: Text('No certificates available.'));
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(data['name'] ?? ''),
                  subtitle: Text(data['courseName'] ?? ''),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    generateCertificate(context, data);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
