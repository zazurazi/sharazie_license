import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharazie_license/pages/pdf_generator.dart';
import 'create_certificate_page.dart';
import 'dart:ui';

class CertificatePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteCertificate(String docId, BuildContext context) async {
    try {
      await _firestore.collection('certificates').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificate deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting certificate: $e')),
      );
    }
  }

  void editCertificate(BuildContext context, Map<String, dynamic> data, String docId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCertificatePage(
          certificateData: data, // Pass existing data for editing
          documentId: docId, // Pass document ID to update Firestore entry
        ),
      ),
    );
  }

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
        SnackBar(content: Text('Certificate generated for ${data['name']}!')),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/assets/logo.jpeg', height: 32),
            const SizedBox(width: 1),
            const Text("Sharazie License", style: TextStyle(fontFamily: 'SFProRounded', fontSize: 20)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;
              final docId = doc.id; // Document ID for Firestore operations

              return Dismissible(
                key: Key(docId), // Unique key
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  color: Colors.green,
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Swipe left → Edit
                    editCertificate(context, data, docId);
                    return false; // Prevent auto-dismiss after editing
                  } else if (direction == DismissDirection.endToStart) {
                    // Swipe right → Delete
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete ${data['name']}\'s certificate?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteCertificate(docId, context);
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  }
                  return false;
                },
                child: Card(
                  color: Colors.grey[200],
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.black, width: 1), // Black tiny border
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    title: Text(data['name'] ?? '', style: const TextStyle(fontFamily: 'SFProRounded')),
                    subtitle: Text(data['courseName'] ?? '', style: const TextStyle(fontFamily: 'SFProRounded')),
                    trailing: const Icon(Icons.download),
                    onTap: () => generateCertificate(context, data),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Adjust for rounded edges
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Blur effect
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCertificatePage(
                    documentId: '',
                    certificateData: {},
                  ),
                ),
              );
            },
            backgroundColor: Colors.white.withOpacity(0.1), // Semi-transparent
            elevation: 0, // No shadow
            shape: const CircleBorder(), // Keep circular shape
            child: const Icon(Icons.add, color: Colors.blue), // Visible icon
          ),
        ),
      ),
    );
  }
}
