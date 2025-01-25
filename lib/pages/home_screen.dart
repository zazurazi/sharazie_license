import 'package:flutter/material.dart';
import 'certificate_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 690,
                child: Image.asset(
                  'lib/assets/home.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CertificatePage()),
              );
            },
            child: Image.asset(
              'lib/assets/logo.jpeg',
              height: 90,
            ),
          ),
        ),
      ),
    );
  }
}
