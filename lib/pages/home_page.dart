import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_certificate_page.dart'; // Import the CreateCertificatePage

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0; // To track the selected tab

  // List of screens to display based on the selected tab
  final List<Widget> _screens = [
    HomeScreen(), // Navigate to HomeScreen
    ProfileScreen(), // Navigate to ProfileScreen
    SignOutScreen(), // Navigate to SignOutScreen
  ];

  // Handle Sign Out
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background color for the entire screen
        child: SafeArea(
          child: _screens[_currentIndex], // Display the selected screen
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black, // Correct background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex, // Highlight the selected tab
            onTap: (int index) {
              setState(() {
                if (index == 2) {
                  _signOut();
                } else {
                  _currentIndex = index;
                }
              });
            },
            selectedItemColor: Colors.blue, // Color for selected icon
            unselectedItemColor: Colors.white, // Color for unselected icons
            backgroundColor: Colors.transparent, // Background must be transparent to match Container
            showSelectedLabels: false, // Hide labels
            showUnselectedLabels: false, // Hide labels
            iconSize: 30, // Size of icons
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Sign Out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background color for the HomeScreen
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 690, // Adjust height as needed
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
        color: Colors.white, // Set the background color
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to the CreateCertificatePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCertificatePage()),
              );
            },
            child: Image.asset(
              'lib/assets/logo.jpeg', // Replace with your logo's path
              height: 90,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SignOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'You have signed out!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
